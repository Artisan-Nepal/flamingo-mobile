import 'package:flamingo/shared/shared.dart';

String? validateEmail(String? text) {
  if (text == null || text.isEmpty) {
    return 'Email is required.';
  } else if (!RexExpUtil.emailRegex.hasMatch(text)) {
    return 'Enter a valid email.';
  }
  return null;
}
