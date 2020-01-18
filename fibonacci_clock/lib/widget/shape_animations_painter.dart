import 'package:digital_clock/model/clock_items.dart';
import 'package:digital_clock/model/sub_shape.dart';
import 'package:digital_clock/util.dart';
import 'package:flutter/material.dart';

import 'base_shape_painter.dart';

/// Painter class which used to paint running flash pointer and/or glowing circle
/// around time item related pointer.
class ShapeAnimationsPainter extends BaseShapePainter {
  final ShapeAnimationsItem _item;

  /// Creates [ShapeAnimationsPainter] with provided [_item] which contains
  /// length location of flash pointer.
  ShapeAnimationsPainter(this._item) : super(_item.shape, _item.flashLength);

  /// See super.paint(canvas, size)
  @override
  paint(Canvas canvas, Size size) {
    if (_item.isFlashing) {
      _drawFlashLine(canvas);
    }
    if (_item.isGlowing) {
      _drawGlowCircle(canvas);
    }
  }

  _drawFlashLine(Canvas canvas) {
    final center = calcOffsetToCenter(_getSubShape(_item.flashLength));

    drawPositionShape(canvas, center);
  }

  _drawGlowCircle(Canvas canvas) {
    final center = calcOffsetToCenter(_getSubShape(shape.length));
    canvas.drawCircle(
        center,
        2.5 * _item.glowRadius * fib(shape.step),
        Paint()
          ..color = shape.color
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke);
  }

  _getSubShape(length) => SubShapes.split(shape, length).findByLength(length);
}
