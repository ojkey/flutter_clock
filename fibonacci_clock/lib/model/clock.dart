import 'clock_style.dart';
import 'shape.dart';

/// Clock model which stores configuration of each item, which is used to paint
/// shapes, animations and set location and size of the text.
class FibonacciClockModel {
  /// Shape based on current seconds
  final Shape seconds;

  /// Shape based on current minutes
  final Shape minutes;

  /// Shape based on current half day hours (12 hours)
  final Shape halfDayHours;

  /// Shape based on current full day hours (24 hours)
  final Shape fullDayHours;

  /// Creates [FibonacciClockModel] model with shape model initialization  of each items
  FibonacciClockModel(ClockStyle style)
      : seconds = Shape.seconds(style),
        minutes = Shape.minutes(style),
        halfDayHours = Shape.halfDayHours(style),
        fullDayHours = Shape.fullDayHours(style);
}
