import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/seller/data/model/register_seller_request.dart';
import 'package:flamingo/feature/seller/data/model/update_seller_request.dart';
import 'package:flamingo/feature/seller/data/remote/seller_remote.dart';
import 'package:flamingo/feature/vendor/data/model/seller.dart';

class SellerRemoteImpl implements SellerRemote {
  // ignore: unused_field
  final ApiClient _apiClient;

  SellerRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Seller> getSeller(String sellerId) async {
    final url = '${ApiUrls.sellers}/$sellerId';
    final apiResponse = await _apiClient.get(url);
    return Seller.fromJson(apiResponse.data);
  }

  @override
  Future registerSeller(
      String customerId, RegisterSellerRequest request) async {
    final url = ApiUrls.registerSeller.replaceFirst(':id', customerId);
    return await _apiClient.post(url, body: request.toJson());
  }

  @override
  Future<Seller> updateSeller(
      String sellerId, UpdateSellerRequest request) async {
    final url = '${ApiUrls.sellers}/$sellerId';
    final apiResponse = await _apiClient.patch(url, body: request.toJson());
    return Seller.fromJson(apiResponse.data);
  }
}
