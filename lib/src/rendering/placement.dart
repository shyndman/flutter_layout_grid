import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';
import 'package:quiver/iterables.dart';

import '../foundation/placement.dart';
import '../widgets/layout_grid.dart';
import '../widgets/placement.dart';
import 'layout_grid.dart';
import 'track_size.dart';

/// Implementation of the auto-placement algorithm, described here:
/// https://drafts.csswg.org/css-grid/#auto-placement-algo
PlacementGrid computeItemPlacement(RenderLayoutGrid grid) {
  final autoPlacement = grid.autoPlacement;
  final occupancy = PlacementGrid(grid: grid);

  final growthAxis = autoPlacement.trackType == TrackType.row
      ? Axis.vertical
      : Axis.horizontal;
  final fixedAxis = flipAxis(growthAxis);

  final fullyPlacedChildren = <RenderBox>[];
  final flowAxisPlacedChildren = <RenderBox>[];
  final toPlaceChildren = <RenderBox>[];

  // 0. Bucket children into lists based on their placement priority:
  //
  //    definitely on 2 axes > definitely on 1 axis > rest
  //
  RenderBox? child = grid.firstChild;
  while (child != null) {
    final childParentData = child.parentData as GridParentData;

    if (childParentData.areaName != null) {
      _resolveChildNamedArea(childParentData, grid);
    }

    if (childParentData.isDefinitelyPlaced) {
      fullyPlacedChildren.add(child);
    } else if (childParentData.isDefinitelyPlacedOnAxis(growthAxis)) {
      flowAxisPlacedChildren.add(child);
    } else if (childParentData.isPlaced) {
      toPlaceChildren.add(child);
    }

    child = childParentData.nextSibling;
  }

  // 1. Occupy cells with definitely placed items (have both columns and rows
  //    specified)
  for (final child in fullyPlacedChildren) {
    final childParentData = child.parentData as GridParentData;
    occupancy.addItemToArea(child, childParentData.area);
  }

  // 2. Iterate over the children definitely placed on the flow axis, finding
  //    them spots
  for (final child in flowAxisPlacedChildren) {
    final childParentData = child.parentData as GridParentData;
    final cursor = occupancy.createCursor(autoPlacement)
      ..fixToAxisIndex(childParentData.startForAxis(growthAxis), growthAxis);

    final area = cursor.moveToNextEmptyArea(
        childParentData.columnSpan, childParentData.rowSpan);
    occupancy.addItemToArea(child, area);
  }

  // 3. Distribute the rest of the children, using a cursor appropriate for the
  //    auto-flow mode.
  final autoFlowCursor = occupancy.createCursor(autoPlacement);
  for (final child in toPlaceChildren) {
    final childParentData = child.parentData as GridParentData;
    if (childParentData.isDefinitelyPlacedOnAxis(fixedAxis)) {
      autoFlowCursor.fixToAxisIndex(
          childParentData.startForAxis(fixedAxis), growthAxis);
    } else {
      autoFlowCursor.unfixFromTrack();
    }

    final area = autoFlowCursor.moveToNextEmptyArea(
        childParentData.columnSpan, childParentData.rowSpan);
    occupancy.addItemToArea(child, area);
  }

  return occupancy;
}

/// Resolves [childParentData]'s area to a concrete set of track starts and
/// spans.
void _resolveChildNamedArea(
  GridParentData childParentData,
  RenderLayoutGrid grid,
) {
  childParentData.area =
      grid.areas != null ? grid.areas![childParentData.areaName] : null;
}

/// Used to determine unoccupied space by the auto-placement algorithm.
///
/// TODO(shyndman): This would be much more space efficient for sparse or large
/// grids by using range sets or a segment tree, but that's an exercise for
/// another day. Improving space complexity is also a must-have for implicit
/// grid tracks.
///
/// Update: Looks like Chromium uses doubly linked lists to store this
/// information.
class PlacementGrid {
  PlacementGrid({
    required this.grid,
  })  : explicitColumnCount = grid.columnSizes.length,
        explicitRowCount = grid.rowSizes.length {
    _cells = List<GridCell>.generate(
        explicitColumnCount * explicitRowCount, (i) => GridCell(this, i));
  }

  final RenderLayoutGrid grid;
  final int explicitColumnCount;
  final int explicitRowCount;

  Map<RenderBox, GridArea> itemAreas = {};
  late List<GridCell> _cells;

