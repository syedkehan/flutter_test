import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_app/core/constants/app_constants.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppConstants.logo(
        color: color ?? context.colorScheme.primary,
        width: 72.w,
        height: 72.h,
      ),
    );
  }
}
