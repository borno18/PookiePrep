import 'package:flutter/material.dart';
import 'bn.dart';

/// Emil Kowalski-inspired tactile micro-interaction wrapper.
///
/// Compresses slightly on press down (scale: 0.965) and springs back on release,
/// providing physical, tactile feedback for cards, buttons, and interactive elements.
/// Respects [MediaQuery.disableAnimationsOf(context)].
class PookiePressable extends StatefulWidget {
  const PookiePressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.pressedScale = 0.965,
    this.borderRadius,
    this.behavior = HitTestBehavior.opaque,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double pressedScale;
  final BorderRadius? borderRadius;
  final HitTestBehavior behavior;

  @override
  State<PookiePressable> createState() => _PookiePressableState();
}

class _PookiePressableState extends State<PookiePressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      reverseDuration: const Duration(milliseconds: 180),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressedScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (widget.onTap == null && widget.onLongPress == null) return;
    if (MediaQuery.disableAnimationsOf(context)) return;
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onTap == null) return;
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (_controller.value > 0) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null && widget.onLongPress == null) {
      return widget.child;
    }

    final disabled = MediaQuery.disableAnimationsOf(context);

    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: disabled
          ? widget.child
          : AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) => Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
              child: widget.child,
            ),
    );
  }
}

/// An animated number ticker that smoothly counts up to [endValue]
/// and displays it using Bengali numerals via [toBn].
/// Respects [MediaQuery.disableAnimationsOf(context)].
class AnimatedCountUpText extends StatelessWidget {
  const AnimatedCountUpText({
    super.key,
    required this.endValue,
    this.style,
    this.duration = const Duration(milliseconds: 650),
    this.prefix = '',
    this.suffix = '',
  });

  final int endValue;
  final TextStyle? style;
  final Duration duration;
  final String prefix;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context) || endValue == 0) {
      return Text('$prefix${toBn(endValue)}$suffix', style: style);
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: endValue.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Text(
          '$prefix${toBn(value.round())}$suffix',
          style: style,
        );
      },
    );
  }
}

/// An animated score ticker for floating point scores.
class AnimatedCountUpScore extends StatelessWidget {
  const AnimatedCountUpScore({
    super.key,
    required this.score,
    required this.total,
    this.style,
    this.duration = const Duration(milliseconds: 700),
  });

  final double score;
  final int total;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return Text('${formatScore(score)} / ${toBn(total)}', style: style);
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: score),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, val, _) {
        return Text('${formatScore(val)} / ${toBn(total)}', style: style);
      },
    );
  }
}

/// A smoothly interpolated linear progress indicator that slides naturally
/// instead of jumping abruptly between values.
class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.value,
    required this.color,
    required this.backgroundColor,
    this.minHeight = 4,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 280),
  });

  final double value;
  final Color color;
  final Color backgroundColor;
  final double minHeight;
  final BorderRadius? borderRadius;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final disabled = MediaQuery.disableAnimationsOf(context);

    if (disabled) {
      final bar = LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(color),
        minHeight: minHeight,
      );
      if (borderRadius != null) {
        return ClipRRect(borderRadius: borderRadius!, child: bar);
      }
      return bar;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: value.clamp(0.0, 1.0)),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, val, _) {
        final bar = LinearProgressIndicator(
          value: val,
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: minHeight,
        );
        if (borderRadius != null) {
          return ClipRRect(borderRadius: borderRadius!, child: bar);
        }
        return bar;
      },
    );
  }
}

/// A subtle breathing pulse badge, ideal for urgent timer indicators.
/// Automatically remains completely static if reduced motion is preferred.
class PulsingBadge extends StatefulWidget {
  const PulsingBadge({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  State<PulsingBadge> createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<PulsingBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.enabled) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant PulsingBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled && !MediaQuery.disableAnimationsOf(context)) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 0;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || MediaQuery.disableAnimationsOf(context)) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) => Transform.scale(
        scale: _scale.value,
        child: child,
      ),
      child: widget.child,
    );
  }
}
