import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/order/data/local/order_local.dart';
import 'package:flamingo/feature/order/data/local/order_local_impl.dart';
import 'package:flamingo/feature/order/data/order_repository.dart';
import 'package:flamingo/feature/order/data/order_repository_impl.dart';
import 'package:flamingo/feature/order/data/remote/order_remote.dart';
import 'package:flamingo/feature/order/data/remote/order_remote_impl.dart';
import 'package:flamingo/feature/order/screen/order-detail/order_status_view_model.dart';
import 'package:flamingo/feature/order/screen/order-listing/order_listing_view_model.dart';
import 'package:flamingo/feature/order/screen/place-order/checkout_method_view_model.dart';
import 'package:flamingo/feature/order/screen/place-order/place_order_view_model.dart';
import 'package:get_it/get_it.dart';

void registerOrderFeature(GetIt locator) {
  locator.registerLazySingleton<OrderLocal>(
    () => OrderLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<OrderRemote>(
    () => OrderRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
        orderLocal: locator<OrderLocal>(),
        orderRemote: locator<OrderRemote>(),
        authRepository: locator<AuthRepository>()),
  );
  locator.registerFactory<PlaceOrderViewModel>(
    () => PlaceOrderViewModel(orderRepository: locator<OrderRepository>()),
  );

  locator.registerFactory<CheckoutMethodViewModel>(
    () => CheckoutMethodViewModel(
      orderRepository: locator<OrderRepository>(),
    ),
  );
  locator.registerFactory<OrderListingViewModel>(
    () => OrderListingViewModel(
      orderRepository: locator<OrderRepository>(),
    ),
  );
  locator.registerFactory<OrderStatusViewModel>(
    () => OrderStatusViewModel(
      orderRepository: locator<OrderRepository>(),
    ),
  );
}
