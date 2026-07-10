import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_app/core/constants/app_constants.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';

class PlaceholderTabPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderTabPage({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.verticalSpace,
            Text(title, style: context.textTheme.headlineMedium),
            8.verticalSpace,
            Text(
              'Replace this screen with your own feature.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: const Color(0xff5A6274),
              ),
            ),
            const Spacer(),
            Center(
              child: Icon(
                icon,
                size: 72.r,
                color: context.colorScheme.primary.withValues(alpha: 0.35),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
