import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_app/core/utils/clipboard_util.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';

enum CopyTrigger { tap, longPress }

/// Wraps [child] and copies [copyText] on tap or long-press.
class CopyableGesture extends StatelessWidget {
  const CopyableGesture({
    super.key,
    required this.copyText,
    required this.child,
    this.trigger = CopyTrigger.tap,
    this.feedbackMessage,
    this.enabled = true,
  });

  final String copyText;
  final Widget child;
  final CopyTrigger trigger;
  final String? feedbackMessage;
  final bool enabled;

  void _copy() {
    copyToClipboard(
      copyText,
      successMessage: feedbackMessage ?? 'Copied to clipboard',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!enabled || copyText.trim().isEmpty) return child;

    if (trigger == CopyTrigger.longPress) {
      return GestureDetector(
        onLongPress: _copy,
        behavior: HitTestBehavior.opaque,
        child: child,
      );
    }

    return GestureDetector(
      onTap: _copy,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}

/// Label + value row that copies the full [value] when tapped.
class CopyableValueRow extends StatelessWidget {
  const CopyableValueRow({
    super.key,
    required this.label,
    required this.value,
    this.displayValue,
    this.labelStyle,
    this.valueStyle,
    this.padding,
    this.feedbackMessage,
    this.showCopyIcon = true,
    this.backgroundColor,
    this.borderRadius,
  });

  final String label;
  final String value;
  final String? displayValue;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final EdgeInsetsGeometry? padding;
  final String? feedbackMessage;
  final bool showCopyIcon;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  static const _mutedColor = Color(0xFF5A6274);

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            style: labelStyle ??
                context.textTheme.bodyMedium?.copyWith(color: _mutedColor),
          ),
        ),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  value.trim().isEmpty ? '—' : (displayValue ?? value),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: valueStyle,
                ),
              ),
              if (showCopyIcon && value.trim().isNotEmpty) ...[
                6.horizontalSpace,
                Icon(
                  Icons.copy_rounded,
                  size: 16.sp,
                  color: _mutedColor,
                ),
              ],
            ],
          ),
        ),
      ],
    );

    final child = padding != null
        ? Padding(padding: padding!, child: content)
        : content;

    if (value.trim().isEmpty) {
      if (backgroundColor != null) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
          ),
          child: child,
        );
      }
      return child;
    }

    return CopyableGesture(
      copyText: value,
      feedbackMessage: feedbackMessage ?? '$label copied',
      child: backgroundColor != null
          ? DecoratedBox(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius,
              ),
              child: child,
            )
          : child,
    );
  }
}

/// Compact inline text with an optional trailing copy icon.
class CopyableInlineText extends StatelessWidget {
  const CopyableInlineText({
    super.key,
    required this.text,
    this.style,
    this.iconColor,
    this.feedbackMessage,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final Color? iconColor;
  final String? feedbackMessage;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) {
      return Text(
        '—',
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    return CopyableGesture(
      copyText: text,
      feedbackMessage: feedbackMessage,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              style: style,
              textAlign: textAlign,
              maxLines: maxLines,
              overflow: overflow,
            ),
          ),
          6.horizontalSpace,
          Icon(
            Icons.copy_rounded,
            size: 16.sp,
            color: iconColor ?? const Color(0xFF5A6274),
          ),
        ],
      ),
    );
  }
}

Widget copyIconButton({
  required String copyText,
  String? feedbackMessage,
  Color? iconColor,
  double? iconSize,
}) {
  final value = copyText.trim();
  return IconButton(
    onPressed: value.isEmpty
        ? null
        : () => copyToClipboard(
              value,
              successMessage: feedbackMessage ?? 'Copied to clipboard',
            ),
    icon: Icon(
      Icons.copy_rounded,
      size: iconSize ?? 20,
      color: iconColor ?? const Color(0xFF5A6274),
    ),
    visualDensity: VisualDensity.compact,
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    tooltip: 'Copy',
  );
}
