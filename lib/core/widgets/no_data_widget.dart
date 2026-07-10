import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_app/config/theme/app_colors.dart';
import 'package:flutter_test_app/config/theme/app_text_styles.dart';
import 'package:flutter_test_app/core/constants/app_constants.dart';

import 'package:flutter_test_app/core/utils/extensions.dart';

class NoDataWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const NoDataWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 38.h),
    child: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [AppConstants.primaryCardShadow],
            ),
            child: Icon(icon, color: context.colorScheme.primary, size: 64.sp),
          ),
          24.verticalSpace,
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.textTheme.titleLarge?.copyWith(color: textColor),
          ),
          12.verticalSpace,
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: context.textTheme.titleSmall?.copyWith(
              color: const Color(0xff5A6274),
              fontFamily: urbanist,
            ),
          ),
          ],
        ),
      ),
    ),
  );
}
