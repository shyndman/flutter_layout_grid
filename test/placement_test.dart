import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_layout_grid/src/rendering/layout_grid.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('named placement', () {
    testWidgets('positions items correctly', (tester) async {
      final keyA = ValueKey('a'),
          keyB = ValueKey('b'),
          keyC = ValueKey('c'),
          keyD = ValueKey('d'),
          keyE = ValueKey('e');

      await sizeGridWithChildren(
        tester,
        columnSizes: [fixed(10), fixed(10), fixed(10), fixed(10)],
        rowSizes: [fixed(10), fixed(10), fixed(10), fixed(10)],
        namedAreas: gridAreas([
          'a a a .',
          'a a a d',
          'b . . d',
          'c c c c',
        ]),
        children: [
          Container(key: keyA).inGridArea('a'),
          Container(key: keyB).inGridArea('b'),
          Container(key: keyC).inGridArea('c'),
          Container(key: keyD).inGridArea('d'),
          Container(key: keyE).inGridArea('e'),
        ],
      );

      expect(definiteAreaByKey(tester, keyA), [0, 3, 0, 2]);
      expect(definiteAreaByKey(tester, keyB), [0, 1, 2, 1]);
      expect(definiteAreaByKey(tester, keyC), [0, 4, 3, 1]);
      expect(definiteAreaByKey(tester, keyD), [3, 1, 1, 2]);

      // References an area that isn't in the named areas
      final notPlacedParentData = parentDataByKey(tester, keyE);
      expect(notPlacedParentData.isNotPlaced, true);
    });
  });
}

List<int> definiteAreaByKey(WidgetTester tester, Key key) {
  final parentData = parentDataByKey(tester, key);
  final area = parentData.area;
  return [
    area.columnStart,
    area.columnSpan,
    area.rowStart,
    area.rowSpan,
  ];
}

GridParentData parentDataByKey(WidgetTester tester, Key key) {
  return tester.firstRenderObject(find.byKey(key)).parentData as GridParentData;
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
