import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Assuming your extensions file has theme extension
// import 'package:flutter_test_app/core/utils/extensions.dart';

/// A comprehensive shimmer utility for consistent loading placeholders
class AppShimmer {
  // Private constructor to prevent instantiation
  AppShimmer._();

  /// Default shimmer duration (one highlight sweep).
  ///
  /// A slow, ~1.4s sweep reads as a gentle glint; anything much faster looks
  /// like a flicker.
  static const Duration _defaultDuration = Duration(milliseconds: 1400);

  /// Default shimmer direction
  static const ShimmerDirection _defaultDirection = ShimmerDirection.ltr;

  /// Resting tone of the placeholder, matched to the app's `0xffE8ECF4` boxes.
  static const Color _defaultBaseColor = Color(0xFFE2E8F0);

  /// The moving band — must be *lighter* than the base so the sweep reads as a
  /// highlight passing across, not a shadow.
  static const Color _defaultHighlightColor = Color(0xFFF6F8FC);

  /// Creates a shimmer effect wrapping [child] with customizable properties
  static Widget shimmer(
    BuildContext context, {
    Color? baseColor,
    Color? highlightColor,
    Duration duration = _defaultDuration,
    ShimmerDirection direction = _defaultDirection,
    required Widget child,
  }) => Shimmer.fromColors(
    period: duration,
    baseColor: baseColor ?? _defaultBaseColor,
    highlightColor: highlightColor ?? _defaultHighlightColor,
    direction: direction,
    child: child,
  );
}
