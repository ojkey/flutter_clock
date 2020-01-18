import 'dart:ui';

import 'package:digital_clock/util.dart';
import 'package:flutter/material.dart';

import 'clock_style.dart';

/// Step of the 4th (smallest) shape
const STEP_SECONDS = 2;

/// Step of the 3rd shape
const STEP_MINUTES = 3;

/// Step of the 2nd shape
const STEP_HALF_DAY = 4;

/// Step of the 1st (biggest) shape
const STEP_FULL_DAY = 5;

/// Drawn shape model of the clock item
class Shape {
  /// Determines type, location and size of the shape
  final int step;

  /// Size of the shape. Used to define it's location in the container
  final Size size;

  /// Manages starting angle of the first sub-shape
  final bool earlierStart;

  /// Manages ending angle of the last sub-shape
  final bool laterEnd;

  /// Reference to clock's style
  final ClockStyle style;

  /// Line's length of active part which is colored.
  /// Change range: 0.0 -> 1.0
  double length = 0.0;

  // Common private constructor
  Shape._(this.step, this.earlierStart, this.laterEnd, this.style)
      : size = _calcSize(step, style.stepSize);

  /// Creates [Shape] of running seconds shape visualization
  Shape.seconds(ClockStyle style) : this._(STEP_SECONDS, true, false, style);

  /// Creates [Shape] running minutes shape visualization
  Shape.minutes(ClockStyle style) : this._(STEP_MINUTES, false, false, style);

  /// Creates [Shape] running half day hours shape visualization
  Shape.halfDayHours(ClockStyle style)
      : this._(STEP_HALF_DAY, false, false, style);

  /// Creates [Shape] running full day hours shape visualization
  Shape.fullDayHours(ClockStyle style)
      : this._(STEP_FULL_DAY, false, true, style);

  /// Shape color
  Color get color => style.getShapeColor(step);

  /// Pointer's third color in shader
  Color get thirdColor => style.getThirdColor(step);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Shape &&
              runtimeType == other.runtimeType &&
              step == other.step &&
              size == other.size &&
              length == other.length &&
              earlierStart == other.earlierStart &&
              laterEnd == other.laterEnd &&
              color == other.color;

  @override
  int get hashCode =>
      step.hashCode ^
      size.hashCode ^
      length.hashCode ^
      earlierStart.hashCode ^
      laterEnd.hashCode ^
      color.hashCode;

  static Size _calcSize(int step, double stepSize) =>
      Size(
          (fib(step) + fib(step + 1)) * stepSize,
          (fib(step) + fib(step + 2)) * stepSize / 1.2);
}
