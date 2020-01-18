import 'dart:async';

import 'package:digital_clock/model/time_change_event.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Base class for widgets that efficiently propagate created and configured
/// stream down the tree which triggers every 100 milliseconds time changed
/// event [TimeChangeEvent].
/// Every 100 milliseconds in order to provide smooth move of colored lines
/// and their pointers.
class ClockStreamContext extends InheritedWidget {
  static const _MAX_MILLISECONDS = 1000;
  static const _MAX_SECONDS = 60;
  static const _MAX_MINUTES = 60;
  static const _MAX_DAY_HOURS = 24;
  static const _MAX_HALF_DAY_HOURS = _MAX_DAY_HOURS / 2;

  final Stream<TimeChangeEvent> _stream;

  /// Creates [ClockStreamContext] which initializes [_stream]
  ClockStreamContext({
    Key key,
    @required Widget child,
  })
      : assert(child != null),
        _stream = _createStream(),
        super(key: key, child: child);

  /// Method [of] used to obtain [ClockStreamContext] instance based on provided
  /// parameter [context].
  /// Named according to the convention.
  static ClockStreamContext of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ClockStreamContext>();
  }

  /// Adds listener of the stream and returns it's subscription.
  StreamSubscription<TimeChangeEvent> listen(
      void onData(TimeChangeEvent event)) =>
      _stream.listen(onData);

  /// See super.updateShouldNotify(old)
  @override
  bool updateShouldNotify(ClockStreamContext old) => _stream != old._stream;

  static Stream<TimeChangeEvent> _createStream() =>
      Stream<TimeChangeEvent>.periodic(
          Duration(milliseconds: 100), _createEvent)
          .asBroadcastStream();

  static TimeChangeEvent _createEvent(computation) {
    final now = DateTime.now();
    final totalSeconds = now.second + now.millisecond / _MAX_MILLISECONDS;
    final totalMinutes = totalSeconds / _MAX_SECONDS + now.minute;
    final minutesInHour = totalMinutes / _MAX_MINUTES;
    final totalHours = minutesInHour + now.hour % _MAX_HALF_DAY_HOURS;
    final totalQuoter = minutesInHour + now.hour;

    return TimeChangeEvent(_format(now), now.second, [
      totalSeconds / _MAX_SECONDS,
      totalMinutes / _MAX_MINUTES,
      totalHours / _MAX_HALF_DAY_HOURS,
      totalQuoter / _MAX_DAY_HOURS
    ]);
  }

  static String _format(DateTime value) {
    return DateFormat("HHmm").format(value);
  }
}