  GridCell getCellAt(int column, int row) =>
      _cells[row * explicitColumnCount + column];

  Iterable<GridCell> getCellsInTrack(
    int trackIndex,
    TrackType trackType,
  ) sync* {
    final trackMainAxis = mainAxisForTrackType(trackType);
    final firstCellIndex = trackMainAxis == Axis.vertical
        ? trackIndex
        : trackIndex * explicitColumnCount;

    final cell = _cells.length > firstCellIndex ? _cells[firstCellIndex] : null;
    if (cell != null) {
      yield* [cell].followedBy(cell.nextCellsAlongAxis(trackMainAxis));
    }
  }

  Iterable<GridCell> getCellsInArea(GridArea area) sync* {
    for (int x = area.columnStart; x < area.columnEnd; x++) {
      for (int y = area.rowStart; y < area.rowEnd; y++) {
        yield getCellAt(x, y);
      }
    }
  }

  /// Returns `true` if the specified [area] is vacant.
  bool checkIsVacant(GridArea area) =>
      getCellsInArea(area).every((c) => c.isVacant);

  /// Creates a cursor that for traversing the grid to find vacancy.
  PlacementGridCursor createCursor(AutoPlacement autoPlacementMode) =>
      PlacementGridCursor(this, autoPlacementMode: autoPlacementMode);

  void addItemToArea(RenderBox item, GridArea area) {
    if (area.columnEnd > explicitColumnCount) {
      throw FlutterError.fromParts([
        ErrorSummary('GridPlacement.columnEnd cannot exceed column count\n'),
        grid.toDiagnosticsNode(name: 'grid'),
        item.toDiagnosticsNode(name: 'gridItem'),
      ]);
    }

    if (area.rowEnd > explicitRowCount) {
      throw FlutterError.fromParts([
        ErrorSummary('GridPlacement.rowEnd cannot exceed row count\n'),
        grid.toDiagnosticsNode(name: 'grid'),
        item.toDiagnosticsNode(name: 'gridItem'),
      ]);
    }

    for (final cell in getCellsInArea(area)) {
      cell.occupants.add(item);
    }
    itemAreas[item] = area;
  }

  @override
  String toString() {
    final cap = '┼${'-' * (explicitColumnCount * 2 - 1)}┼';
    final rows = partition(
            _cells.map((c) => c.isOccupied ? c.debugLabel ?? 'x' : ' '),
            explicitColumnCount)
        .map((row) => row.join(','));
    return '$cap\n|${rows.join('|\n|')}|\n$cap';
  }
}

/// Navigates the grid in order to find empty spots.
class PlacementGridCursor {
  PlacementGridCursor(
    this.grid, {
    this.autoPlacementMode,
  });

  final PlacementGrid grid;
  final AutoPlacement? autoPlacementMode;

  Axis get autoPlacementTraversalAxis =>
      autoPlacementMode!.trackType == TrackType.row
          ? Axis.horizontal
          : Axis.vertical;

  /// The column under the cursor
  int? currentColumn = -1;

  /// The row under the cursor
  int? currentRow = -1;

  /// The current position of the cursor on the specified axis.
  int? currentIndexOnAxis(Axis? axis) =>
      axis == Axis.horizontal ? currentColumn : currentRow;

  /// Sets the current position of the cursor on the specified axis.
  void setCurrentIndexOnAxis(int? index, Axis? axis) {
    if (axis == Axis.vertical) {
      currentRow = index;
    } else {
      currentColumn = index;
    }
  }

  int getAxisLength(Axis axis) => axis == Axis.horizontal
      ? grid.explicitColumnCount
      : grid.explicitRowCount;

  /// The index of the track that we're currently searching for space.
  int? fixedTrackIndex;

  /// horizontal for column, vertical for row
  Axis? fixedAxis;

  /// `true` if this cursor is fixed to traversing a single track
  bool get isFixedToTrack => fixedAxis != null;

  /// `true` if this cursor is fixed to an axis, but requires a
  /// [moveToNextEmptyArea] to be positioned correctly
  bool get requiresMoveToFixedAxisIndex =>
      isFixedToTrack && currentIndexOnAxis(fixedAxis) != fixedTrackIndex;

  void fixToAxisIndex(int? index, Axis axis) {
    fixedTrackIndex = index;
    fixedAxis = axis;
  }

