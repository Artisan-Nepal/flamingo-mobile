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
    case 'READY_FOR_DELIVERY':
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

// The carousel shows the per-colour images the vendor actually manages
// (primary + optional secondary, one set per colour). Product-level
// `product.images` are intentionally NOT included: the seeder duplicates each
// product's single image into BOTH a product-level ProductImage and the
// colour's primary image (see seed-products.ts), and there is no vendor UI to
// manage product-level images - so including them just showed a duplicate that
// the vendor side never displayed. Only fall back to product.images if the
// variants somehow carry no images at all, so the carousel is never empty.
List<String> getDetailImages(ProductDetail product) {
  final List<String> images = [];

  final seenColorIds = <String>{};
  for (final variant in product.variants) {
    if (!seenColorIds.add(variant.color.id)) continue;
    final primaryUrl = variant.image?.url;
    if (primaryUrl != null && primaryUrl.isNotEmpty) {
      images.add(primaryUrl);
    }
    final secondaryUrl = variant.secondaryImage?.url;
    if (secondaryUrl != null && secondaryUrl.isNotEmpty) {
      images.add(secondaryUrl);
    }
  }

  if (images.isEmpty) images.addAll(product.images);

  return images;
}

// The page index (within getDetailImages(product)) of the given color's
// first/primary image - lets the color picker jump the image carousel to the
// right page. Colors can carry a different number of images (primary only,
// or primary+secondary), so this walks the same construction order as
// getDetailImages rather than assuming a fixed number of images per color.
int getColorImagePageIndex(ProductDetail product, String colorId) {
  int index = 0;
  final seenColorIds = <String>{};
  for (final variant in product.variants) {
    if (!seenColorIds.add(variant.color.id)) continue;
    if (variant.color.id == colorId) return index;
    final primaryUrl = variant.image?.url;
    if (primaryUrl != null && primaryUrl.isNotEmpty) {
      index += 1;
    }
    final secondaryUrl = variant.secondaryImage?.url;
    if (secondaryUrl != null && secondaryUrl.isNotEmpty) {
      index += 1;
    }
  }
  return index;
}
