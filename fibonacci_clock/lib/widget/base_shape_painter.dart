import 'dart:math';

import 'package:digital_clock/model/shape.dart';
import 'package:digital_clock/model/sub_shape.dart';
import 'package:flutter/material.dart';

/// Base class for painters which stores [shape], contains common methods
/// required for child classes.
/// Also implements [shouldRepaint] method of [CustomPainter].
abstract class BaseShapePainter extends CustomPainter {
  /// Model of drawn shape
  final Shape shape;
  final double _length;

  /// Creates [BaseShapePainter] with initialization of [shape] and [_length].
  BaseShapePainter(this.shape, this._length);

  /// Implementation [CustomPainter]'s method. Returns true if the [_length]
  /// field was changed.
  @override
  bool shouldRepaint(BaseShapePainter old) {
    return old._length != _length;
  }

  /// Creates stroke [Paint] with provided [color] and [width].
  strokePaint(Color color, width) =>
      Paint()
        ..color = color
        ..strokeWidth = width
        ..style = PaintingStyle.stroke;

  /// Draws position shape in [canvas] with provided [offset] which contains
  /// coordinates of circle's center.
  drawPositionShape(Canvas canvas, Offset offset) {
    canvas.drawCircle(offset, 5.0, _createPaintWithShader(offset));
  }

  /// Calculates offset coordinates to center point of the circle.
  Offset calcOffsetToCenter(SubShape subShape) {
    double angle = subShape.totalAngle;
    return Offset(subShape.center.dx + subShape.radius * cos(angle),
        subShape.center.dy + subShape.radius * sin(angle));
  }

  _createPaintWithShader(offset) =>
      Paint()
        ..shader = RadialGradient(
          radius: 0.9,
          colors: [
            Colors.white,
            shape.color,
            shape.thirdColor,
          ],
          stops: [0.05, 0.4, 1.0],
        ).createShader(Rect.fromCircle(center: offset, radius: 3.0));
}
