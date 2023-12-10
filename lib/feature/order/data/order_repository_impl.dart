// ignore_for_file: unused_field
import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/order/data/local/order_local.dart';
import 'package:flamingo/feature/order/data/order_repository.dart';
import 'package:flamingo/feature/order/data/remote/order_remote.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocal _orderLocal;
  final OrderRemote _orderRemote;
  final AuthRepository _authRepository;

  OrderRepositoryImpl({
    required OrderLocal orderLocal,
    required OrderRemote orderRemote,
    required AuthRepository authRepository,
  })  : _orderLocal = orderLocal,
        _orderRemote = orderRemote,
        _authRepository = authRepository;
}
