import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_app/config/theme/app_colors.dart';
import 'package:flutter_test_app/core/constants/app_constants.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';

class AppDraggableBottomSheetStyle {
  const AppDraggableBottomSheetStyle({
    this.borderRadius = 32,
    this.blurSigmaX = 8,
    this.blurSigmaY = 8,
    this.maxChildSize = 0.92,
    this.initialChildSize = 0.65,
    this.minChildSize = 0.35,
  });

  final double borderRadius;
  final double blurSigmaX;
  final double blurSigmaY;
  final double maxChildSize;
  final double initialChildSize;
  final double minChildSize;
}

typedef AppDraggableBottomSheetChildBuilder =
    Widget Function(ScrollController scrollController);

class AppDraggableBottomSheet extends StatelessWidget {
  const AppDraggableBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.style = const AppDraggableBottomSheetStyle(),
    this.scrollController,
    this.useInternalScroll = true,
  });

  final String title;
  final Widget child;
  final AppDraggableBottomSheetStyle style;
  final ScrollController? scrollController;
  final bool useInternalScroll;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    Widget? child,
    AppDraggableBottomSheetChildBuilder? childBuilder,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useSafeArea = true,
    AppDraggableBottomSheetStyle style = const AppDraggableBottomSheetStyle(),
    bool showCloseButton = true,
    bool useInternalScroll = true,
  }) {
    assert(
      child != null || childBuilder != null,
      'Provide either child or childBuilder.',
    );
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      // Smoother, slightly slower slide than the Material default.
      sheetAnimationStyle: const AnimationStyle(
        duration: Duration(milliseconds: 360),
        reverseDuration: Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
      constraints: BoxConstraints(
        minWidth: MediaQuery.sizeOf(context).width,
        maxWidth: MediaQuery.sizeOf(context).width,
      ),
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: style.blurSigmaX,
            sigmaY: style.blurSigmaY,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: style.initialChildSize,
            minChildSize: style.minChildSize,
            maxChildSize: style.maxChildSize,
            expand: false,
            builder: (context, scrollController) {
              final body = AppDraggableBottomSheet(
                title: title,
                style: style,
                scrollController: scrollController,
                useInternalScroll: useInternalScroll,
                child: childBuilder?.call(scrollController) ?? child!,
              );

              if (!useSafeArea) return body;

              return SafeArea(top: false, child: body);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(style.borderRadius.r),
      ),
      child: Material(
        color: Colors.white,
        child: Container(
          width: double.infinity,

          padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [AppConstants.primaryCardShadow],
          ),
          child: Column(
            children: [
              if (title.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: textColor,
                    ),
                  ),
                ),
              Expanded(
                child: useInternalScroll
                    ? SingleChildScrollView(
                        controller: scrollController,
                        child: child,
                      )
                    : child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