  void unfixFromTrack() {
    fixedTrackIndex = null;
    fixedAxis = null;
  }

  GridArea moveToNextEmptyArea(int? columnSpan, int? rowSpan) {
    Iterable<GridArea> Function(int?, int?) moveFn;
    if (isFixedToTrack) {
      moveFn = _moveFixedToNext;
    } else {
      // If we're packing dense, reset the cursor positioning
      if (autoPlacementMode!.packing == AutoPlacementPacking.dense) {
        currentColumn = -1;
        currentRow = -1;
      }
      moveFn = _moveAutoToNext;
    }

    return moveFn(columnSpan, rowSpan).firstWhere(grid.checkIsVacant);
  }

  Iterable<GridArea> _moveFixedToNext(int? columnSpan, int? rowSpan) sync* {
    final traversalAxis = flipAxis(fixedAxis!);
    traversalAxisIndex() => currentIndexOnAxis(traversalAxis);

    if (requiresMoveToFixedAxisIndex) {
      if (currentColumn == -1 && currentRow == -1) {
        setCurrentIndexOnAxis(0, traversalAxis);
      } else {
        final fixedAxisIndex = currentIndexOnAxis(fixedAxis)!;
        if (fixedTrackIndex! < fixedAxisIndex) {
          setCurrentIndexOnAxis(traversalAxisIndex()! + 1, traversalAxis);
        }
      }
      setCurrentIndexOnAxis(fixedTrackIndex, fixedAxis);
      yield _currentAreaForSpans(columnSpan!, rowSpan!);
    }

    while (true) {
      setCurrentIndexOnAxis(traversalAxisIndex()! + 1, traversalAxis);
      yield _currentAreaForSpans(columnSpan!, rowSpan!);
    }
  }

  Iterable<GridArea> _moveAutoToNext(int? columnSpan, int? rowSpan) sync* {
    // The axis we will attempt to fill before moving to the next index on the
    // growth axis.
    final fixedAxis = autoPlacementTraversalAxis;
    fixedAxisIndex() => currentIndexOnAxis(fixedAxis);

    // The direction of growth of the grid.
    final growthAxis = flipAxis(autoPlacementTraversalAxis);
    growthAxisIndex() => currentIndexOnAxis(growthAxis);

    // Auto-placement flow
    while (true) {
      if (currentColumn == -1 && currentRow == -1) {
        currentColumn = currentRow = 0;
      } else if (fixedAxisIndex()! + 1 == getAxisLength(fixedAxis)) {
        setCurrentIndexOnAxis(0, fixedAxis);
        setCurrentIndexOnAxis(growthAxisIndex()! + 1, growthAxis);
      } else {
        setCurrentIndexOnAxis(fixedAxisIndex()! + 1, fixedAxis);
      }

      yield _currentAreaForSpans(columnSpan!, rowSpan!);
    }
  }

  GridArea _currentAreaForSpans(int columnSpan, int rowSpan) {
    return GridArea.withSpans(
      columnStart: currentColumn!,
      columnSpan: columnSpan,
      rowStart: currentRow!,
      rowSpan: rowSpan,
    );
  }
}

@immutable
class GridCell {
  GridCell(this.grid, this.index);

  final PlacementGrid grid;
  final int index;
  final occupants = <RenderBox>{};

  int get column => index % grid.explicitColumnCount;
  int get row => index ~/ grid.explicitColumnCount;

  bool get isOccupied => occupants.isNotEmpty;
  bool get isVacant => !isOccupied;

  String? get debugLabel => occupants.isNotEmpty
      ? (occupants.first.parentData as GridParentData).debugLabel
      : null;

  Iterable<GridCell> nextCellsAlongAxis(Axis axis) sync* {
    final next = axis == Axis.horizontal ? nextInRow : nextInColumn;
    if (next != null) {
      yield next;
      yield* next.nextCellsAlongAxis(axis);
    }
  }

  /// The cell next to this one in the row, or `null` if none.
  GridCell? get nextInRow {
    final column = (index + 1) % grid.explicitColumnCount;
    return column == 0 ? null : grid._cells[index + 1];
  }

  /// The cell below this one in the column, or `null` if none.
  GridCell? get nextInColumn {
    final i = index + grid.explicitColumnCount;
    return i >= grid._cells.length ? null : grid._cells[i];
  }

  @override
  String toString() {
    return 'GridCell($column, $row, isOccupied=$isOccupied)';
  }
}
