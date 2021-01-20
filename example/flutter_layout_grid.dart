import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

void main() {
  runApp(PietApp());
}

class PietApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Layout Grid Desktop Demo',
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      builder: (context, child) => Piet(),
    );
  }
}

const cellRed = Color(0xffc73232);
const cellMustard = Color(0xffd7aa22);
const cellGrey = Color(0xffcfd4e0);
const cellBlue = Color(0xff1553be);
const background = Color(0xff242830);

class Piet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: LayoutGrid(
        columnGap: 12,
        rowGap: 12,
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
