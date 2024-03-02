import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/shared/constant/payment_method.dart';
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

List<ProductDetail> sortProductsHelper({
  double startingPrice = 0,
  double endingPrice = 0,
  required List<ProductDetail> products,
  ProductFilterType? filterType,
}) {
  final startingPriceInPaisa = startingPrice * 100;
  final endingPriceInPaisa = endingPrice * 100;
  List<ProductDetail> list = [];
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
    Iterable<ProductDetail> iterable = list.reversed;
    list = iterable.toList();
  }
  return list;
}

String formatNepaliCurrency(int amount) {
  final formatCurrency =
      NumberFormat.currency(locale: 'en_NP', symbol: '', decimalDigits: 0);
  final amountInRupees = amount ~/ 100;
  return formatCurrency.format(amountInRupees);
}

int hoursToDays(double hours) {
  const double hoursInDay = 24.0;

  int days = (hours / hoursInDay).round();

  return days;
}

String hoursToDaysString(double hours) {
  final days = hoursToDays(hours);
  String daysInString = '$days day';
  if (days > 1) {
    daysInString += 's';
  }
  return daysInString;
}

String formatDate(
  DateTime date, {
  String format = DateFormatConstant.defaultFormat,
  bool convertToLocalTime = true,
}) {
  if (convertToLocalTime) {
    date = date.toLocal();
  }
  String formattedDate = DateFormat(format).format(date);
  return formattedDate;
}

String getFullName({String? firstName, String? middleName, String? lastName}) {
  List<String> nameParts = [];

  if (firstName != null) {
    nameParts.add(firstName.trim());
  }

  if (middleName != null) {
    nameParts.add(middleName.trim());
  }

  if (lastName != null) {
    nameParts.add(lastName.trim());
  }

  return nameParts.join(' ');
}

Color getOrderStatusColor(String code) {
  switch (code) {
    case 'PENDING':
      return AppColors.warning;
    case 'PROCESSING':
      return AppColors.info;
    case 'OUT_FOR_DELIVERY':
      return AppColors.success;
    case 'DELIVERED':
      return AppColors.black;
    case 'CANCELLED':
      return AppColors.error;
    default:
      return AppColors.grayMain;
  }
}

String getPaymentMethodIcon(String code) {
  switch (code) {
    case PaymentMethod.CASH:
      return ImageConstants.IC_PAYMENT_CASH;
    case PaymentMethod.KHALTI:
      return ImageConstants.IC_PAYMENT_KHALTI;
    case PaymentMethod.ESEWA:
      return ImageConstants.IC_PAYMENT_ESEWA;
    case PaymentMethod.IME_PAY:
      return ImageConstants.IC_PAYMENT_IME;
    default:
      return '';
  }
}

String extractProductDefaultImage(
    List<String> defaultImages, List<ProductVariant> variantImages) {
  String imageUrl;
  try {
    imageUrl = variantImages
            .firstWhere((element) => element.image != null)
            .image
            ?.url ??
        "";
  } catch (err) {
    imageUrl = "";
  }
  return defaultImages.firstOrNull ?? imageUrl;
}

String extractProductVariantImage(
    List<String> defaultImages, ProductVariant variantImage) {
  return variantImage.image?.url ?? defaultImages.firstOrNull ?? "";
}

List<String> getDetailImages(ProductDetail product) {
  final List<String> images = [...product.images];

  Map<String, String> imageByColor = {};

  product.variants.forEach((variant) {
    imageByColor[variant.color.id] = variant.image?.url ?? "";
  });

  images.addAll(imageByColor.values);

  return images;
}
