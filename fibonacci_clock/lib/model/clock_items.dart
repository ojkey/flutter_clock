import 'shape.dart';

/// Model of base item which is built within this clock.
/// Mostly these objects are used as object key of the widget.
abstract class BaseItem {
  /// Shape which contains basic settings
  final Shape shape;

  // internal constructor
  BaseItem._(this.shape);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BaseItem &&
              runtimeType == other.runtimeType &&
              shape == other.shape;

  @override
  int get hashCode => runtimeType.hashCode ^ shape.hashCode;
}

/// Model of drawn colored shape line.
class ShapeLineItem extends BaseItem {
  /// Creates [ShapeLineItem].
  ShapeLineItem(Shape model) : super._(model);
}

/// Model of flashing (running) and glowing pointer.
class ShapeAnimationsItem extends BaseItem {
  static const _START_NEVER = -1;
  static const _START_POSITION = 54;

  /// [flashStartTime] determines when to run flashing pointer.
  final int flashStartTime;

  /// Flash pointer's location as length from the beginning of the line.
  /// Change range: 0.0 -> 1.0
  double flashLength = 0.0;

  /// Radius of the glowing circle when flash pointer hits time pointer.
  /// Change range: 0.0 -> 1.0
  double glowRadius = 0.0;

  /// Creates [ShapeAnimationsItem] with [flashStartTime] initialization.
  ShapeAnimationsItem(Shape model)
      : flashStartTime = _flashStartTime(model),
        super._(model);

  /// Returns true when running flash pointer animation is active
  bool get isFlashing => flashLength > 0.0;

  /// Returns true when glow animation is active
  bool get isGlowing => glowRadius > 0.0;

  /// Items which presents [STEP_MINUTES],[STEP_HALF_DAY] and [STEP_FULL_DAY]
  /// can flash and glow.
  /// Only [STEP_SECONDS] is not flashing and glowing
  bool isHasAnimation() => shape.step > STEP_SECONDS;

  /// Called when animation finished.
  /// Resets to zeros animation related fields
  void animationFinished() => updateAnimation(0.0, 0.0);

  /// Updates values of animation related fields
  void updateAnimation(double flashLength, double glowRadius) {
    this.flashLength = flashLength;
    this.glowRadius = glowRadius;
  }

  static _flashStartTime(Shape model) =>
      model.step == STEP_SECONDS
          ? _START_NEVER
          : _START_POSITION + model.step.round();
}

/// Model of text number that is drawn with in each shape circles
class TextItem extends BaseItem {
  /// Character index in the 'HHmm' time format string
  final int timePartIndex;

  /// Creates [TextItem] with [timePartIndex] initialization
  TextItem(Shape model)
      : timePartIndex = _timePartIndex(model),
        super._(model);

  static _timePartIndex(Shape model) => (STEP_FULL_DAY - model.step.ceil());
}
