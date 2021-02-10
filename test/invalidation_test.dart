import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_layout_grid/src/rendering/layout_grid.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

const initialColumnSizes = [FixedTrackSize(10)];
const initialRowSizes = [FixedTrackSize(10)];

void main() {
  group('grid invalidation', () {
    testWidgets('# of columns change', (tester) async {
      final renderGrid = await _setupInvalidationTest(tester);

      // We expect that placement is not required, because we allowed the
      // engine to go through a full layout pass.
      expect(renderGrid.needsPlacement, false);

      await tester.pumpWidget(
        _testGrid(
          columnSizes: [10.px, 10.px], // NOTE we added a column
          rowSizes: initialRowSizes,
        ),
        /* duration */ null,
        // NOTE Only build, do not layout
        EnginePhase.build,
      );

      expect(renderGrid.needsPlacement, true);
      expect(renderGrid.debugNeedsLayout, true);
    });

    testWidgets('columns change sizing function (same # of cols)',
        (tester) async {
      final renderGrid = await _setupInvalidationTest(tester);

      // We pump again, with the same number of columns, but different functions
      await tester.pumpWidget(
        _testGrid(
          columnSizes: [100.px], // Was 10.px
          rowSizes: initialRowSizes,
        ),
        /* duration */ null,
        // NOTE Only build, do not layout
        EnginePhase.build,
      );

      expect(renderGrid.needsPlacement, false);
      expect(renderGrid.debugNeedsLayout, true);
    });

    testWidgets('# of rows change', (tester) async {
      final renderGrid = await _setupInvalidationTest(tester);

      // We expect that placement is not required, because we allowed the
      // engine to go through a full layout pass.
      expect(renderGrid.needsPlacement, false);

      await tester.pumpWidget(
        _testGrid(
          columnSizes: initialColumnSizes,
          rowSizes: [10.px, 10.px], // NOTE we added a row
        ),
        /* duration */ null,
        // NOTE Only build, do not layout
        EnginePhase.build,
      );

      expect(renderGrid.needsPlacement, true);
      expect(renderGrid.debugNeedsLayout, true);
    });

    testWidgets('rows change sizing function (same # of rows)', (tester) async {
      final renderGrid = await _setupInvalidationTest(tester);

      // We pump again, with the same number of rows, but different functions
      await tester.pumpWidget(
        _testGrid(
          columnSizes: initialColumnSizes,
          rowSizes: [100.px], // Was 10.px
        ),
        /* duration */ null,
        // NOTE Only build, do not layout
        EnginePhase.build,
      );

      expect(renderGrid.needsPlacement, false);
      expect(renderGrid.debugNeedsLayout, true);
    });

    testWidgets('areas change', (tester) async {
      final renderGrid = await _setupInvalidationTest(tester, areas: 'a');

      // We expect that placement is not required, because we allowed the
      // engine to go through a full layout pass.
      expect(renderGrid.needsPlacement, false);

      await tester.pumpWidget(
        _testGrid(
          areas: 'b',
          columnSizes: initialColumnSizes,
          rowSizes: initialRowSizes,
        ),
        /* duration */ null,
        // NOTE Only build, do not layout
        EnginePhase.build,
      );

      expect(renderGrid.needsPlacement, true);
      expect(renderGrid.debugNeedsLayout, true);
    });

    testWidgets('identical areas/rows/columns', (tester) async {
      final renderGrid = await _setupInvalidationTest(tester, areas: 'a');

      // We pump again, with the same number of columns, but different functions
      await tester.pumpWidget(
        _testGrid(
          areas: 'a',
          columnSizes: initialColumnSizes,
          rowSizes: initialRowSizes,
        ),
        /* duration */ null,
        // NOTE Only build, do not layout
        EnginePhase.build,
      );

      expect(renderGrid.needsPlacement, false);
      expect(renderGrid.debugNeedsLayout, false);
    });
  });
}

/// Pumps an initial grid with one 10px column and row
Future<RenderLayoutGrid> _setupInvalidationTest(
  WidgetTester tester, {
  String? areas,
}) async {
  await tester.pumpWidget(
    _testGrid(
      areas: areas,
      columnSizes: initialColumnSizes,
      rowSizes: initialRowSizes,
    ),
  );
  return tester.firstRenderObject<RenderLayoutGrid>(find.byType(LayoutGrid));
}

Widget _testGrid({
  String? areas,
  required List<TrackSize> columnSizes,
  required List<TrackSize> rowSizes,
}) {
  return wrapInMinimalApp(
    LayoutGrid(
      areas: areas,
      columnSizes: columnSizes,
      rowSizes: rowSizes,
    ),
  );
}
