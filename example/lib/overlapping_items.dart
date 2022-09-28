import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

void main() {
  runApp(const OverlappingItemsApp());
}

class OverlappingItemsApp extends StatelessWidget {
  const OverlappingItemsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return const OverlappingItems();
        });
  }
}

class OverlappingItems extends StatelessWidget {
  const OverlappingItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: LayoutGrid(
        columnSizes: repeat(7, [auto]),
        rowSizes: repeat(7, [auto]),
        children: [
          // Children are drawn in order, making this the background.
          ColoredBox(
            color: Colors.grey[400]!,
            margin: const EdgeInsets.all(24.0),
          ).withGridPlacement(
            columnStart: 0,
            columnSpan: 7,
            rowStart: 0,
            rowSpan: 7,
          ),
          ColoredBox(color: Colors.blue[400]!).withGridPlacement(
            columnStart: 0,
            columnSpan: 3,
            rowStart: 0,
            rowSpan: 3,
          ),
          ColoredBox(color: Colors.yellow[400]!).withGridPlacement(
            columnStart: 2,
            columnSpan: 3,
            rowStart: 2,
            rowSpan: 3,
          ),
          ColoredBox(color: Colors.red[300]!).withGridPlacement(
            columnStart: 4,
            columnSpan: 3,
            rowStart: 4,
            rowSpan: 3,
          ),
        ],
      ),
    );
  }
}

class ColoredBox extends StatelessWidget {
  const ColoredBox({
    Key? key,
    required this.color,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  final Color color;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color,
      ),
    );
  }
}
