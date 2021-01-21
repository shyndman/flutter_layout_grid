import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_layout_grid/src/foundation/box.dart';
import 'package:flutter_layout_grid/src/rendering/layout_grid.dart';
import 'package:flutter_test/flutter_test.dart';

final testConstraints = BoxConstraints.loose(Size(800, 600));

/// Sizes a grid that does not require the Flutter framework (ie, no children)
/// or widget pumping.
GridSizingInfo sizeEmptyGrid({
  GridFit gridFit = GridFit.passthrough,
  List<TrackSize> columnSizes,
  List<TrackSize> rowSizes,
  BoxConstraints constraints,
}) {
  final renderGrid = RenderLayoutGrid(
    gridFit: gridFit,
    templateColumnSizes: columnSizes,
    templateRowSizes: rowSizes,
    textDirection: TextDirection.ltr,
  );
  return renderGrid.computeGridSize(
      (constraints ?? testConstraints).constraintsForGridFit(gridFit));
}

Future<GridSizingInfo> sizeGridWithChildren(
  WidgetTester tester, {
  GridFit gridFit = GridFit.passthrough,
  List<TrackSize> columnSizes,
  List<TrackSize> rowSizes,
  List<Widget> children,
  BoxConstraints constraints,
}) async {
  await tester.pumpWidget(
    wrapInMinimalApp(
      ConstrainedBox(
        constraints: constraints ?? testConstraints,
        child: LayoutGrid(
          gridFit: gridFit,
          templateColumnSizes: columnSizes,
          templateRowSizes: rowSizes,
          children: children,
        ),
      ),
    ),
  );

  final renderGrid =
      tester.renderObject<RenderLayoutGrid>(find.byType(LayoutGrid));
  return renderGrid.lastGridSizing;
}

Widget wrapInMinimalApp(Widget child) {
  return WidgetsApp(
    color: Colors.white,
    builder: (context, child) => child,
  );
}

FixedTrackSize fixed(double size) => FixedTrackSize(size);
FlexibleTrackSize flex(double factor) => FlexibleTrackSize(factor);
IntrinsicContentTrackSize intrinsic() => IntrinsicContentTrackSize();
