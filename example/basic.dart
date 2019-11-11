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
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 64.0),
        child: LayoutGrid(
          columnGap: 12,
          rowGap: 12,
          templateColumnSizes: [
            FlexibleTrackSize(1),
            FlexibleTrackSize(1),
            FlexibleTrackSize(1),
            FlexibleTrackSize(0.75),
          ],
          templateRowSizes: [
            FixedTrackSize(32),
            FixedTrackSize(32),
            FixedTrackSize(32),
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
      ),
    );
  }
}
