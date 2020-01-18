import 'package:digital_clock/model/clock_items.dart';
import 'package:digital_clock/model/shape.dart';
import 'package:digital_clock/model/time_change_event.dart';
import 'package:flutter/material.dart';

import 'base_item_widget.dart';
import 'shape_animations_painter.dart';

/// Widget class witch used to paint running flash pointer and glowing circle
/// around time item related pointer.
/// Also see [ShapeAnimationsPainter].
class ShapeAnimationsWidget extends BaseItemWidget<ShapeAnimationsItem> {
  /// Creates [ShapeAnimationsWidget] with provided [shape]
  ShapeAnimationsWidget(Shape shape) : super(ShapeAnimationsItem(shape));

  /// See super.createState()
  @override
  State<StatefulWidget> createState() => _ShapeAnimationsWidgetState();
}

/// State class of [ShapeAnimationsWidget].
/// Also see [ShapeAnimationsPainter].
class _ShapeAnimationsWidgetState
    extends BaseItemWidgetState<ShapeAnimationsItem>
    with TickerProviderStateMixin {
  static const _INVISIBLE = 0.0;
  static const _FLASH_DURATION = 1.0;
  static const _GLOW_DURATION = 2.0;
  static const _GLOW_EARLY = 0.4;
  static const _GLOW_MAX_RADIUS = 1.0;

  AnimationController _controller;

  // Single animation in order to define glow start value
  Animation<double> _animation;

  /// See super.initState()
  @override
  void initState() {
    super.initState();
    if (item.isHasAnimation()) {
      // Duration 3 seconds:
      // 1 second to change location running flash pointer
      // 2 seconds to paint glowing circle:
      //    * 1 second to increase radius;
      //    * 1 second to decrease radius.
      _controller = AnimationController(
          duration: const Duration(seconds: 3), vsync: this);
      // Animation changes in range [0.0-3.0] in order to calculate glow start
      // time after running flash hits time item pointer.
      _animation = Tween<double>(begin: 0.0, end: 3.0).animate(_controller)
        ..addListener(_animate)
        ..addStatusListener(_animationCompleted);
    }
  }

  /// See super.timeChanged(event)
  @override
  timeChanged(TimeChangeEvent event) {
    if (_canStartAnimation(event)) {
      _controller.forward();
    }
  }

  /// See super.build(context)
  @override
  Widget build(BuildContext context) {
    activateSubscription(context);
    return CustomPaint(
      size: shape.size,
      painter: ShapeAnimationsPainter(item),
    );
  }

  /// See super.dispose()
  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    cancelSubscription();
    super.dispose();
  }

  _canStartAnimation(event) =>
      event.seconds == item.flashStartTime && !_controller.isAnimating;

  _animationCompleted(AnimationStatus status) {
    if (AnimationStatus.completed == status) {
      setState(() {
        _controller.reset();
        item.animationFinished();
      });
    }
  }

  _animate() =>
      setState(() =>
          item.updateAnimation(
              _calculateFlashLength(), _calculateGlowRadius()));

  _calculateFlashLength() => _isStillFlashing() ? _animation.value : _INVISIBLE;

  _isStillFlashing() => _animation.value < _FLASH_DURATION;

  _calculateGlowRadius() {
    var glowRadius = _INVISIBLE;
    final glowStartValue = _calcGlowStartValue();
    if (_isFlashHitPointer(glowStartValue)) {
      final radius = _animation.value - glowStartValue;
      if (_isStillGlowing(radius)) {
        var cubic = Curves.easeInOutBack;
        if (_inverseGlow(radius)) {
          cubic = Curves.easeInBack;
          glowRadius = 2 - radius;
        } else {
          glowRadius = radius;
        }
        glowRadius = cubic.transform(glowRadius);
      }
    }
    return glowRadius;
  }

  _calcGlowStartValue() => shape.length - _GLOW_EARLY;

  _isFlashHitPointer(point) => _animation.value >= point;

  _isStillGlowing(radius) => radius < _GLOW_DURATION;

  _inverseGlow(radius) => radius > _GLOW_MAX_RADIUS;
}
