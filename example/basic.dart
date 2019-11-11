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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
      height: 300,
      child: LayoutGrid(
        columnGap: 10,
        rowGap: 10,
        templateColumnSizes: [
          FixedTrackSize(40),
          FlexibleTrackSize(1),
        ],
        templateRowSizes: [
          FixedTrackSize(40),
          IntrinsicContentTrackSize(),
          FlexibleTrackSize(1),
        ],
        children: [
          Container(color: Colors.red[600]),
          GridPlacement(
            rowStart: 1,
            columnSpan: 1,
            child: Container(
              color: Colors.blue,
              child: Text(
                'This is a test test test',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
          GridPlacement(
            rowStart: 0,
            columnStart: 1,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.purple,
            ),
          ),
          GridPlacement(
            columnStart: 0,
            columnSpan: 2,
            rowStart: 2,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 10),
              child: Container(color: Colors.amber),
            ),
          ),
        ],
      ),
    );
  }
}
