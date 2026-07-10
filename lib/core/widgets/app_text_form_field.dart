import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_app/config/theme/app_colors.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';
import 'package:flutter_test_app/core/widgets/app_button.dart';

/// Simple configuration class for AppTextFormField overrides
class AppTextFieldConfig {
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final EdgeInsets? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextInputAction? defaultTextInputAction;
  final double? borderRadius;

  const AppTextFieldConfig({
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.contentPadding,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.defaultTextInputAction,
  });
}

/// Enum for different text field variants
enum AppTextFieldType {
  standard,
  email,
  password,
  phone,
  number,
  multiline,
  search,
  url,
}

/// Main AppTextFormField widget with improved architecture
class AppTextFormField extends StatefulWidget {
  // Core properties
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final AppTextFieldType type;
  final AppTextFieldConfig? config;

  // Styling overrides
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? borderRadius;

  // Validation
  final String? Function(String?)? validator;
  final bool required;
  final String? requiredMessage;

  // Icons and actions
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final Widget? prefix;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final TextStyle? prefixStyle;

  // Behavior
  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  final FocusNode? focusNode;

  // Input constraints
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;

  // Styling overrides
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final EdgeInsets scrollPadding;

  const AppTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.hintTextStyle,
    this.type = AppTextFieldType.standard,
    this.config,
    this.validator,
    this.required = false,
    this.requiredMessage,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.prefix,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.prefixStyle,
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.focusNode,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.inputFormatters,
    this.autofillHints,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText =
        widget.obscureText || widget.type == AppTextFieldType.password;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      obscureText: _obscureText,
      obscuringCharacter: '•',
      textAlign: widget.textAlign,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction ?? _getTextInputAction(),
      keyboardType: _getKeyboardType(),
      inputFormatters: widget.inputFormatters ?? _getInputFormatters(),
      autofillHints: widget.autofillHints ?? _getAutofillHints(),
      scrollPadding: widget.scrollPadding,
      validator: _buildValidator(),
      maxLength: widget.maxLength,
      maxLines: _getMaxLines(),
      minLines: widget.minLines,
      onTap: widget.onTap,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      onEditingComplete: widget.onEditingComplete,
      style:
          widget.config?.textStyle ??
          theme.textTheme.bodyMedium?.copyWith(color: textColor) ??
          theme.textTheme.bodyLarge?.copyWith(color: textColor),
      decoration: _buildInputDecoration(context),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;

    // Get border from theme for overrides
    final baseBorder = inputTheme.border as OutlineInputBorder?;
    final enabledBorder = inputTheme.enabledBorder as OutlineInputBorder?;
    final focusedBorder = inputTheme.focusedBorder as OutlineInputBorder?;

    // Apply overrides if provided
    final Color? borderColor = widget.borderColor ?? widget.config?.borderColor;
    Color? focusedBorderColor =
        widget.focusedBorderColor ?? widget.config?.focusedBorderColor;
    focusedBorderColor ??= borderColor;
    Color? fillColor = widget.fillColor ?? widget.config?.fillColor;
    final double? borderRadius =
        widget.borderRadius ?? widget.config?.borderRadius;

    final Widget? prefixIcon;
    final BoxConstraints? prefixIconConstraints;
    final EdgeInsetsGeometry contentPadding;

    // When [prefixIconConstraints] is omitted, apply standard inset: 20.w to icon,
    // 16.w before hint/text, and avoid double left padding from [contentPadding].
    if (widget.prefixIcon != null && widget.prefixIconConstraints == null) {
      double leadingInset = 14.w;
      const double iconToTextGap = 16;
      final double minPrefixWidth = leadingInset.w + 16.w + iconToTextGap.w;

      prefixIcon = Padding(
        padding: EdgeInsetsDirectional.only(
          start: leadingInset.w,
          end: iconToTextGap.w,
        ),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: 1,
          heightFactor: 1,
          child: widget.prefixIcon,
        ),
      );
      prefixIconConstraints = BoxConstraints(
        minWidth: minPrefixWidth,
        minHeight: 48.h,
      );

