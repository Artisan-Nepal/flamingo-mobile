import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/order/data/local/order_local.dart';

class OrderLocalImpl implements OrderLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  OrderLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
