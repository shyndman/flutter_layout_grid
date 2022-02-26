// Source:
// https://github.com/luigi-rosso/flutter-inner-shadow/blob/master/lib/inner_shadow.dart,
// written by one of the creators of Rive (https://rive.app) (which you should
// check out, because it's very cool)

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InnerShadow extends SingleChildRenderObjectWidget {
  const InnerShadow({
    Key? key,
    required this.color,
    required this.blurX,
    required this.blurY,
    required this.offset,
    required Widget child,
  }) : super(key: key, child: child);

  final Color color;
  final double blurX;
  final double blurY;
  final Offset offset;

  @override
  RenderInnerShadow createRenderObject(BuildContext context) {
    return RenderInnerShadow()
      ..color = color
      ..blurX = blurX
      ..blurY = blurY
      ..offset = offset;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderInnerShadow renderObject) {
    renderObject
      ..color = color
      ..blurX = blurX
      ..blurY = blurY
      ..offset = offset;
  }
}

class RenderInnerShadow extends RenderProxyBox {
  RenderInnerShadow({
    RenderBox? child,
  }) : super(child);

  @override
  bool get alwaysNeedsCompositing => child != null;

  late Color _color;
  late double _blurX;
  late double _blurY;
  late Offset _offset;

  Color get color => _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  double get blurX => _blurX;
  set blurX(double value) {
    if (_blurX == value) return;
    _blurX = value;
    markNeedsPaint();
  }

  double get blurY => _blurY;
  set blurY(double value) {
    if (_blurY == value) return;
    _blurY = value;
    markNeedsPaint();
  }

  Offset get offset => _offset;
  set offset(Offset value) {
    if (_offset == value) return;
    _offset = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child != null) {
      final layerPaint = Paint()..color = Colors.white;

      context.canvas.saveLayer(offset & size, layerPaint);
      context.paintChild(child, offset);
      final shadowPaint = Paint()
        ..blendMode = BlendMode.srcATop
        ..imageFilter = ImageFilter.blur(sigmaX: blurX, sigmaY: blurY)
        ..colorFilter = ColorFilter.mode(color, BlendMode.srcIn);
      context.canvas.saveLayer(offset & size, shadowPaint);

      // Invert the alpha to compute inner part.
      final invertPaint = Paint()
        ..colorFilter = const ColorFilter.matrix(
            [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, -1, 255]);
      context.canvas.saveLayer(offset & size, invertPaint);
      context.canvas.translate(_offset.dx, _offset.dy);
      context.paintChild(child, offset);
      context.canvas.restore();
      context.canvas.restore();
      context.canvas.restore();
    }
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    final child = this.child;
    if (child != null) visitor(child);
  }
}
