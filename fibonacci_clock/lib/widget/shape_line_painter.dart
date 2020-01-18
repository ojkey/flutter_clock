import 'dart:ui';

import 'package:digital_clock/model/shape.dart';
import 'package:digital_clock/model/sub_shape.dart';
import 'package:flutter/material.dart';

import 'base_shape_painter.dart';

/// Painter class which used to paint time item related colored line and it's
/// circle pointer at the end of each colored line.
class ShapeLinePainter extends BaseShapePainter {
  final int _seconds;

  /// Creates [ShapeLinePainter] with provided [shape] and [_seconds] in order
  /// to determine visibility of seconds item pointer.
  ShapeLinePainter(Shape shape, this._seconds) : super(shape, shape.length);

  /// See super.paint(canvas, size)
  @override
  paint(Canvas canvas, Size size) {
    final subShapes = SubShapes.split(shape, shape.length);
    var skipPointer = false;
    if (_isSkipPointer()) {
      // last 3 seconds should be skipped
      skipPointer = true;
      subShapes.last.setFullyColored();
    }

    _drawTimeItemLineShape(canvas, subShapes);

    if (!skipPointer) {
      drawPositionShape(
          canvas, calcOffsetToCenter(subShapes.findByLength(shape.length)));
    }
  }

  _isSkipPointer() => shape.step == STEP_SECONDS && _seconds > 56;

  _drawTimeItemLineShape(Canvas canvas, SubShapes subShapes) {
    _drawCircle(canvas, subShapes.first);
    _drawCircle(canvas, subShapes.main);
    _drawCircle(canvas, subShapes.last);
  }

  _drawCircle(Canvas canvas, SubShape subShape) {
    _drawActivePart(canvas, subShape);
    _drawInactivePart(canvas, subShape);
  }

  _drawActivePart(Canvas canvas, SubShape subShape) {
    canvas.drawArc(
        Rect.fromCircle(center: subShape.center, radius: subShape.radius),
        subShape.startAngle,
        subShape.lengthAngle,
        false, // show lines
        strokePaint(shape.color, shape.style.lineWidth));
  }

  _drawInactivePart(Canvas canvas, SubShape subShape) {
    canvas.drawArc(
        Rect.fromCircle(center: subShape.center, radius: subShape.radius),
        subShape.totalAngle,
        subShape.maxAngle - subShape.lengthAngle,
        false, // show lines
        strokePaint(shape.style.inactiveColor, 1.0));
  }
}
