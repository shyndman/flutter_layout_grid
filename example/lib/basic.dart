import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Layout Grid Desktop Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: LayoutGridExample(),
        ),
      ),
    );
  }
}

class LayoutGridExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: LayoutGrid(
        columnGap: 12,
        rowGap: 12,
        columnSizes: [1.fr, 1.fr, 1.fr, 0.75.fr],
        rowSizes: [
          32.px,
          32.px,
          32.px,
        ],
        children: [
          GridPlacement(
            rowStart: 0,
            columnStart: 0,
            columnSpan: 4,
            child: Container(
              color: Colors.blue,
              padding: EdgeInsets.all(8),
            ),
          ),
          GridPlacement(
            rowStart: 1,
            columnStart: 0,
            columnSpan: 3,
            child: Container(
              color: Colors.blue,
              padding: EdgeInsets.all(8),
            ),
          ),
          GridPlacement(
            rowStart: 1,
            columnStart: 3,
            child: Container(
              color: Colors.blue,
              padding: EdgeInsets.all(8),
            ),
          ),
          GridPlacement(
            rowStart: 2,
            columnStart: 0,
            child: Container(
              color: Colors.blue,
              padding: EdgeInsets.all(8),
            ),
          ),
          GridPlacement(
            rowStart: 2,
            columnStart: 1,
            child: Container(
              color: Colors.blue,
              padding: EdgeInsets.all(8),
            ),
          ),
          GridPlacement(
            rowStart: 2,
            columnStart: 2,
            child: Container(
              color: Colors.blue,
              padding: EdgeInsets.all(8),
            ),
          ),
          GridPlacement(
            rowStart: 2,
            columnStart: 3,
            child: Container(
              color: Colors.blue,
              padding: EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }
}
