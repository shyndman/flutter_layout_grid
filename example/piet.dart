import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

// Sets a platform override for desktop to avoid exceptions. See
// https://flutter.dev/desktop#target-platform-override for more info.
void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _enablePlatformOverrideForDesktop();
  runApp(PietApp());
}

class PietApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Layout Grid Desktop Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Piet(),
          ),
        ),
      ),
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
      width: 240,
      height: 200,
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
          GridPlacement(
            columnStart: 0,
            rowStart: 0,
            rowSpan: 2,
            child: _buildItemForColor(cellRed),
          ),
          GridPlacement(
            columnStart: 0,
            rowStart: 2,
            rowSpan: 2,
            child: _buildItemForColor(cellMustard),
          ),
          // Column 2
          GridPlacement(
            columnStart: 1,
            rowStart: 0,
            rowSpan: 4,
            child: _buildItemForColor(cellRed),
          ),
          // Column 3
          GridPlacement(
            columnStart: 2,
            columnSpan: 3,
            rowStart: 0,
            child: _buildItemForColor(cellBlue),
          ),
          GridPlacement(
            columnStart: 2,
            columnSpan: 3,
            rowStart: 1,
            rowSpan: 2,
            child: _buildItemForColor(cellMustard),
          ),
          GridPlacement(
            columnStart: 2,
            rowStart: 3,
            child: _buildItemForColor(cellGrey),
          ),
          // Column 4
          GridPlacement(
            columnStart: 3,
            rowStart: 3,
            child: _buildItemForColor(cellBlue),
          ),
          // Column 5
          GridPlacement(
            columnStart: 4,
            rowStart: 3,
            child: _buildItemForColor(cellMustard),
          ),
        ],
      ),
    );
  }

  Widget _buildItemForColor(Color c) =>
      DecoratedBox(decoration: BoxDecoration(color: c));
}
