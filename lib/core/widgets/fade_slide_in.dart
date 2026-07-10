import 'package:flutter/material.dart';

/// Plays a one-shot fade + slide when first built.
///
/// Give a list of these an increasing [delay] (e.g. `index * 60ms`) and the
/// items read as a gentle cascade as they appear.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 380),
    this.offset = const Offset(0, 0.08),
    this.scaleBegin,
    this.curve = Curves.easeOutCubic,
    this.onComplete,
  });

  final Widget child;

  /// How long to wait before starting — used to stagger sibling items.
  final Duration delay;

  /// Length of the fade/slide itself.
  final Duration duration;

  /// Starting offset, as a fraction of the child's size.
  final Offset offset;

  /// When set, the child also scales from this value to `1.0`.
  final double? scaleBegin;

  final Curve curve;

  /// Called once when the entrance animation finishes.
  final VoidCallback? onComplete;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: widget.curve,
  );

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: widget.offset,
    end: Offset.zero,
  ).animate(_fade);

  void _startAnimation() {
    _controller.forward().then((_) {
      if (mounted) widget.onComplete?.call();
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _startAnimation();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _startAnimation();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;

    if (widget.scaleBegin != null) {
      child = ScaleTransition(
        scale: Tween<double>(
          begin: widget.scaleBegin,
          end: 1,
        ).animate(_fade),
        child: child,
      );
    }

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: child),
    );
  }
}

/// Shared timing and geometry for list/card entrance animations.
abstract final class ListEntrance {
  static const duration = Duration(milliseconds: 320);
  static const scaleBegin = 0.97;
  static const verticalOffset = Offset(0, 0.04);
  static const horizontalOffset = Offset(0.08, 0);

  /// Stagger delay for the first [maxStaggerIndex + 1] items only.
  static Duration staggerDelay(
    int index, {
    int maxStaggerIndex = 6,
    int stepMs = 48,
  }) {
    if (index > maxStaggerIndex) return Duration.zero;
    return Duration(milliseconds: stepMs * index);
  }
}

/// Plays a one-shot list entrance and remembers [itemKey] in [revealedKeys]
/// so scrolling back does not replay the animation.
class ListEntranceReveal extends StatelessWidget {
  const ListEntranceReveal({
    super.key,
    required this.itemKey,
    required this.index,
    required this.revealedKeys,
    required this.onRevealed,
    required this.child,
    this.offset = ListEntrance.verticalOffset,
    this.staggerStepMs = 48,
  });

  final String itemKey;
  final int index;
  final Set<String> revealedKeys;
  final ValueChanged<String> onRevealed;
  final Widget child;
  final Offset offset;
  final int staggerStepMs;

  @override
  Widget build(BuildContext context) {
    if (revealedKeys.contains(itemKey)) return child;

    return FadeSlideIn(
      key: ValueKey('list-enter-$itemKey'),
      delay: ListEntrance.staggerDelay(index, stepMs: staggerStepMs),
      duration: ListEntrance.duration,
      offset: offset,
      scaleBegin: ListEntrance.scaleBegin,
      curve: Curves.easeOutCubic,
      onComplete: () => onRevealed(itemKey),
      child: child,
    );
  }
}
