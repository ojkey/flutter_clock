import 'package:digital_clock/model/clock_items.dart';
import 'package:digital_clock/model/shape.dart';
import 'package:digital_clock/model/time_change_event.dart';
import 'package:digital_clock/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'base_item_widget.dart';

/// Widget class witch used to show time number based on Shape.step field.
class TextItemWidget extends BaseItemWidget<TextItem> {
  /// Creates [TextItemWidget] with provided [shape]
  TextItemWidget(Shape shape) : super(TextItem(shape));

  /// See super.createState()
  @override
  State<StatefulWidget> createState() => _TextItemWidgetState();
}

class _TextItemWidgetState extends BaseItemWidgetState<TextItem> {
  String _text = "";
  double _fontSize;
  Widget _currentText;
  EdgeInsets _margin;

  /// See super.initState()
  @override
  void initState() {
    super.initState();
    _fontSize = fib(shape.step) * shape.style.stepSize;
    _resetText(_fontSize);
    // margin initialization based on size of the font
    final centerX = _fontSize - fib(shape.step - 2) * 3;
    final centerY = _fontSize / 2 - 5;
    _margin = EdgeInsets.only(top: centerY, left: centerX);
  }

  /// See super.timeChanged(event)
  @override
  timeChanged(TimeChangeEvent event) async {
    final text = _value(event);
    if (text != _text) {
      setState(() {
        _text = text;
        _resetText(_fontSize);
      });
    }
  }

  /// See super.build(context)
  @override
  Widget build(BuildContext context) {
    activateSubscription(context);
    return Container(
      alignment: Alignment.topLeft,
      margin: _margin,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: _currentText,
      ),
    );
  }

  _resetText(fontSize) {
    _currentText = Text(_text,
        key: ObjectKey(_text),
        style: TextStyle(fontSize: fontSize, color: shape.style.text));
  }

  String _value(TimeChangeEvent event) {
    final index = item.timePartIndex;
    return event.time.substring(index, index + 1);
  }
}
