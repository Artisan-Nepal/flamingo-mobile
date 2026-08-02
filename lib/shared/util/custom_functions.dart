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
  // Support min-only, max-only, and both. A max is only meaningful when it's at
  // or above the min, otherwise the range is degenerate and we skip filtering.
  final hasMin = startingPrice > 0;
  final hasMax = endingPrice > 0 && endingPrice >= startingPrice;
  List<ProductDetail> list = [];
  if (hasMin || hasMax) {
    list.addAll(products.where((product) {
      if (product.variants.isEmpty) return false;
      final price = product.variants.first.price;
      if (hasMin && price < startingPriceInPaisa) return false;
      if (hasMax && price > endingPriceInPaisa) return false;
      return true;
    }));
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
  } else if (filterType.isNewest || filterType.isOldest) {
    // Products without a createdAt sort to the very bottom regardless of
    // direction, so they never jump to the top of a "Newest first" list.
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    list.sort((a, b) {
      final byDate = (a.createdAt ?? epoch).compareTo(b.createdAt ?? epoch);
      return filterType.isNewest ? -byDate : byDate;
    });
  }
  return list;
}

/// A sensible upper bound (in rupees) for a price-range slider, derived from the
/// most expensive product currently loaded and rounded up to a clean step so the
/// slider track ends on a round number. Falls back to a default when the list is
/// empty or has no prices yet.
double priceUpperBoundRupees(List<ProductDetail> products) {
  final maxPaisa = products
      .where((p) => p.variants.isNotEmpty)
      .map((p) => p.variants.first.price)
      .fold<int>(0, (a, b) => b > a ? b : a);
  if (maxPaisa <= 0) return 10000;
  final rupees = (maxPaisa / 100).ceil();
  final step = rupees <= 10000
      ? 500
      : rupees <= 50000
          ? 1000
          : 5000;
  return ((rupees / step).ceil() * step).toDouble();
}

/// Human-friendly countdown to an expiry instant, e.g. "3d 5h left",
/// "6h 20m left", "45m left". Used by the Coupons wallet.
String formatTimeLeft(DateTime until) {
  final diff = until.difference(DateTime.now());
  if (diff.isNegative) return 'Expired';
  final days = diff.inDays;
  final hours = diff.inHours % 24;
  final minutes = diff.inMinutes % 60;
  if (days >= 1) {
    return hours > 0 ? '${days}d ${hours}h left' : '${days}d left';
  }
  if (diff.inHours >= 1) {
    return minutes > 0 ? '${diff.inHours}h ${minutes}m left' : '${diff.inHours}h left';
  }
  if (diff.inMinutes >= 1) return '${diff.inMinutes}m left';
  return 'Expiring soon';
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
