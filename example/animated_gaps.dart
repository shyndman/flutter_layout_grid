// ignore_for_file: unawaited_futures

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_layout_grid/helpers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Animated Gaps Example',
      color: Colors.white,
      builder: (_, __) => AnimatedGapsExample(),
    );
  }
}

class AnimatedGapsExample extends StatefulWidget {
  @override
  _AnimatedGapsExampleState createState() => _AnimatedGapsExampleState();
}

class _AnimatedGapsExampleState extends State<AnimatedGapsExample>
    with SingleTickerProviderStateMixin {
  Animation<double> gapAnimation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    gapAnimation = CurveTween(curve: Curves.easeInOut)
        .animate(controller)
        .drive(Tween<double>(begin: 0, end: 60))
          ..addStatusListener((status) async {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              await Future<void>.delayed(Duration(milliseconds: 1000));
              controller.forward();
            }
          })
          ..addListener(() => setState(() {}));

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnGap: gapAnimation.value,
      rowGap: gapAnimation.value,
      templateColumnSizes: [flex(1), flex(1), flex(1), flex(0.75)],
      templateRowSizes: [
        flex(1),
        flex(1),
        flex(1),
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
    );
  }
}
