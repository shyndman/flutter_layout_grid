import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_layout_grid/src/rendering/layout_grid.dart';
import 'package:flutter_layout_grid/src/rendering/placement.dart';

void main() {
  group('auto placement', () {
    test('not sure yet', () {
      final fixed40 = const FixedTrackSize(40);
      final grid = RenderLayoutGrid(
        autoPlacementMode: AutoPlacement.rowSparse,
        textDirection: TextDirection.ltr,
        templateColumnSizes: [
          fixed40,
          fixed40,
          fixed40,
        ],
        templateRowSizes: [
          fixed40,
          fixed40,
          fixed40,
        ],
        children: [
          gridItem(debugLabel: 'a', columnSpan: 2, rowSpan: 2),
          gridItem(debugLabel: 'b'),
          gridItem(debugLabel: 'c'),
          gridItem(debugLabel: 'd'),
          gridItem(debugLabel: '0', columnStart: 0, rowStart: 0),
          gridItem(debugLabel: '2', rowStart: 2),
        ],
      );

      final placementGrid = computeItemPlacement(grid);
      print(placementGrid);
    });
  });
}

RenderBox gridItem({
  int columnStart,
  int columnSpan = 1,
  int rowStart,
  int rowSpan = 1,
  String debugLabel,
}) {
  return TestRenderBox()
    ..parentData = GridParentData(
      columnStart: columnStart,
      columnSpan: columnSpan,
      rowStart: rowStart,
      rowSpan: rowSpan,
      debugLabel: debugLabel,
    );
}

class TestRenderBox extends RenderBox {}
