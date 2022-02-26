// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('accessibility', () {
    testWidgets('presents children in source order', (tester) async {
      final gridSemantics = await _pumpAndReturnSemantics(
        tester,
        LayoutGrid(
          columnSizes: [auto],
          rowSizes: repeat(5, [auto]),
          children: [
            Text('this'),
            Text('is'),
            Text('in'),
            Text('source'),
            Text('order'),
          ],
        ),
      );

      final gridChildLabels = gridSemantics
          .debugListChildrenInOrder(DebugSemanticsDumpOrder.traversalOrder)
          .map((node) => node.label);
      expect(
        gridChildLabels,
        ['this', 'is', 'in', 'source', 'order'],
      );
    });

    testWidgets('respects ordering provided by Semantics.sortKey',
        (tester) async {
      final gridSemantics = await _pumpAndReturnSemantics(
        tester,
        LayoutGrid(
          columnSizes: [auto],
          rowSizes: repeat(5, [auto]),
          children: [
            Semantics(
              sortKey: OrdinalSortKey(1),
              child: Text('this'),
            ),
            Semantics(
              sortKey: OrdinalSortKey(3),
              child: Text('isn\'t'),
            ),
            Semantics(
              sortKey: OrdinalSortKey(2),
              child: Text('in'),
            ),
            Semantics(
              sortKey: OrdinalSortKey(4),
              child: Text('source'),
            ),
            Semantics(
              sortKey: OrdinalSortKey(0),
              child: Text('order'),
            ),
          ],
        ),
      );

      final gridChildLabels = gridSemantics
          .debugListChildrenInOrder(DebugSemanticsDumpOrder.traversalOrder)
          .map((node) => node.label);
      expect(
        gridChildLabels,
        ['order', 'this', 'in', 'isn\'t', 'source'],
      );
    });
  });
}

Future<SemanticsNode> _pumpAndReturnSemantics(
    WidgetTester tester, LayoutGrid grid) async {
  await tester.pumpWidget(wrapInMinimalApp(
    Semantics(
      explicitChildNodes: true,
      child: grid,
    ),
  ));
  return tester.getSemantics(find.byType(LayoutGrid));
}
