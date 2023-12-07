import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

bool isLightMode(BuildContext context, {bool listen = true}) {
  return Provider.of<ThemeService>(context, listen: listen)
      .isLightMode(context);
}

TextTheme textTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}

Color themedPrimaryColor(BuildContext context) {
  return Theme.of(context).primaryColor;
}

Color themedLoaderBackground(BuildContext context) {
  return isLightMode(context)
      ? AppColors.black.withOpacity(0.4)
      : AppColors.grayLighter.withOpacity(0.3);
}

double getScaledValueForSmallerDevice(
    {required double value, double? scale, double? minScaleValue}) {
  bool isMediumScreen = SizeConfig.isMediumDevice;
  bool isSmallerScreen = SizeConfig.isSmallerDevice;
  return scale != null
      ? isMediumScreen
          ? value * scale
          : isSmallerScreen
              ? value * (minScaleValue ?? scale * 0.7)
              : value
      : value;
}

List<Product> sortProductsHelper({
  double startingPrice = 0,
  double endingPrice = 0,
  required List<Product> products,
  ProductFilterType? filterType,
}) {
  final startingPriceInPaisa = startingPrice * 100;
  final endingPriceInPaisa = endingPrice * 100;
  List<Product> list = [];
  if (startingPrice > 0 && endingPrice > startingPrice) {
    list.addAll(products
        .where((product) =>
            (product.variants[0].price) >= startingPriceInPaisa &&
            (product.variants[0].price) <= endingPriceInPaisa)
        .toList());
  } else {
    list.addAll(products);
  }

  if (filterType == null) return list;

  if (filterType.isPriceAsc) {
    list.sort((a, b) => a.variants[0].price.compareTo(b.variants[0].price));
  } else if (filterType.isPriceDesc) {
    list.sort((a, b) => a.variants[0].price.compareTo(b.variants[0].price));
    Iterable<Product> iterable = list.reversed;
    list = iterable.toList();
  }
  return list;
}

String formatNepaliCurrency(int amount) {
  final formatCurrency = NumberFormat.currency(locale: 'en_NP', symbol: '');
  final amountInRupees = amount / 100;
  return formatCurrency.format(amountInRupees);
}
