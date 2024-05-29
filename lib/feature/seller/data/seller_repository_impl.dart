// ignore_for_file: unused_field
import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/seller/data/local/seller_local.dart';
import 'package:flamingo/feature/seller/data/model/register_seller_request.dart';
import 'package:flamingo/feature/seller/data/model/update_seller_request.dart';
import 'package:flamingo/feature/seller/data/remote/seller_remote.dart';
import 'package:flamingo/feature/seller/data/seller_repository.dart';
import 'package:flamingo/feature/vendor/data/model/seller.dart';

class SellerRepositoryImpl implements SellerRepository {
  final SellerLocal _sellerLocal;
  final SellerRemote _sellerRemote;
  final AuthRepository _authRepository;

  SellerRepositoryImpl({
    required SellerLocal sellerLocal,
    required SellerRemote sellerRemote,
    required AuthRepository authRepository,
  })  : _sellerLocal = sellerLocal,
        _sellerRemote = sellerRemote,
        _authRepository = authRepository;

  @override
  Future registerSeller(RegisterSellerRequest request) async {
    final customerId = (await _authRepository.getUserLocal())!.id;
    return await _sellerRemote.registerSeller(customerId, request);
  }

  @override
  Future<Seller> getSeller() async {
    final sellerId = (await _authRepository.getUserLocal())!.sellerId!;
    return await _sellerRemote.getSeller(sellerId);
  }

  @override
  Future<Seller> updateSeller(
      String sellerId, UpdateSellerRequest request) async {
    return await _sellerRemote.updateSeller(sellerId, request);
  }
}
