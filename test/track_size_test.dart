import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('fixed track sizes', () {
    test('are correctly sized', () {
      final gridSize = sizeEmptyGrid(
        columnSizes: [fixed(40), fixed(80)],
        rowSizes: [fixed(20), fixed(30)],
      );

      expect(
        gridSize.baseSizesForType(TrackType.column),
        [40, 80],
      );
      expect(
        gridSize.baseSizesForType(TrackType.row),
        [20, 30],
      );
    });

    test('do not expand to fill remaining space', () {
      final gridSize = sizeEmptyGrid(
        gridFit: GridFit.expand,
        columnSizes: [fixed(40), fixed(80)],
        rowSizes: [fixed(20), fixed(30)],
      );

      expect(
        gridSize.baseSizesForType(TrackType.column),
        [40, 80],
      );
      expect(
        gridSize.baseSizesForType(TrackType.row),
        [20, 30],
      );
    });
  });

  group('flexible track sizes', () {
    test('fill remaining space', () {
      final gridSize = sizeEmptyGrid(
        columnSizes: [fixed(100), flex(1)],
        rowSizes: [fixed(100), flex(1)],
      );

      expect(
        gridSize.baseSizesForType(TrackType.column),
        [100, 700],
      );
      expect(
        gridSize.baseSizesForType(TrackType.row),
        [100, 500],
      );
    });

    test('share space according to their factor (same factor)', () {
      final gridSize = sizeEmptyGrid(
        columnSizes: [fixed(100), flex(1), flex(1)],
        rowSizes: [fixed(100), flex(1), flex(1)],
      );

      expect(
        gridSize.baseSizesForType(TrackType.column),
        [100, 350, 350],
      );
      expect(
        gridSize.baseSizesForType(TrackType.row),
        [100, 250, 250],
      );
    });

    test('share space according to their factor (varying factors)', () {
      final gridSize = sizeEmptyGrid(
        columnSizes: [fixed(100), flex(1), flex(3)],
        rowSizes: [fixed(100), flex(7), flex(1)],
      );

      expect(
        gridSize.baseSizesForType(TrackType.column),
        [100, 700 / 4, 3 * 700 / 4],
      );
      expect(
        gridSize.baseSizesForType(TrackType.row),
        [100, 7 * 500 / 8, 500 / 8],
      );
    });

    test('occupy no space if none available', () {
      final gridSize = sizeEmptyGrid(
        columnSizes: [fixed(800), flex(1)],
        rowSizes: [fixed(100)],
        constraints: testConstraints,
      );

      expect(
        gridSize.baseSizesForType(TrackType.column),
        [800, 0],
      );
      expect(
        gridSize.baseSizesForType(TrackType.row),
        [100],
      );
    });
  });

  group('intrinsic track sizes', () {
    test('stretch to fill the constraint\'s remaining space', () {
      final gridSize = sizeEmptyGrid(
        gridFit: GridFit.expand,
        columnSizes: [fixed(100), intrinsic(), fixed(100)],
        rowSizes: [fixed(100), intrinsic(), fixed(100)],
      );

      expect(
        gridSize.baseSizesForType(TrackType.column),
        [100, 600, 100],
      );
      expect(
        gridSize.baseSizesForType(TrackType.row),
        [100, 400, 100],
      );
    });

    test('share while stretching to fill remaining space', () {
      final gridSize = sizeEmptyGrid(
        gridFit: GridFit.expand,
        columnSizes: [intrinsic(), intrinsic(), intrinsic(), intrinsic()],
        rowSizes: [intrinsic(), intrinsic(), intrinsic(), intrinsic()],
      );

      expect(
        gridSize.baseSizesForType(TrackType.column),
        [200, 200, 200, 200],
      );
      expect(
        gridSize.baseSizesForType(TrackType.row),
        [150, 150, 150, 150],
      );
    });

    test('do not stretch if a flexible track is involved', () {
      final gridSize = sizeEmptyGrid(
        columnSizes: [flex(1), intrinsic()],
        rowSizes: [flex(1), intrinsic()],
      );

      expect(
        gridSize.baseSizesForType(TrackType.column),
        [800, 0],
      );
      expect(
        gridSize.baseSizesForType(TrackType.row),
        [600, 0],
      );
    });

    testWidgets('sizes to content minimums, then shares what\'s left',
        (tester) async {
      final gridSize = await sizeGridWithChildren(
        tester,
        gridFit: GridFit.expand,
        columnSizes: [intrinsic(), intrinsic()],
        rowSizes: [intrinsic(), intrinsic()],
        children: [
          constrainedBox(100, 400)
              .withGridPlacement(columnStart: 0, rowStart: 0),
          constrainedBox(200, 100)
              .withGridPlacement(columnStart: 1, rowStart: 1),
        ],
      );

      expect(
        gridSize.baseSizesForType(TrackType.column),
        [100 + 250, 200 + 250],
      );
      expect(
        gridSize.baseSizesForType(TrackType.row),
        [400 + 50, 100 + 50],
      );
    });
  });
}

ConstrainedBox constrainedBox(
  double minW,
  double minH, [
  double? maxW,
  double? maxH,
]) {
  maxW ??= minW;
  maxH ??= minH;
  return ConstrainedBox(
    constraints: BoxConstraints(
      minWidth: minW,
      maxWidth: maxW,
      minHeight: minH,
      maxHeight: maxH,
    ),
  );
}
