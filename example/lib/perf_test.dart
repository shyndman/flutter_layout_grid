import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/src/rendering/debug.dart';
import 'package:flutter_layout_grid/src/rendering/layout_grid.dart';
import 'package:stats/stats.dart';

import 'perf/all_text_cells.dart';
import 'perf/empty_cells.dart';
import 'perf/null_cells.dart';
import 'perf/sized_box_cells.dart';

void main() {
  debugCollectLayoutTimes = true;
  runApp(PerfApp());
}

class PerfApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return DefaultTextStyle(
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
            child: SingleChildScrollView(child: ToggleGrid()),
          );
        });
  }
}

final gridKeyAllTextCells = GlobalKey();
final gridKeyNullCells = GlobalKey();
final gridKeyEmptyCells = GlobalKey();
final gridKeySizedBoxCells = GlobalKey();

class ToggleGrid extends StatefulWidget {
  @override
  _ToggleGridState createState() => _ToggleGridState();
}

class _ToggleGridState extends State<ToggleGrid> {
  bool showingGrid = false;

  void showStats() {
    print('text  cells: ${statsForGridKey(gridKeyAllTextCells)}');
    print('null  cells: ${statsForGridKey(gridKeyNullCells)}');
    print('empty cells: ${statsForGridKey(gridKeyEmptyCells)}');
    print('sized cells: ${statsForGridKey(gridKeySizedBoxCells)}');
  }

  String statsForGridKey(GlobalKey key) {
    final renderGrid =
        key.currentContext.findRenderObject() as RenderLayoutGrid;

    if (renderGrid.debugLayoutTimesInMicros.length == 1) {
      return '${renderGrid.debugLayoutTimesInMicros.first / 1000.0}ms';
    } else {
      return Stats.fromData(
        renderGrid.debugLayoutTimesInMicros
            .map((microsecond) => microsecond / 1000.0),
      ).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () => setState(() => showingGrid = !showingGrid),
              child: Text('Toggle Grid'),
            ),
            if (showingGrid)
              ElevatedButton(
                onPressed: showStats,
                child: Text('Print Grid Layout Times'),
              ),
          ],
        ),
        if (showingGrid) ...[
          BigGridTextCells(gridKey: gridKeyAllTextCells),
          BigGridNullCells(gridKey: gridKeyNullCells),
          BigGridEmptyCells(gridKey: gridKeyEmptyCells),
          BigGridSizedBoxCells(gridKey: gridKeySizedBoxCells),
        ],
      ],
    );
  }
}
