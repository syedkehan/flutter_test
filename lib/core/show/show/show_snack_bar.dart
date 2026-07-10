import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_test_app/config/theme/app_colors.dart';
import 'package:flutter_test_app/core/constants/global.dart';
import 'package:flutter_test_app/core/utils/error_display_helper.dart';
import 'package:flutter_test_app/domain/failures/network/network_failure.dart';

const Color _snackBarBackground = Color(0xFF1C1C1E);
const Color _snackBarTextColor = Color(0xFFF5F5F5);
const Color _snackBarActionColor = Color(0xFFB0B0B0);

List<BoxShadow> get _snackBarShadows => [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.18),
        blurRadius: 20.r,
        offset: Offset(0, 8.h),
      ),
    ];

ShapeBorder _snackBarShape() => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.r),
    );

EdgeInsets _snackBarMargin() =>
    EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h);

void _dismissScaffoldSnackBar() {
  GlobalConstants.scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
}

SnackBarAction _snackBarDismissAction({VoidCallback? onDismiss}) {
  return SnackBarAction(
    label: 'Dismiss',
    textColor: _snackBarActionColor,
    onPressed: onDismiss ?? _dismissScaffoldSnackBar,
  );
}

SnackBar _buildSnackBar({
  required Widget content,
  SnackBarAction? action,
}) {
  return SnackBar(
    content: content,
    backgroundColor: _snackBarBackground,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.down,
    shape: _snackBarShape(),
    margin: _snackBarMargin(),
    duration: const Duration(seconds: 3),
    persist: false,
    action: action ?? _snackBarDismissAction(),
  );
}

/// Animated snackbar content with optional leading icon.
class _SnackBarMessage extends StatefulWidget {
  final String message;
  final IconData? icon;
  final Color? iconColor;

  const _SnackBarMessage({
    required this.message,
    this.icon,
    this.iconColor,
  });

  @override
  State<_SnackBarMessage> createState() => _SnackBarMessageState();
}

class _SnackBarMessageState extends State<_SnackBarMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.iconColor ?? AppColors.primary;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Row(
          children: [
            if (widget.icon != null) ...[
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: iconColor,
                  size: 20.sp,
                ),
              ),
              12.horizontalSpace,
            ],
            Expanded(
              child: Text(
                widget.message,
                style: TextStyle(
                  color: _snackBarTextColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showAppSnackBar(SnackBar snackBar) {
  final navigatorState = GlobalConstants.navigatorKey.currentState;

  // If a dialog (PopupRoute) is active the Scaffold snackbar is hidden behind
  // the dialog barrier. In that case insert the snackbar directly into the
  // root overlay so it renders above the dialog.
  bool hasPopupRoute = false;
  navigatorState?.popUntil((route) {
    if (route is PopupRoute) hasPopupRoute = true;
    return true; // never actually pops anything
  });

  if (hasPopupRoute && navigatorState != null) {
    _showOverlaySnackBar(navigatorState, snackBar);
    return;
  }

  final messenger = GlobalConstants.scaffoldMessengerKey.currentState;
  if (messenger == null) return;
  messenger.clearSnackBars();
  messenger.showSnackBar(snackBar);
}

void _showOverlaySnackBar(NavigatorState navigator, SnackBar snackBar) {
  late OverlayEntry entry;
  final duration = snackBar.duration;

  entry = OverlayEntry(
    builder: (context) => _OverlaySnackBar(
      snackBar: snackBar,
      onDismiss: () {
        if (entry.mounted) entry.remove();
      },
    ),
  );

  navigator.overlay?.insert(entry);

  Future.delayed(duration, () {
    if (entry.mounted) entry.remove();
  });
}

/// Mirrors [SnackBar] appearance but lives directly in the root [Overlay]
/// so it renders above any dialog or barrier.
class _OverlaySnackBar extends StatefulWidget {
  const _OverlaySnackBar({
    required this.snackBar,
    required this.onDismiss,
  });

  final SnackBar snackBar;
  final VoidCallback onDismiss;

  @override
  State<_OverlaySnackBar> createState() => _OverlaySnackBarState();
}

class _OverlaySnackBarState extends State<_OverlaySnackBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..forward();
    _slide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snackBar = widget.snackBar;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Positioned(
      bottom: 20.h + bottomInset,
      left: 16.w,
      right: 16.w,
      child: SlideTransition(
        position: _slide,
        child: Material(
          color: Colors.transparent,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: snackBar.backgroundColor ?? _snackBarBackground,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: _snackBarShadows,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 8.w, 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: snackBar.content),
                  if (snackBar.action != null)
                    TextButton(
                      onPressed: () {
                        snackBar.action!.onPressed();
                        widget.onDismiss();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: _snackBarActionColor,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        snackBar.action!.label,
                        style: TextStyle(
                          color: snackBar.action!.textColor ?? _snackBarActionColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

mixin ShowSnackBarSuccess {
  void showSuccessSnackBar(String message) {
    _showAppSnackBar(
      _buildSnackBar(
        content: _SnackBarMessage(
          message: message,
          icon: Icons.check_circle_rounded,
          iconColor: const Color(0xFF6EE7A0),
        ),
        action: _snackBarDismissAction(),
      ),
    );
  }
}

mixin ShowSnackBarError {
  /// Shows error snackbar with NetworkFailure
  void showNetworkErrorSnackBar(BuildContext context, NetworkFailure failure) {
    final properties = ErrorDisplayHelper.getDisplayProperties(
      context,
      failure,
    );

    _showAppSnackBar(
      _buildSnackBar(
        content: _SnackBarMessage(
          message: properties.title,
          icon: properties.icon,
          iconColor: AppColors.primary,
        ),
        action: _snackBarDismissAction(),
      ),
    );
  }

  /// Shows error snackbar with simple string message (backward compatibility)
  void showErrorSnackBar(String message) {
    _showAppSnackBar(
      _buildSnackBar(
        content: _SnackBarMessage(
          message: message,
          icon: Icons.info_outline_rounded,
          iconColor: AppColors.primary,
        ),
        action: _snackBarDismissAction(),
      ),
    );
  }
}
