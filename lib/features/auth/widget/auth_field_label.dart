import 'package:flutter/material.dart';
import 'package:flutter_test_app/config/theme/app_colors.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';

class AuthFieldLabel extends StatelessWidget {
  const AuthFieldLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: context.textTheme.titleMedium?.copyWith(color: textColor),
      ),
    );
  }
}
