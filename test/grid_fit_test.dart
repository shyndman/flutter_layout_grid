import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_layout_grid/src/rendering/layout_grid.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('Grid fit', () {
    testWidgets('GridFit.loose sizes only as much as it needs to',
        (tester) async {
      await tester.pumpWidget(_gridFitHarness(
        constraints: BoxConstraints.loose(Size(200, 200)),
        // This grid wants to size to be 100x100, but its parent dictates
        // otherwise
        child: LayoutGrid(
          gridFit: GridFit.loose,
          templateColumnSizes: [fixed(100)],
          templateRowSizes: [fixed(100)],
          children: [],
        ),
      ));

      expect(findGridSizing(tester).gridSize, Size(100, 100));
    });

    testWidgets('GridFit.loose respects minimum constraints', (tester) async {
      await tester.pumpWidget(_gridFitHarness(
        constraints: BoxConstraints(minWidth: 200, minHeight: 200),
        // This grid wants to size to be 100x100, but its parent dictates
        // otherwise
        child: LayoutGrid(
          gridFit: GridFit.loose,
          templateColumnSizes: [fixed(100)],
          templateRowSizes: [fixed(100)],
          children: [],
        ),
      ));

      final sizing = findGridSizing(tester);
      expect(sizing.gridSize, Size(200, 200));
      expect(sizing.baseSizesForType(TrackType.column), [100]);
      expect(sizing.baseSizesForType(TrackType.row), [100]);
    });

    testWidgets('GridFit.expand with bounded constraints sizes to maximum',
        (tester) async {
      await tester.pumpWidget(_gridFitHarness(
        constraints: BoxConstraints.tightFor(width: 400, height: 400),
        child: LayoutGrid(
          gridFit: GridFit.expand,
          templateColumnSizes: [intrinsic()],
          templateRowSizes: [intrinsic()],
          children: [],
        ),
      ));

      expect(findGridSizing(tester).gridSize, Size(400, 400));
    });
  });

  group('Overflowing children', () {
    testWidgets('do not overflow the grid', (tester) async {
      await tester.pumpWidget(_gridFitHarness(
        constraints: BoxConstraints.tightFor(width: 400, height: 400),
        child: LayoutGrid(
          gridFit: GridFit.expand,
          templateColumnSizes: [fixed(800)],
          templateRowSizes: [fixed(800)],
          children: [Container()],
        ),
      ));

      tester.takeException(); // Ignore overflow exception

      expect(findGridSizing(tester).gridSize, Size(400, 400));
    });

    testWidgets('are reported to the user', (tester) async {
      await tester.pumpWidget(_gridFitHarness(
        constraints: BoxConstraints.tightFor(width: 400, height: 400),
        child: LayoutGrid(
          gridFit: GridFit.expand,
          templateColumnSizes: [fixed(800)],
          templateRowSizes: [fixed(800)],
          children: [Container()],
        ),
      ));

      // Ignore overflow exception
      final dynamic exception = tester.takeException();
      expect(exception, isFlutterError);
      expect(exception.diagnostics.first.level, DiagnosticLevel.summary);
      expect(
        exception.diagnostics.first.toString(),
        startsWith('A RenderLayoutGrid overflowed by '),
      );
    });
  });

  group('computeDryLayout', () {
    testWidgets('computes the same size that layout does', (tester) async {
      final testConstraints = BoxConstraints.tightFor(width: 400, height: 400);
      await tester.pumpWidget(_gridFitHarness(
        constraints: testConstraints,
        child: LayoutGrid(
          gridFit: GridFit.expand,
          templateColumnSizes: [1.fr],
          templateRowSizes: [1.fr],
          children: [],
        ),
      ));

      final renderGrid =
          tester.renderObject<RenderLayoutGrid>(find.byType(LayoutGrid));
      expect(
        renderGrid.lastGridSizing.gridSize,
        renderGrid.computeDryLayout(testConstraints),
      );
    });

    testWidgets('does not call layout() in children', (tester) async {
      final testConstraints = BoxConstraints.tightFor(width: 400, height: 400);

      // This will layout the child once
      await tester.pumpWidget(_gridFitHarness(
        constraints: testConstraints,
        child: LayoutGrid(
          gridFit: GridFit.expand,
          templateColumnSizes: [auto],
          templateRowSizes: [auto],
          children: [TestLayoutCountingGridItem()],
        ),
      ));

      final renderGrid =
          tester.renderObject<RenderLayoutGrid>(find.byType(LayoutGrid));
      final renderGridItem =
          tester.renderObject<RenderTestLayoutCountingGridItem>(
              find.byType(TestLayoutCountingGridItem));

      // Ensure the child has been laid out once, then reset the count
      expect(renderGridItem.layoutCount, 1);
      renderGridItem.resetCount();
      renderGrid.computeDryLayout(testConstraints);
      expect(renderGridItem.layoutCount, 0);
    });
  });
}

Widget _gridFitHarness({
  BoxConstraints constraints,
  @required Widget child,
}) {
  if (constraints != null) {
    child = ConstrainedBox(constraints: constraints, child: child);
  }
  return wrapInMinimalApp(UnconstrainedBox(child: child));
}
