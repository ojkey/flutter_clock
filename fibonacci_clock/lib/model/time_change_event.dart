/// [TimeChangeEvent] fired when time changed. Contains [seconds], time
/// formatted in HHmm and method [itemLength].
class TimeChangeEvent {
  /// Current [time] string
  final String time;

  /// Current [seconds]
  final int seconds;
  final List<double> _timeItemLengths;

  /// Creates [TimeChangeEvent] with provided [time], [seconds] and
  /// lengths of each time item[_timeItemLengths].
  TimeChangeEvent(this.time, this.seconds, this._timeItemLengths);

  /// Returns length of the item based on [step] value, which is transformed
  /// into index of the list.
  double itemLength(int step) {
    return _timeItemLengths[step - 2];
  }
}
