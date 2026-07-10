import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test_app/config/theme/app_colors.dart';
import 'package:flutter_test_app/core/constants/app_constants.dart';
import 'package:flutter_test_app/core/utils/app_images.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';

Widget buildInfoTile({
  required BuildContext context,
  required String icon,
  required String label,
  VoidCallback? onTap,
  Widget? imageChild,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8.r),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: const [AppConstants.primaryCardShadow],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child:
                      imageChild ??
                      SvgPicture.asset(
                        icon,
                        width: 24.w,
                        height: 24.h,
                        colorFilter: ColorFilter.mode(
                          context.colorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                ),
              ),
              16.horizontalSpace,
              Text(
                label,
                textAlign: TextAlign.right,
                style: context.textTheme.titleMedium?.copyWith(
                  color: textColor,
                ),
              ),
            ],
          ),
          SvgPicture.asset(AppImages.arrowRight, width: 24.w, height: 24.h),
        ],
      ),
    ),
  );
}
