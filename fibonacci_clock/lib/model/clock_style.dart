import 'dart:ui';

import 'package:flutter/material.dart';

/// Style model
class ClockStyle {
  // used to define step size
  // in order to fit shapes into provided with of the window
  static const _RATIO = 47;

  /// used for scaling
  final double stepSize;

  /// Color of the root container
  final Color background;

  /// Color of time number with in each shape
  final Color text;

  /// Color of inactive part of each shape
  final Color inactiveColor;

  /// Width of active part of each shape
  final lineWidth;

  /// Used to define the third color of the pointer in each shape
  final _isTransparent;

  /// Color of each line based on their step size: colors[step - 2]
  final List<Color> _shapeColors = [
    Colors.red,
    Colors.green,
    Colors.yellow[700],
    Colors.blueAccent
  ];

  /// Creates [ClockStyle] for dark theme
  ClockStyle.dark(Size size)
      : stepSize = size.width / _RATIO,
        background = Colors.black,
        text = Colors.white70,
        inactiveColor = Colors.grey[700],
        _isTransparent = true,
        lineWidth = 2.5;

  /// Creates [ClockStyle] for light theme
  ClockStyle.light(Size size)
      : stepSize = size.width / _RATIO,
        background = Colors.white70,
        text = Colors.black87,
        inactiveColor = Colors.grey[500],
        _isTransparent = false,
        lineWidth = 2.5;

  /// Returns third color of the pointer defined by shape's [step] field.
  Color getThirdColor(int step) =>
      _isTransparent ? Colors.transparent : getShapeColor(step);

  /// Returns shape color of the shape defined by it's step
  Color getShapeColor(int step) => _shapeColors[step - 2];
}
