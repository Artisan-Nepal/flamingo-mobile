import 'package:flamingo/feature/dashboard/screen/dashboard/dashboard_view_model.dart';
import 'package:get_it/get_it.dart';

void registerDashboardFeature(GetIt locator) {
  locator.registerFactory<DashboardViewModel>(() => DashboardViewModel());
}
