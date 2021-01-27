import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import './piet_painting.dart';

void main() {
  runApp(PietNamedAreasApp());
}

class PietNamedAreasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Layout Grid Desktop Example',
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      builder: (context, child) => PietPaintingNamedAreas(),
    );
  }
}

class PietPaintingNamedAreas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: LayoutGrid(
        columnGap: 12,
        rowGap: 12,
        templateAreas: gridTemplateAreas([
          'r R  b  b  b',
          'r R  Y  Y  Y',
          'y R  Y  Y  Y',
          'y R sg sb sy',
        ]),
        templateColumnSizes: [
          FlexibleTrackSize(1),
          FlexibleTrackSize(3.5),
          FlexibleTrackSize(1.3),
          FlexibleTrackSize(1.3),
          FlexibleTrackSize(1.3),
        ],
        templateRowSizes: [
          FlexibleTrackSize(1),
          FlexibleTrackSize(0.3),
          FlexibleTrackSize(1.5),
          FlexibleTrackSize(1.2),
        ],
        children: [
          // Column 1
          _buildItemForColor(cellRed).inGridArea('r'),
          _buildItemForColor(cellMustard).inGridArea('y'),
          // Column 2
          _buildItemForColor(cellRed).inGridArea('R'),
          // Column 3
          _buildItemForColor(cellBlue).inGridArea('b'),
          _buildItemForColor(cellMustard).inGridArea('Y'),
          _buildItemForColor(cellGrey).inGridArea('sg'),
          // Column 4
          _buildItemForColor(cellBlue).inGridArea('sb'),
          // Column 5
          _buildItemForColor(cellMustard).inGridArea('sy'),
        ],
      ),
    );
  }

  Widget _buildItemForColor(Color c) {
    return SizedBox.expand(
      child: DecoratedBox(decoration: BoxDecoration(color: c)),
    );
  }
}
