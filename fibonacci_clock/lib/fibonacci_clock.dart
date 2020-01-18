import 'package:digital_clock/widget/clock_stream_context.dart';
import 'package:flutter/material.dart';

import 'model/clock.dart';
import 'model/clock_style.dart';
import 'model/shape.dart';
import 'util.dart';
import 'widget/shape_animations_widget.dart';
import 'widget/shape_line_widget.dart';
import 'widget/text_item_widget.dart';

class FibonacciClock extends StatefulWidget {
  const FibonacciClock();

  @override
  _FibonacciClockState createState() => _FibonacciClockState();
}

typedef _Creator = Widget Function(Shape shape);

class _FibonacciClockState extends State<FibonacciClock> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = _getCanvasSize(constraints.maxWidth, constraints.maxHeight);
      final style =
      _isLight(context) ? ClockStyle.light(size) : ClockStyle.dark(size);
      final internalModel = FibonacciClockModel(style);
      return Container(
          color: style.background,
          child: Center(
            child: SizedBox.fromSize(
              size: size,
              child: ClockStreamContext(child: _buildClockItems(internalModel)),
            ),
          ));
    });
  }

  _isLight(context) {
    ///KO: You can try light one, but the dark is more attractive
    return Theme
        .of(context)
        .brightness == Brightness.light;
  }

  Size _getCanvasSize(width, height) {
    double smallestSide;
    if (height > width) {
      smallestSide = width;
    } else {
      smallestSide = height;
    }
    var stepSize = smallestSide / 8;
    return Size(stepSize * 9.5, smallestSide);
  }

  _buildClockItems(clock) {
    final allWidgetCreators = [_growingLine, _flashingLine, _text];
    final clockItems = _widgets(clock.seconds, [_growingLine, _text])
      ..addAll(_widgets(clock.minutes, allWidgetCreators))..addAll(
          _widgets(clock.halfDayHours, allWidgetCreators))..addAll(
          _widgets(clock.fullDayHours, allWidgetCreators));

    return Stack(children: clockItems);
  }

  List<Widget> _widgets(Shape shape, List<_Creator> creators) =>
      creators.map((creator) => _wrap(shape, creator)).toList();

  Widget _wrap(Shape shape, _Creator creator) =>
      Positioned(
          top: fib(shape.step - 1) * shape.style.stepSize - 5,
          right: fib(shape.step) * shape.style.stepSize - 10,
          child: SizedBox.fromSize(child: creator(shape), size: shape.size));

  Widget _growingLine(Shape shape) => ShapeLineWidget(shape);

  Widget _flashingLine(Shape shape) => ShapeAnimationsWidget(shape);

  Widget _text(Shape shape) => TextItemWidget(shape);
}
