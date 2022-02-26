// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Piet screenshot test', (tester) async {
    await tester.pumpWidget(PietApp());
    await expectLater(
      find.byType(PietApp),
      matchesGoldenFile('goldens/piet.png'),
    );
  });
}

const cellRed = Color(0xffc73232);
const cellMustard = Color(0xffd7aa22);
const cellGrey = Color(0xffcfd4e0);
const cellBlue = Color(0xff1553be);
const background = Color(0xff242830);

class PietApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Layout Grid Desktop Example',
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      builder: (context, child) => PietPainting(),
    );
  }
}

class PietPainting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: LayoutGrid(
        columnGap: 12,
        rowGap: 12,
        columnSizes: [1.fr, 3.5.fr, 1.3.fr, 1.3.fr, 1.3.fr],
        rowSizes: [
          1.fr,
          0.3.fr,
          1.5.fr,
          1.2.fr,
        ],
        children: [
          // Column 1
          Container(color: cellRed).withGridPlacement(
            columnStart: 0,
            rowStart: 0,
            rowSpan: 2,
          ),
          Container(color: cellMustard).withGridPlacement(
            columnStart: 0,
            rowStart: 2,
            rowSpan: 2,
          ),
          // Column 2
          Container(color: cellRed).withGridPlacement(
            columnStart: 1,
            rowStart: 0,
            rowSpan: 4,
          ),
          // Column 3
          Container(color: cellBlue).withGridPlacement(
            columnStart: 2,
            columnSpan: 3,
            rowStart: 0,
          ),
          Container(color: cellMustard).withGridPlacement(
            columnStart: 2,
            columnSpan: 3,
            rowStart: 1,
            rowSpan: 2,
          ),
          Container(color: cellGrey).withGridPlacement(
            columnStart: 2,
            rowStart: 3,
          ),
          // Column 4
          Container(color: cellBlue).withGridPlacement(
            columnStart: 3,
            rowStart: 3,
          ),
          // Column 5
          Container(color: cellMustard).withGridPlacement(
            columnStart: 4,
            rowStart: 3,
          ),
        ],
      ),
    );
  }
}
