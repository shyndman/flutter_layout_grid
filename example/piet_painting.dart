import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

const cellRed = Color(0xffc73232);
const cellMustard = Color(0xffd7aa22);
const cellGrey = Color(0xffcfd4e0);
const cellBlue = Color(0xff1553be);
const background = Color(0xff242830);

class PietPainting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: LayoutGrid(
        columnGap: 12,
        rowGap: 12,
        templateColumnSizes: [1.fr, 3.5.fr, 1.3.fr, 1.3.fr, 1.3.fr],
        templateRowSizes: [
          1.fr,
          0.3.fr,
          1.5.fr,
          1.2.fr,
        ],
        children: [
          // Column 1
          _buildItemForColor(cellRed).withGridPlacement(
            columnStart: 0,
            rowStart: 0,
            rowSpan: 2,
          ),
          _buildItemForColor(cellMustard).withGridPlacement(
            columnStart: 0,
            rowStart: 2,
            rowSpan: 2,
          ),
          // Column 2
          _buildItemForColor(cellRed).withGridPlacement(
            columnStart: 1,
            rowStart: 0,
            rowSpan: 4,
          ),
          // Column 3
          _buildItemForColor(cellBlue).withGridPlacement(
            columnStart: 2,
            columnSpan: 3,
            rowStart: 0,
          ),
          _buildItemForColor(cellMustard).withGridPlacement(
            columnStart: 2,
            columnSpan: 3,
            rowStart: 1,
            rowSpan: 2,
          ),
          _buildItemForColor(cellGrey).withGridPlacement(
            columnStart: 2,
            rowStart: 3,
          ),
          // Column 4
          _buildItemForColor(cellBlue).withGridPlacement(
            columnStart: 3,
            rowStart: 3,
          ),
          // Column 5
          _buildItemForColor(cellMustard).withGridPlacement(
            columnStart: 4,
            rowStart: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildItemForColor(Color c) => SizedBox.expand(
        child: DecoratedBox(decoration: BoxDecoration(color: c)),
      );
}
