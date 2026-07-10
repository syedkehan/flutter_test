import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Simple, theme-aware custom button widget
abstract class AppButton {
  /// Creates a theme-aware icon button with optional style overrides.
  static Widget getIconButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    Widget? icon,
    String? iconAsset,
    double? iconWidth,
    double? iconHeight,
    ColorFilter? iconColorFilter,
    Color? backgroundColor,
    MaterialTapTargetSize? tapTargetSize,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? fixedSize,
    OutlinedBorder? shape,
    AlignmentGeometry? alignment,
    ButtonStyle? customStyle,
    BoxConstraints? constraints,
    double? splashRadius,
    String? tooltip,
    String? semanticLabel,
  }) {
    assert(
      icon != null || iconAsset != null,
      'Either icon or iconAsset must be provided',
    );

    final baseStyle = Theme.of(context).iconButtonTheme.style?.copyWith(
      backgroundColor: backgroundColor != null
          ? WidgetStateProperty.all(backgroundColor)
          : null,
      tapTargetSize: tapTargetSize,
      padding: padding != null ? WidgetStateProperty.all(padding) : null,
      minimumSize: minimumSize != null
          ? WidgetStateProperty.all(minimumSize)
          : null,
      fixedSize: fixedSize != null ? WidgetStateProperty.all(fixedSize) : null,
      shape: shape != null ? WidgetStateProperty.all(shape) : null,
      alignment: alignment,
    );

    final style = customStyle != null
        ? (baseStyle?.merge(customStyle) ?? customStyle)
        : baseStyle;

    final iconWidget =
        icon ??
        SvgPicture.asset(
          iconAsset!,
          width: (iconWidth ?? 24).w,
          height: (iconHeight ?? 24).h,
          colorFilter: iconColorFilter,
        );

    return IconButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      icon: iconWidget,
      style: style,
      constraints: constraints,
      splashRadius: splashRadius,
      tooltip: tooltip,
    );
  }

  static Widget getButton({
    required BuildContext context,
    String? text,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    // Dimensions
    double? width,
    double? height,
    // Styling overrides
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    // Typography
    TextStyle? textStyle,
    // State
    bool loading = false,
    bool disabled = false,
    // Content
    Widget? child,
    Widget? icon,
    // Loading customization
    Color? loadingColor,
    double? loadingSize,
    // Accessibility
    String? tooltip,
    String? semanticLabel,
  }) {
    assert(
      text != null || child != null,
      'Either text or child must be provided',
    );

    final isDisabled = disabled || onPressed == null;
    final theme = Theme.of(context);
    final buttonStyle = theme.elevatedButtonTheme.style;
    final effectiveForegroundColor =
        foregroundColor ??
        buttonStyle?.foregroundColor?.resolve({}) ??
        theme.colorScheme.onPrimary;

    Widget button = SizedBox(
      width: width?.w ?? double.infinity,
      height: height?.h,
      child: IgnorePointer(
        ignoring: loading,
        child: ElevatedButton(
          style: buttonStyle?.copyWith(
            backgroundColor: backgroundColor != null
                ? WidgetStateProperty.resolveWith((_) => backgroundColor)
                : null,
            foregroundColor: foregroundColor != null
                ? WidgetStateProperty.resolveWith((_) => foregroundColor)
                : null,
            elevation: elevation != null
                ? WidgetStateProperty.all(elevation)
                : null,
          ),
          onPressed: isDisabled ? null : onPressed,
          onLongPress: isDisabled ? null : onLongPress,
          child: _buildButtonContent(
            context: context,
            loading: loading,
            text: text,
            child: child,
            icon: icon,
            textStyle: textStyle ?? buttonStyle?.textStyle?.resolve({}),
            foregroundColor: effectiveForegroundColor,
            loadingColor: _resolveLoadingColor(
              context,
              loadingColor: loadingColor,
              backgroundColor: backgroundColor,
            ),
            loadingSize: loadingSize,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip, child: button);
    }

    if (semanticLabel != null) {
      button = Semantics(label: semanticLabel, child: button);
    }

    return button;
  }

  /// Creates an outlined button with loading state support
  static Widget getOutlinedButton({
    required BuildContext context,
    String? text,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    // Dimensions
    double? width,
    double? height,
    // Styling overrides
    Color? foregroundColor,
    Color? borderColor,
    double? borderWidth,
    // Typography
    TextStyle? textStyle,
    // State
    bool loading = false,
    bool disabled = false,
    // Content
    Widget? child,
    Widget? icon,
    // Loading customization
    Color? loadingColor,
    double? loadingSize,
    // Accessibility
    String? tooltip,
    String? semanticLabel,
  }) {
    assert(
      text != null || child != null,
      'Either text or child must be provided',
    );

    final isDisabled = disabled || onPressed == null;
    final theme = Theme.of(context);
    final buttonStyle = theme.outlinedButtonTheme.style;
    final effectiveForegroundColor =
        foregroundColor ??
        buttonStyle?.foregroundColor?.resolve({}) ??
        theme.colorScheme.primary;

    Widget button = SizedBox(
      width: width?.w ?? double.infinity,
      height: height?.h,
      child: IgnorePointer(
        ignoring: loading,
        child: OutlinedButton(
          style: buttonStyle?.copyWith(
            foregroundColor: foregroundColor != null
                ? WidgetStateProperty.resolveWith((_) => foregroundColor)
                : null,
            side: borderColor != null || borderWidth != null
                ? WidgetStateProperty.all(
                    BorderSide(
                      color: borderColor ?? theme.colorScheme.primary,
                      width: borderWidth ?? 1.0,
                    ),
                  )
                : null,
          ),
          onPressed: isDisabled ? null : onPressed,
          onLongPress: isDisabled ? null : onLongPress,
          child: _buildButtonContent(
            context: context,
            loading: loading,
            text: text,
            child: child,
            icon: icon,
            textStyle: textStyle ?? buttonStyle?.textStyle?.resolve({}),
            foregroundColor: effectiveForegroundColor,
            loadingColor: _resolveLoadingColor(
              context,
              loadingColor: loadingColor,
            ),
            loadingSize: loadingSize,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip, child: button);
    }

    if (semanticLabel != null) {
      button = Semantics(label: semanticLabel, child: button);
    }

    return button;
  }

  static Widget getTextButton({
    required BuildContext context,
    String? text,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    // Dimensions
    double? width,
    double? height,
    // Styling overrides
    Color? foregroundColor,
    // Typography
    TextStyle? textStyle,
    // State
    bool loading = false,
    bool disabled = false,
    // Content
    Widget? child,
    Widget? icon,
    // Loading customization
    Color? loadingColor,
    double? loadingSize,
    // Accessibility
    String? tooltip,
    String? semanticLabel,
  }) {
    assert(
      text != null || child != null,
      'Either text or child must be provided',
    );

    final isDisabled = disabled || onPressed == null;
    final theme = Theme.of(context);
    final buttonStyle = theme.textButtonTheme.style;
    final effectiveForegroundColor =
        foregroundColor ??
        buttonStyle?.foregroundColor?.resolve({}) ??
        theme.colorScheme.primary;

    Widget button = SizedBox(
      width: width?.w,
      height: height?.h,
      child: IgnorePointer(
        ignoring: loading,
        child: TextButton(
          style: buttonStyle?.copyWith(
            foregroundColor: foregroundColor != null
                ? WidgetStateProperty.resolveWith((_) => foregroundColor)
                : null,
          ),
          onPressed: isDisabled ? null : onPressed,
          onLongPress: isDisabled ? null : onLongPress,
          child: _buildButtonContent(
            context: context,
            loading: loading,
            text: text,
            child: child,
            icon: icon,
            textStyle: textStyle ?? buttonStyle?.textStyle?.resolve({}),
            foregroundColor: effectiveForegroundColor,
            loadingColor: _resolveLoadingColor(
              context,
              loadingColor: loadingColor,
            ),
            loadingSize: loadingSize,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip, child: button);
    }

    if (semanticLabel != null) {
      button = Semantics(label: semanticLabel, child: button);
    }

    return button;
  }

  static Color _resolveLoadingColor(
    BuildContext context, {
    Color? loadingColor,
    Color? backgroundColor,
  }) {
    if (loadingColor != null) return loadingColor;

    final scheme = Theme.of(context).colorScheme;
    if (backgroundColor != null && backgroundColor.computeLuminance() > 0.5) {
      return scheme.primary;
    }
    return scheme.onPrimary;
  }

  /// Builds the content of the button (text, icon, loading indicator)
  static Widget _buildButtonContent({
    required BuildContext context,
    required bool loading,
    String? text,
    Widget? child,
    Widget? icon,
    TextStyle? textStyle,
    Color? foregroundColor,
    Color? loadingColor,
    double? loadingSize,
  }) {
    if (loading) {
      return SizedBox(
        width: (loadingSize ?? 20.0).w,
        height: (loadingSize ?? 20.0).h,
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation(
            loadingColor ?? Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }

    if (child != null) return child;

    final List<Widget> children = [];

    if (icon != null) {
      children.add(icon);
      if (text != null) {
        children.add(SizedBox(width: 18.w));
      }
    }

    if (text != null) {
      children.add(
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: (textStyle ?? const TextStyle()).copyWith(
            color: foregroundColor,
          ),
        ),
      );
    }

    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return children.length == 1
        ? children.first
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          );
  }
}
