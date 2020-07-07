import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../rendering/track_size.dart';
import '../rendering/layout_grid.dart';
import 'placement.dart';

/// Controls how the auto-placement algorithm works, specifying exactly how
/// auto-placed items get flowed into the grid.
class AutoPlacement {
  /// Items are placed by filling each row in turn, adding new rows as
  /// necessary. If neither row nor column is provided, row is assumed.
  static const rowSparse =
      AutoPlacement._(TrackType.row, AutoPlacementPacking.sparse);

  /// Items are placed by filling each row in turn, attempting to fill in holes
  /// earlier in the grid, if smaller items come up later, adding rows as
  /// necessary. This may cause items to appear out-of-order, when doing so
  /// would fill in holes left by larger items.
  static const rowDense =
      AutoPlacement._(TrackType.row, AutoPlacementPacking.dense);

  /// Items are placed by filling each column in turn, adding new columns as
  /// necessary.
  static const columnSparse =
      AutoPlacement._(TrackType.column, AutoPlacementPacking.sparse);

  /// Items are placed by filling each column in turn, attempting to fill in
  /// holes earlier in the grid, if smaller items come up later, adding columns
  /// as necessary. This may cause items to appear out-of-order, when doing so
  /// would fill in holes left by larger items.
  static const columnDense =
      AutoPlacement._(TrackType.column, AutoPlacementPacking.dense);

  const AutoPlacement._(this.trackType, this.packing);
  final TrackType trackType;
  final AutoPlacementPacking packing;

  @override
  String toString() {
    switch (this) {
      case rowSparse:
        return 'AutoPlacement.rowSparse';
      case rowDense:
        return 'AutoPlacement.rowDense';
      case columnSparse:
        return 'AutoPlacement.columnSparse';
      case columnDense:
        return 'AutoPlacement.columnDense';
    }
    return null;
  }

  /// The list of all available AutoPlacement values
  static const List<AutoPlacement> values = [
    rowSparse,
    rowDense,
    columnSparse,
    columnDense,
  ];
}

/// Determines the constraints available to the grid layout algorithm.
enum GridFit {
  /// The constraints passed to the grid from its parent are tightened to the
  /// biggest size allowed. For example, if the grid has loose constraints with
  /// a width in the range 10 to 100 and a height in the range 0 to 600, then
  /// the children will be instructed to fill the entire 100×600 size.
  expand,

  /// The constraints passed to the grid from its parent are loosened. For
  /// example, if the grid has constraints that force it to 350x600, then this
  /// would allow the children of the grid to collectively have a width between
  /// zero and 350 and a height from zero to 600.
  loose,

  /// The constraints passed to the grid from its parent are passed unmodified
  /// to the children when determining their sizes.
  passthrough,
}

/// Lays out its children using an approximation of the CSS Grid Layout
/// algorithm, described here:
///
/// https://drafts.csswg.org/css-grid/
///
/// Note that implicit tracks are not currently supported. If a grid item falls
/// outside of the area defined by the template tracks, an [FlutterError] will
/// be thrown during layout.
class LayoutGrid extends MultiChildRenderObjectWidget {
  LayoutGrid({
    Key key,
    this.autoPlacement = AutoPlacement.rowSparse,
    this.gridFit = GridFit.expand,
    @required this.templateColumnSizes,
    @required this.templateRowSizes,
    double rowGap,
    double columnGap,
    this.textDirection,
    List<Widget> children = const [],
  })  : assert(templateRowSizes != null && templateRowSizes.isNotEmpty),
        assert(templateColumnSizes != null && templateColumnSizes.isNotEmpty),
        this.rowGap = rowGap ?? 0,
        this.columnGap = columnGap ?? 0,
        super(key: key, children: children);

  /// Controls how the auto-placement algorithm works, specifying exactly how
  /// auto-placed items get flowed into the grid.
  final AutoPlacement autoPlacement;

  /// Determines the constraints available to the grid layout algorithm.
  final GridFit gridFit;

  /// Defines the track sizing functions of the grid's columns.
  final List<TrackSize> templateColumnSizes;

  /// Defines the track sizing functions of the grid's rows.
  final List<TrackSize> templateRowSizes;

  /// Space between column tracks
  final double columnGap;

  /// Space between row tracks
  final double rowGap;

  /// The text direction used to resolve column ordering.
  ///
  /// Defaults to the ambient [Directionality].
  final TextDirection textDirection;

  @override
  RenderLayoutGrid createRenderObject(BuildContext context) {
    return RenderLayoutGrid(
      autoPlacement: autoPlacement,
      gridFit: gridFit,
      templateColumnSizes: templateColumnSizes,
      templateRowSizes: templateRowSizes,
      columnGap: columnGap,
      rowGap: rowGap,
      textDirection: textDirection ?? Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderLayoutGrid renderObject) {
    renderObject
      ..autoPlacement = autoPlacement
      ..gridFit = gridFit
      ..templateColumnSizes = templateColumnSizes
      ..templateRowSizes = templateRowSizes
      ..columnGap = columnGap
      ..rowGap = rowGap
      ..textDirection = textDirection ?? Directionality.of(context);
  }
}
