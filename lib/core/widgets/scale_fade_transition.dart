import 'package:flutter/material.dart';

/// A combined scale + fade transition for dialogs and popups.
///
/// Drive it with the `animation` handed to a `showGeneralDialog`
/// `pageBuilder`/`transitionBuilder`. The child scales up from [beginScale]
/// toward its anchor ([alignment]) while fading in, and reverses on dismiss.
class ScaleFadeTransition extends StatelessWidget {
  const ScaleFadeTransition({
    super.key,
    required this.animation,
    required this.child,
    this.alignment = Alignment.center,
    this.beginScale = 0.92,
    this.scaleCurve = Curves.easeOutBack,
  });

  final Animation<double> animation;
  final Widget child;
  final Alignment alignment;
  final double beginScale;
  final Curve scaleCurve;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
      child: ScaleTransition(
        alignment: alignment,
        scale: Tween<double>(begin: beginScale, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: scaleCurve,
            reverseCurve: Curves.easeInCubic,
          ),
        ),
        child: child,
      ),
    );
  }
}
