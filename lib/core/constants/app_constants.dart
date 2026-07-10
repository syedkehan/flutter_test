// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test_app/config/theme/app_text_styles.dart';
import 'package:flutter_test_app/core/utils/app_images.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';
import 'package:flutter_test_app/core/widgets/app_button.dart';

class AppConstants {
  static double screenHorizontalPadding = 20.w;
  static const int defaultPageLimit = 20;
  static const BoxShadow primaryCardShadow = BoxShadow(
    color: Color(0x0D000000),
    blurRadius: 30,
    spreadRadius: 0,
    offset: Offset(0, 10),
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF115E59),
      Color(0xFF0F766E),
      Color(0xFF14B8A6),
    ],
    stops: [0.0, 0.55, 1.0],
  );

  static Widget logo({Color? color, double? width, double? height}) =>
      SvgPicture.asset(
        AppImages.logo,
        width: width ?? 88.w,
        height: height ?? 88.h,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(color, BlendMode.srcIn),
      );
  static Widget silverAppBar({
    bool showBackButton = false,
    String? title,
    TextStyle? titleStyle,
    String? subtitle,
    TextStyle? subtitleStyle,
    Widget? leading,
    Widget? action,
    List<Widget>? rowChildren,
    Widget? backIcon,
    VoidCallback? onBackPressed,
    bool pinned = false,
    bool floating = false,
    bool snap = false,
    bool keepExpandedHeightOnScroll = false,
    required BuildContext context,
  }) {
    final expandedHeight = 124.0.h;
    // final expandedHeight = 143.0.h;
    final bool shouldShowBackButton = showBackButton;
    final bool shouldPinAppBar = pinned || shouldShowBackButton;

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final double collapseTriggerOffset = expandedHeight - kToolbarHeight;
        final bool isCollapsed =
            shouldPinAppBar &&
            !keepExpandedHeightOnScroll &&
            constraints.scrollOffset > (collapseTriggerOffset - 4);
        final bool showToolbarBackButton = shouldShowBackButton && isCollapsed;
        final bool showFlexibleBackButton =
            shouldShowBackButton && !isCollapsed;
        final void Function() handleBack =
            onBackPressed ?? () => Navigator.pop(context);
        final bool shouldUseDarkStatusBarIcons =
            !shouldShowBackButton && constraints.scrollOffset > 0;
        // final double collapsedToolbarHeight = 72.h;
        final double collapsedToolbarHeight = 88.h;
        final double resolvedToolbarHeight = keepExpandedHeightOnScroll
            ? 0
            : (showToolbarBackButton ? collapsedToolbarHeight : kToolbarHeight);

        return SliverAppBar(
          automaticallyImplyLeading: false,
          leadingWidth: showToolbarBackButton ? 80.w : null,
          leading: showToolbarBackButton
              ? Align(
                  alignment: Alignment.center,
                  child: AppButton.getIconButton(
                    context: context,
                    onPressed: handleBack,
                    icon: backIcon,
                    iconAsset: backIcon == null ? AppImages.arrowLeft : null,
                  ),
                )
              : null,
          backgroundColor: context.colorScheme.primary,
          expandedHeight: expandedHeight,
          pinned: shouldPinAppBar,
          floating: floating,
          snap: snap && floating,
          systemOverlayStyle: shouldUseDarkStatusBarIcons
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
          toolbarHeight: resolvedToolbarHeight,
          collapsedHeight: keepExpandedHeightOnScroll ? expandedHeight : null,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenHorizontalPadding,
              ),
              decoration: const BoxDecoration(
                gradient: AppConstants.primaryGradient,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .start,
                  children:
                      rowChildren ??
                      [
                        if (showFlexibleBackButton) ...[
                          AppButton.getIconButton(
                            context: context,
                            onPressed: handleBack,
                            icon: backIcon,
                            iconAsset: backIcon == null
                                ? AppImages.arrowLeft
                                : null,
                          ),
                          16.horizontalSpace,
                        ],
                        if (leading != null) ...[leading, 16.horizontalSpace],
                        if (title != null || subtitle != null)
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (title != null)
                                  Text(
                                    title,
                                    style:
                                        titleStyle ??
                                        context.textTheme.titleLarge?.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                if (subtitle != null) ...[
                                  4.verticalSpace,
                                  Text(
                                    subtitle,
                                    style:
                                        subtitleStyle ??
                                        context.textTheme.bodyMedium?.copyWith(
                                          color: Colors.white,
                                          fontFamily: urbanist,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        if (action != null) ...[12.horizontalSpace, action],
                      ],
                ),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 0.h),
            child: Container(
              height: 20.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24.r),
                  topLeft: Radius.circular(24.r),
                ),
                border: Border.all(style: BorderStyle.none),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget sliverToBoxAdapter({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.only(
      top: 0,
      left: 20,
      right: 20,
      bottom: 20,
    ),
  }) => SliverToBoxAdapter(
    child: Padding(padding: padding, child: child),
  );
}
