import 'package:flamingo/di/registration/data.dart';
import 'package:flamingo/di/registration/feature/user.dart';
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
}
