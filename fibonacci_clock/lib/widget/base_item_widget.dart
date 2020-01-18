import 'dart:async';

import 'package:digital_clock/model/clock_items.dart';
import 'package:digital_clock/model/shape.dart';
import 'package:digital_clock/model/time_change_event.dart';
import 'package:flutter/widgets.dart';

import 'clock_stream_context.dart';

/// Base class for widgets which provided storage item and calls constructor
/// of super class [StatefulWidget] with a key as [ObjectKey].
abstract class BaseItemWidget<T extends BaseItem> extends StatefulWidget {
  final T _item;

  /// Creates [BaseItemWidget] with key based on provided item
  BaseItemWidget(T item)
      : _item = item,
        super(key: ObjectKey(item));
}

/// A state of [BaseItemWidget] which has also subscription management methods.
/// Has an abstract method [timeChanged] in order to notify when time changed.
abstract class BaseItemWidgetState<T extends BaseItem>
    extends State<BaseItemWidget<T>> {
  StreamSubscription _subscription;

  /// Returns stored item in [BaseItemWidget]
  T get item => widget._item;

  /// Returns shape model of the item in [BaseItemWidget]
  Shape get shape => item.shape;

  /// See super.initState()
  @override
  void initState() {
    if (_subscription != null) {
      _subscription.resume();
    }
    super.initState();
  }

  /// Method [activateSubscription] should be call in order to initialize
  /// [_subscription] and which triggers [timeChanged] method
  void activateSubscription(BuildContext context) {
    if (_subscription == null) {
      _subscription = ClockStreamContext.of(context).listen(timeChanged);
    }
  }

  /// Abstract method [timeChanged] should implemented by a child class in
  /// order to process [TimeChangeEvent] event.
  timeChanged(TimeChangeEvent event);

  /// Method [cancelSubscription] should be called when this object is removed
  /// from the tree permanently. This method called in [dispose] by default.
  /// However, in child state classes with mixin [TickerProvider]
  /// method [cancelSubscription] should be called directly.
  void cancelSubscription() {
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  /// See super.dispose()
  @override
  void dispose() {
    cancelSubscription();
    super.dispose();
  }
}
