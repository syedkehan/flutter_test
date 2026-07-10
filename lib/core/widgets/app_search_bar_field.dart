import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test_app/core/utils/app_images.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';
import 'package:flutter_test_app/core/widgets/app_text_form_field.dart';

import 'package:flutter_test_app/config/theme/app_text_styles.dart';

/// Pill-shaped search field used on Search and Messages screens.
class AppSearchBarField extends StatelessWidget {
  const AppSearchBarField({
    super.key,
    required this.controller,
    this.onChanged,
    this.margin,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: AppTextFormField(
        borderRadius: 24.r,
        controller: controller,
        hintText: 'Search by name or keyword......',
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 6.w),
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: 1,
            child: SvgPicture.asset(
              AppImages.search,
              width: 22.w,
              height: 22.h,
              colorFilter: const ColorFilter.mode(
                Color(0xff5A6274),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: 0,
          minHeight: 46.h,
        ),
        type: AppTextFieldType.search,
        config: AppTextFieldConfig(
          hintStyle: context.textTheme.bodyMedium?.copyWith(
            color: const Color(0xff5A6274),
            fontFamily: urbanist,
          ),
        ),
        borderColor: const Color(0xFFEEEEEE),
        onChanged: onChanged,
      ),
    );
  }
}
