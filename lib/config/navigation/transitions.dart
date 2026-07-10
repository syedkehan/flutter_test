import 'package:flutter/material.dart';

import 'package:flutter_test_app/config/navigation/transition_type.dart';

/// An iOS-style page route.
///
/// The incoming page slides in from the edge implied by [TransitionType] using
/// Cupertino easing, while the page underneath eases a third of the way in the
/// same direction (parallax) with a soft leading-edge shadow — mirroring the
/// native iOS push. Vertical transitions present like an iOS modal sheet.
class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({required this.child, required this.type})
    : super(
        transitionDuration: type._duration,
        reverseTransitionDuration: type._reverseDuration,
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder:
            (context, animation, secondaryAnimation, transitionChild) =>
                _CupertinoStyleTransition(
                  type: type,
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: transitionChild,
                ),
      );

  final Widget child;
  final TransitionType type;
}

class _CupertinoStyleTransition extends StatelessWidget {
  const _CupertinoStyleTransition({
    required this.type,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  final TransitionType type;
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  // The exact easing pair iOS uses for push/pop.
  static const _curve = Curves.linearToEaseOut;
  static const _reverseCurve = Curves.easeInToLinear;

  @override
  Widget build(BuildContext context) {
    final enter = Tween<Offset>(begin: type._enterOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: animation,
            curve: _curve,
            reverseCurve: _reverseCurve,
          ),
        );

    final exit = Tween<Offset>(begin: Offset.zero, end: type._exitOffset)
        .animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: _curve,
            reverseCurve: _reverseCurve,
          ),
        );

    Widget incoming = SlideTransition(position: enter, child: child);

    // Soft leading-edge shadow on horizontal pushes, like iOS.
    if (type._isHorizontal) {
      incoming = DecoratedBoxTransition(
        decoration: DecorationTween(
          begin: const BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.transparent, blurRadius: 0)],
          ),
          end: const BoxDecoration(
            boxShadow: [BoxShadow(color: Color(0x2E000000), blurRadius: 14)],
          ),
        ).animate(animation),
        child: incoming,
      );
    }

    return SlideTransition(position: exit, child: incoming);
  }
}

extension on TransitionType {
  bool get _isHorizontal =>
      this == TransitionType.slideFromRight ||
      this == TransitionType.slideFromLeft;

  /// Where the incoming page starts from, relative to its own size.
  Offset get _enterOffset {
    switch (this) {
      case TransitionType.slideFromRight:
        return const Offset(1, 0);
      case TransitionType.slideFromLeft:
        return const Offset(-1, 0);
      case TransitionType.slideFromBottom:
        return const Offset(0, 1);
      case TransitionType.slideFromTop:
        return const Offset(0, -1);
    }
  }

  /// Parallax drift for the page being covered: a third of the screen in the
  /// same direction for horizontal pushes, none for vertical (modal) ones.
  Offset get _exitOffset =>
      _isHorizontal ? _enterOffset * (-1 / 3) : Offset.zero;

  Duration get _duration => this == TransitionType.slideFromBottom
      ? const Duration(milliseconds: 380)
      : const Duration(milliseconds: 320);

  Duration get _reverseDuration => this == TransitionType.slideFromBottom
      ? const Duration(milliseconds: 300)
      : const Duration(milliseconds: 280);
}
