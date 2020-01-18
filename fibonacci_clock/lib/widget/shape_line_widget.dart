import 'package:digital_clock/model/clock_items.dart';
import 'package:digital_clock/model/shape.dart';
import 'package:digital_clock/model/time_change_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_item_widget.dart';
import 'shape_line_painter.dart';

/// Widget class witch used to paint time item related active and inactive line
/// shape and pointer at the of the active line.
/// Also see [ShapeLinePainter].
class ShapeLineWidget extends BaseItemWidget<ShapeLineItem> {
  /// Creates [ShapeLineWidget] with provided [shape]
  ShapeLineWidget(Shape shape) : super(ShapeLineItem(shape));

  /// See super.createState()
  @override
  State<StatefulWidget> createState() => _ShapeLineWidgetState();
}

/// State class of [ShapeLineWidget].
/// Also see [ShapeLinePainter].
class _ShapeLineWidgetState extends BaseItemWidgetState<ShapeLineItem> {
  int _seconds = 0;

  /// See super.timeChanged(event)
  @override
  timeChanged(TimeChangeEvent event) async {
    final length = event.itemLength(shape.step);
    if (length != shape.length) {
      setState(() {
        _seconds = event.seconds;
        shape.length = length;
      });
    }
  }

  /// See super.build(context)
  @override
  Widget build(BuildContext context) {
    activateSubscription(context);
    return CustomPaint(
      size: shape.size,
      painter: ShapeLinePainter(shape, _seconds),
    );
  }
}
