import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
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
          columnSizes: [fixed(100)],
          rowSizes: [fixed(100)],
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
          columnSizes: [fixed(100)],
          rowSizes: [fixed(100)],
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
          columnSizes: [intrinsic()],
          rowSizes: [intrinsic()],
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
          columnSizes: [fixed(800)],
          rowSizes: [fixed(800)],
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
          columnSizes: [fixed(800)],
          rowSizes: [fixed(800)],
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
