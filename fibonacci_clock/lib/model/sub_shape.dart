import 'dart:math';

import 'package:digital_clock/util.dart';
import 'package:flutter/cupertino.dart';

import 'shape.dart';

/// Single shape related sub-shapes container
class SubShapes {
  /// Length part's per sub-shape
  static const _FIRST_PART = 0.25;
  static const _MAIN_PART = 0.58;
  static const _FIRST_MAIN_PART = _FIRST_PART + _MAIN_PART;
  static const _LAST_PART = 1.0 - _FIRST_MAIN_PART;

  /// Staring circle
  final SubShape first;

  /// Main circle
  final SubShape main;

  /// Last tail circle
  final SubShape last;

  /// Splits single shape into required sub-shapes
  SubShapes.split(Shape shape, double shapeLength)
      : main = _Util.createSubShapeMain(shape, shapeLength),
        first = _Util.createSubShapeFirst(shape, shapeLength),
        last = _Util.createSubShapeLast(shape, shapeLength);

  /// Returns SubShape base on length
  SubShape findByLength(double length) {
    if (length < _FIRST_PART) {
      return first;
    } else if (length < _FIRST_MAIN_PART) {
      return main;
    } else {
      return last;
    }
  }
}

/// A single part of the shape
abstract class SubShape {
  /// Radius of the sub-shape's circle
  final double radius;

  /// Center of the sub-shape's circle
  final Offset center;

  /// Start angle in radians
  final double startAngle;

  /// Max angle in radians
  final double maxAngle;

  // internal constructor
  SubShape._(this.radius, this.center, this.startAngle, this.maxAngle);

  /// Colored line's length in radians
  double get lengthAngle;

  /// Total angle of colored line from start in radians
  get totalAngle => startAngle + lengthAngle;

  /// Sets current sub-shape fully colored
  setFullyColored();
}

// Implementation of SubShape
class _SubShapeImpl extends SubShape {
  // length of circle's colored part [0.0 - 1.0]
  double length;

  _SubShapeImpl(shape, shapeLength, subStep, center, startAngle, maxAngle,
      portion,
      portionMax)
      : length = _Util.getSubShapeLength(shapeLength, portion, portionMax),
        super._(_Util.calcRadius(shape, subStep), center, startAngle, maxAngle);

  @override
  get lengthAngle => _Util.toRadian(length, maxAngle);

  @override
  void setFullyColored() {
    length = 1.0;
  }
}

// Contains required parameters of each sub-shape and necessary methods
class _Util {
  // start angels in radians
  static const FIRST_SUB_SHAPE_EARLY_START_ANGLE = 0.0;
  static const FIRST_SUB_SHAPE_START_ANGLE = pi / 11.1;
  static const MAIN_SUB_SHAPE_START_ANGLE = pi / 2;
  static const LAST_SUB_SHAPE_START_ANGLE = 0.0;

  // lengths in radians
  static const FIRST_SUB_SHAPE_MAX_ANGLE = pi / 2 - FIRST_SUB_SHAPE_START_ANGLE;
  static const FIRST_SUB_SHAPE_EARLY_MAX_ANGLE =
      FIRST_SUB_SHAPE_MAX_ANGLE + FIRST_SUB_SHAPE_START_ANGLE;
  static const MAIN_SUB_SHAPE_MAX_ANGLE = 3 * MAIN_SUB_SHAPE_START_ANGLE;
  static const LAST_SUB_SHAPE_MAX_ANGLE = FIRST_SUB_SHAPE_START_ANGLE;
  static const LAST_SUB_SHAPE_LATE_MAX_ANGLE =
      FIRST_SUB_SHAPE_START_ANGLE + LAST_SUB_SHAPE_MAX_ANGLE;

  // creates first sub-shape
  static _SubShapeImpl createSubShapeFirst(Shape shape, shapeLength) =>
      _SubShapeImpl(
          shape,
          shapeLength,
          1,
          calcCenter(shape, 0.0, calcRadius(shape, -1)),
          startAngleFirst(shape.earlierStart),
          maxLengthFirst(shape.earlierStart),
          0.0,
          SubShapes._FIRST_PART);

  static _SubShapeImpl createSubShapeMain(Shape shape, shapeLength) =>
      _SubShapeImpl(
          shape,
          shapeLength,
          0,
          calcCenter(shape, 0.0, 0.0),
          MAIN_SUB_SHAPE_START_ANGLE,
          MAIN_SUB_SHAPE_MAX_ANGLE,
          SubShapes._FIRST_PART,
          SubShapes._MAIN_PART);

  static _SubShapeImpl createSubShapeLast(Shape shape, double shapeLength) =>
      _SubShapeImpl(
          shape,
          shapeLength,
          2,
          calcCenter(shape, calcRadius(shape, 1), 0.0),
          LAST_SUB_SHAPE_START_ANGLE,
          _maxLengthLast(shape.laterEnd),
          SubShapes._FIRST_MAIN_PART,
          SubShapes._LAST_PART);

  static startAngleFirst(bool earlyStart) =>
      earlyStart
          ? FIRST_SUB_SHAPE_EARLY_START_ANGLE
          : FIRST_SUB_SHAPE_START_ANGLE;

  static maxLengthFirst(bool earlyStart) =>
      earlyStart ? FIRST_SUB_SHAPE_EARLY_MAX_ANGLE : FIRST_SUB_SHAPE_MAX_ANGLE;

  static _maxLengthLast(bool lateEnd) =>
      lateEnd ? LAST_SUB_SHAPE_LATE_MAX_ANGLE : LAST_SUB_SHAPE_MAX_ANGLE;

  static getFlashAngle(shape, portion, portionMax, maxAngle) =>
      toRadian(getLength(shape.flashLength - portion, portionMax), maxAngle);

  static getSubShapeLength(shapeLength, double portion, double portionMax) =>
      getLength(shapeLength - portion, portionMax);

  static getLength(double left, double max) {
    if (left > max) {
      return 1.0;
    }
    return _nonNegative(left / max);
  }

  static calcCenter(Shape shape, dx, dy) {
    final mainRadius = calcRadius(shape, 0);
    return Offset(mainRadius - dx, mainRadius - dy);
  }

  static _nonNegative(double value) {
    return value >= 0.0 ? value : 0.0;
  }

  static toRadian(double length, double maxAngle) => length * maxAngle;

  static calcRadius(Shape shape, int subStep) =>
      fib(shape.step + subStep) * shape.style.stepSize;
}