      if (widget.config?.contentPadding != null) {
        contentPadding = widget.config!.contentPadding!;
      } else {
        final base = _edgeInsetsFromGeometry(inputTheme.contentPadding);
        contentPadding = EdgeInsetsDirectional.only(
          start: 0,
          end: base.end,
          top: base.top,
          bottom: base.bottom,
        );
      }
    } else {
      prefixIcon = widget.prefixIcon;
      prefixIconConstraints = widget.prefixIconConstraints;
      contentPadding =
          widget.config?.contentPadding ??
          inputTheme.contentPadding ??
          EdgeInsets.zero;
    }

    return InputDecoration(
      labelText: widget.labelText,
      hintText: widget.hintText,
      prefixIcon: prefixIcon,
      prefixIconConstraints: prefixIconConstraints,
      prefix: widget.prefix,
      suffixIcon: _buildSuffixIcon(),
      prefixText: widget.prefixText,
      suffixText: widget.suffixText,
      prefixStyle: widget.prefixStyle,
      isDense: inputTheme.isDense,
      filled: inputTheme.filled,
      fillColor: fillColor ?? inputTheme.fillColor,
      contentPadding: contentPadding,
      floatingLabelBehavior: inputTheme.floatingLabelBehavior,
      alignLabelWithHint: inputTheme.alignLabelWithHint,
      labelStyle: widget.config?.labelStyle ?? inputTheme.labelStyle,
      hintStyle:
          widget.hintTextStyle ??
          widget.config?.hintStyle ??
          inputTheme.hintStyle,
      errorStyle: inputTheme.errorStyle,
      border: _applyBorderRadius(
        borderRadius,
        borderColor != null
            ? _buildBorderWithColor(baseBorder, borderColor)
            : inputTheme.border,
      ),
      enabledBorder: _applyBorderRadius(
        borderRadius,
        borderColor != null
            ? _buildBorderWithColor(enabledBorder, borderColor)
            : inputTheme.enabledBorder,
      ),
      focusedBorder: _applyBorderRadius(
        borderRadius,
        focusedBorderColor != null
            ? _buildBorderWithColor(focusedBorder, focusedBorderColor)
            : inputTheme.focusedBorder,
      ),
      errorBorder: _applyBorderRadius(borderRadius, inputTheme.errorBorder),
      focusedErrorBorder: _applyBorderRadius(
        borderRadius,
        inputTheme.focusedErrorBorder,
      ),
      disabledBorder: _applyBorderRadius(
        borderRadius,
        inputTheme.disabledBorder,
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.type == AppTextFieldType.password) {
      return AppButton.getIconButton(
        context: context,
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      );
    }
    return widget.suffixIcon;
  }

  String? Function(String?)? _buildValidator() {
    if (widget.validator != null) return widget.validator;
    if (!widget.required) return null;

    return (value) {
      if (value == null || value.trim().isEmpty) {
        return widget.requiredMessage ?? 'This field is required';
      }

      // Type-specific validation
      switch (widget.type) {
        case AppTextFieldType.email:
          if (!_isValidEmail(value)) {
            return 'Please enter a valid email address';
          }
          break;
        case AppTextFieldType.phone:
          if (!_isValidPhone(value)) {
            return 'Please enter a valid phone number';
          }
          break;
        case AppTextFieldType.url:
          if (!_isValidUrl(value)) {
            return 'Please enter a valid URL';
          }
          break;
        default:
          break;
      }
      return null;
    };
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case AppTextFieldType.email:
        return TextInputType.emailAddress;
      case AppTextFieldType.phone:
        return TextInputType.phone;
      case AppTextFieldType.number:
        return TextInputType.number;
      case AppTextFieldType.multiline:
        return TextInputType.multiline;
      case AppTextFieldType.url:
        return TextInputType.url;
      default:
        return TextInputType.text;
    }
  }

  TextInputAction _getTextInputAction() {
    if (widget.type == AppTextFieldType.multiline) {
      return TextInputAction.newline;
    }
    return widget.config?.defaultTextInputAction ?? TextInputAction.next;
  }

  int? _getMaxLines() {
    if (widget.maxLines != null) return widget.maxLines;
    if (widget.type == AppTextFieldType.multiline) return null;
    return 1;
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.type) {
      case AppTextFieldType.phone:
        return [FilteringTextInputFormatter.digitsOnly];
      case AppTextFieldType.number:
        return [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))];
      default:
        return null;
    }
  }

  Iterable<String>? _getAutofillHints() {
    switch (widget.type) {
      case AppTextFieldType.email:
        return [AutofillHints.email];
      case AppTextFieldType.password:
        return [AutofillHints.password];
      case AppTextFieldType.phone:
        return [AutofillHints.telephoneNumber];
      case AppTextFieldType.url:
        return [AutofillHints.url];
      default:
        return null;
    }
  }

  // Validation helpers
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    return phone.isPhoneNumber;
  }

  bool _isValidUrl(String url) {
    return RegExp(
      r'^https?:\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$',
    ).hasMatch(url);
  }
}

InputBorder? _applyBorderRadius(double? radius, InputBorder? border) {
  if (radius == null || border == null) return border;
  final br = BorderRadius.circular(radius);
  if (border is OutlineInputBorder) {
    return border.copyWith(borderRadius: br);
  }
  return border;
}

EdgeInsetsDirectional _edgeInsetsFromGeometry(EdgeInsetsGeometry? geometry) {
  if (geometry == null) return EdgeInsetsDirectional.zero;
  final e = geometry.resolve(TextDirection.ltr);
  return EdgeInsetsDirectional.fromSTEB(e.left, e.top, e.right, e.bottom);
}

InputBorder _buildBorderWithColor(OutlineInputBorder? baseBorder, Color color) {
  final border = baseBorder ?? const OutlineInputBorder();
  final baseSide = border.borderSide;
  return border.copyWith(
    borderSide: BorderSide(
      color: color,
      width: baseSide.width == 0 ? 1 : baseSide.width,
      style: BorderStyle.solid,
    ),
  );
}
