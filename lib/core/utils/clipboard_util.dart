import 'package:flutter/services.dart';
import 'package:flutter_test_app/core/show/show/show.dart';
import 'package:flutter_test_app/injection_container.dart';

Future<void> copyToClipboard(
  String text, {
  String successMessage = 'Copied to clipboard',
}) async {
  final value = text.trim();
  if (value.isEmpty) return;

  await Clipboard.setData(ClipboardData(text: value));
  getIt<Show>().showSuccessSnackBar(successMessage);
}
