import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef _BoxPainterDelegate = void Function(
  Canvas canvas,
  Offset offset,
  ImageConfiguration configuration,
);

/// Simplifies decoration by allowing all functionality through a single class.
abstract class SimpleDecoration extends Decoration {
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration);

  @override
  @nonVirtual
  BoxPainter createBoxPainter([onChanged]) {
    return _GenericBoxPainter(this.paint);
  }
}

class _GenericBoxPainter extends BoxPainter {
  _GenericBoxPainter(this.delegate);
  final _BoxPainterDelegate delegate;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    delegate(canvas, offset, configuration);
  }
}
