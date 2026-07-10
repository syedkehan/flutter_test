import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test_app/config/theme/app_colors.dart';
import 'package:flutter_test_app/core/constants/app_constants.dart';
import 'package:flutter_test_app/core/utils/app_images.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';
import 'package:flutter_test_app/core/widgets/app_button.dart';
import 'package:flutter_test_app/core/widgets/scale_fade_transition.dart';

class AppDialogStyle {
  const AppDialogStyle({
    this.padding,
    this.backgroundColor = Colors.white,
    this.borderRadius = 8,
    this.blurSigmaX = 8,
    this.blurSigmaY = 8,
  });

  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;
  final double borderRadius;
  final double blurSigmaX;
  final double blurSigmaY;
}

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.child,
    this.style = const AppDialogStyle(),
    this.showCloseButton = true,
  });

  final String title;
  final Widget child;
  final AppDialogStyle style;
  final bool showCloseButton;
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x66000000),
    AppDialogStyle style = const AppDialogStyle(),
    showCloseButton = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'advisor_busy_dialog',
      barrierColor: barrierColor,
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, animation, _) {
        return SafeArea(
          // Fade the blur in with the barrier...
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
              reverseCurve: Curves.easeIn,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: style.blurSigmaX,
                sigmaY: style.blurSigmaY,
              ),
              // ...while the dialog itself pops in.
              child: Center(
                child: ScaleFadeTransition(
                  animation: animation,
                  child: AppDialog(
                    style: style,
                    title: title,
                    showCloseButton: showCloseButton,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppConstants.screenHorizontalPadding,
        vertical: 24.h,
      ),
      child: Container(
        width: double.infinity,
        padding: style.padding ?? EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: BorderRadius.circular(style.borderRadius.r),
          boxShadow: const [AppConstants.primaryCardShadow],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : MediaQuery.sizeOf(context).height * 0.9,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: .center,
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      if (showCloseButton) SizedBox(width: 40.w, height: 40.h),
                      if (title.isNotEmpty)
                        Expanded(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: context.textTheme.titleLarge?.copyWith(
                              color: textColor,
                            ),
                          ),
                        ),
                      if (showCloseButton)
                        AppButton.getIconButton(
                          context: context,
                          onPressed: () => Navigator.of(context).pop(),
                          icon: SvgPicture.asset(
                            AppImages.close,
                            width: 18.w,
                            height: 18.h,
                          ),
                          constraints: const BoxConstraints(),
                          splashRadius: 20.r,
                        ),
                    ],
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: child,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
