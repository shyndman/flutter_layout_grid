import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum ViewportProperty {
  viewportResolution,
  physicalSize,
}

class DeviceInfo {
  final Size viewportResolution;
  final double dpPerInch;

  const DeviceInfo({
    @required this.viewportResolution,
    @required this.dpPerInch,
  });

  Size get physicalSize => viewportResolution / dpPerInch;
}

const devices = [
  // MacBook Air
  DeviceInfo(
    viewportResolution: Size(1440, 900),
    dpPerInch: 125,
  ),
  // iPad Pro 11 (landscape)
  DeviceInfo(
    viewportResolution: Size(1194, 834),
    dpPerInch: 132,
  ),
  // iPhone 11
  DeviceInfo(
    viewportResolution: Size(414, 896),
    dpPerInch: 163,
  ),
];

typedef ViewportContentsBuilder = Widget Function(
  BuildContext,
  Size viewportSize,
  double scale,
);

class AnimatedViewport extends StatelessWidget {
  AnimatedViewport({Key key, @required this.builder}) : super(key: key) {
    TimelineScene<ViewportProperty> previousScene = _timeline.addScene(
      begin: Duration.zero,
      duration: Duration.zero,
    );

    for (int i = 0; i < devices.length - 1; i++) {
      previousScene = previousScene
          .addSubsequentScene(
            delay: 0.8.seconds,
            duration: 1.seconds,
            curve: Curves.easeInOut,
          )
          .animate(
            ViewportProperty.viewportResolution,
            tween: SizeTween(
              begin: devices[i].viewportResolution,
              end: devices[i + 1].viewportResolution,
            ),
          )
          .animate(
            ViewportProperty.physicalSize,
            tween: SizeTween(
              begin: devices[i].physicalSize,
              end: devices[i + 1].physicalSize,
            ),
          );
    }

    previousScene
        .addSubsequentScene(
          delay: 0.8.seconds,
          duration: 1.seconds,
          curve: Curves.easeInOut,
        )
        .animate(
          ViewportProperty.physicalSize,
          tween: SizeTween(
            begin: devices.last.physicalSize,
            end: devices.first.physicalSize,
          ),
        )
        .animate(
          ViewportProperty.viewportResolution,
          tween: SizeTween(
            begin: devices.last.viewportResolution,
            end: devices.first.viewportResolution,
          ),
        );
  }

  final ViewportContentsBuilder builder;
  final _timeline = TimelineTween<ViewportProperty>();

  @override
  Widget build(BuildContext context) {
    return LoopAnimation<TimelineValue<ViewportProperty>>(
      tween: _timeline,
      duration: _timeline.duration,
      builder: (context, child, value) {
        final viewportResolution =
            value.get<Size>(ViewportProperty.viewportResolution);
        final physicalSize = value.get<Size>(ViewportProperty.physicalSize);
        final scaledPhysicalSize = physicalSize * 40;
        return Center(
          child: Container(
            width: scaledPhysicalSize.width,
            height: scaledPhysicalSize.height,
            color: Colors.blue,
            padding: EdgeInsets.all(1),
            child: builder(
              context,
              viewportResolution,
              scaledPhysicalSize.width / viewportResolution.width,
            ),
          ),
        );
      },
    );
  }
}
