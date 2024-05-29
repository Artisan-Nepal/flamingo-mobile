import 'package:flamingo/feature/seller/data/model/register_seller_request.dart';
import 'package:flamingo/feature/seller/data/model/update_seller_request.dart';
import 'package:flamingo/feature/vendor/data/model/seller.dart';

abstract class SellerRepository {
  Future<Seller> getSeller();
  Future registerSeller(RegisterSellerRequest request);
  Future<Seller> updateSeller(String sellerId, UpdateSellerRequest request);
}
