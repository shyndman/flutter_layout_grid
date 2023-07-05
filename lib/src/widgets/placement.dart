import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../rendering/layout_grid.dart';
import 'layout_grid.dart';

/// Packing strategies used by the auto-placement algorithm.
enum AutoPlacementPacking {
  /// The placement algorithm only ever moves “forward” in the grid when placing
  /// items, never backtracking to fill holes. This ensures that all of the
  /// auto-placed items appear “in order”, even if this leaves holes that could
  /// have been filled by later items.
  sparse,

  /// The auto-placement algorithm uses a “dense” packing algorithm, which
  /// attempts to fill in holes earlier in the grid if smaller items come up
  /// later. This may cause items to appear out-of-order, when doing so would
  /// fill in holes left by larger items.
  dense,
}

/// A widget that controls where a child of a [LayoutGrid] is placed. If a grid
/// item is not wrapped by a [GridPlacement], it will be placed in the first
/// available space, spanning one row and one column.
class GridPlacement extends ParentDataWidget<GridParentData> {
  const GridPlacement({
    Key? key,
    required Widget child,
    this.columnStart,
    this.columnSpan = 1,
    this.rowStart,
    this.rowSpan = 1,
  }) : super(key: key, child: child);

  /// If `null`, the child will be auto-placed.
  final int? columnStart;

  /// The number of columns spanned by the child. Defaults to `1`.
  final int columnSpan;

  /// If `null`, the child will be auto-placed.
  final int? rowStart;

  /// The number of rows spanned by the child. Defaults to `1`.
  final int rowSpan;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is GridParentData);
    final parentData = renderObject.parentData as GridParentData;
    bool needsLayout = false;

    // TODO(shyndman): I don't like that we clear out a field that another
    // placement widget uses. We should probably enter a mode specific to this
    // placement widget, and have the ParentData figure out its internal state.
    if (parentData.areaName != null) {
      parentData.areaName = null;
      needsLayout = true;
    }

    if (parentData.columnStart != columnStart) {
      parentData.columnStart = columnStart;
      needsLayout = true;
    }

    if (parentData.columnSpan != columnSpan) {
      parentData.columnSpan = columnSpan;
      needsLayout = true;
    }

    if (parentData.rowStart != rowStart) {
      parentData.rowStart = rowStart;
      needsLayout = true;
    }

    if (parentData.rowSpan != rowSpan) {
      parentData.rowSpan = rowSpan;
      needsLayout = true;
    }

    if (needsLayout) {
      final targetParent = renderObject.parent;
      if (targetParent is RenderLayoutGrid) targetParent.markNeedsPlacement();
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (columnStart != null) {
      properties.add(IntProperty('columnStart', columnStart));
    } else {
      properties.add(StringProperty('columnStart', 'auto'));
    }
    properties.add(IntProperty('columnSpan', columnSpan));

    if (rowStart != null) {
      properties.add(IntProperty('rowStart', rowStart));
    } else {
      properties.add(StringProperty('rowStart', 'auto'));
    }
    properties.add(IntProperty('rowSpan', rowSpan));
  }

  @override
  Type get debugTypicalAncestorWidgetClass => LayoutGrid;
}

/// Grid placement based on the name of an area provided to the grid via
/// [LayoutGrid.areas].
///
/// If [areaName] does not exist in the grid's [LayoutGrid.areas], the
/// child of this widget is not shown.
class NamedAreaGridPlacement extends ParentDataWidget<GridParentData> {
  const NamedAreaGridPlacement({
    Key? key,
    required this.areaName,
    required Widget child,
  }) : super(key: key, child: child);

  final String areaName;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is GridParentData);
    final parentData = renderObject.parentData as GridParentData;

    if (parentData.areaName != areaName) {
      parentData.areaName = areaName;

      final targetParent = renderObject.parent;
      if (targetParent is RenderLayoutGrid) targetParent.markNeedsPlacement();
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('areaName', areaName));
  }

  @override
  Type get debugTypicalAncestorWidgetClass => LayoutGrid;
}

/// Extension methods for terse placement syntax
extension GridPlacementExtensions on Widget {
  NamedAreaGridPlacement inGridArea(String areaName, {Key? key}) {
    return NamedAreaGridPlacement(
      key: key,
      areaName: areaName,
      child: this,
    );
  }

  GridPlacement withGridPlacement({
    Key? key,
    int? columnStart,
    int columnSpan = 1,
    int? rowStart,
    int rowSpan = 1,
  }) {
    return GridPlacement(
      key: key,
      columnStart: columnStart,
      columnSpan: columnSpan,
      rowStart: rowStart,
      rowSpan: rowSpan,
      child: this,
    );
  }
}
