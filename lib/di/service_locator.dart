import 'package:flamingo/di/registration/data.dart';
import 'package:flamingo/di/registration/feature/address.dart';
import 'package:flamingo/di/registration/feature/advertisement.dart';
import 'package:flamingo/di/registration/feature/cart.dart';
import 'package:flamingo/di/registration/feature/category.dart';
import 'package:flamingo/di/registration/feature/customer_activity.dart';
import 'package:flamingo/di/registration/feature/dashboard.dart';
import 'package:flamingo/di/registration/feature/order.dart';
import 'package:flamingo/di/registration/feature/product.dart';
import 'package:flamingo/di/registration/feature/product_story.dart';
import 'package:flamingo/di/registration/feature/search.dart';
import 'package:flamingo/di/registration/feature/seller.dart';
import 'package:flamingo/di/registration/feature/upload_file.dart';
import 'package:flamingo/di/registration/feature/user.dart';
import 'package:flamingo/di/registration/feature/vendor.dart';
import 'package:flamingo/di/registration/feature/wishlist.dart';
import 'package:flamingo/di/registration/registration.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future setUpServiceLocator() async {
  // data
  await registerDataModule(locator);

  // services
  registerServices(locator);

  // features
  registerAuthFeature(locator);
  registerUserFeature(locator);
  registerDashboardFeature(locator);
  registerCategoryFeature(locator);
  registerAddressFeature(locator);
  registerProductFeature(locator);
  registerUploadFileFeature(locator);
  registerCartFeature(locator);
  registerWishlistFeature(locator);
  registerOrderFeature(locator);
  registerCustomerActivityFeature(locator);
  registerVendorFeature(locator);
  registerSearchFeature(locator);
  registerAdvertisementFeature(locator);
  registerProductStoryFeature(locator);
  registerSellerFeature(locator);
}
