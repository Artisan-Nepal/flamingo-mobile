import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(num amount, {int decimalCount = 0}) {
  final formatCurrency =
      NumberFormat.simpleCurrency(decimalDigits: decimalCount);
  return formatCurrency.format(amount);
}

ThemeMode themeModeEnumFromString(String themeMode) {
  try {
    return ThemeMode.values.firstWhere(
        (e) => e.toString() == 'ThemeMode.${themeMode.toLowerCase()}');
  } catch (_) {
    return ThemeMode.system;
  }
}
