import 'package:flamingo/data/data.dart';
import 'package:flamingo/data/model/paginated_option.dart';
import 'package:flamingo/feature/vendor/data/model/update_favourite_vendor_request.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flamingo/feature/vendor/data/model/vendor_like_response.dart';
import 'package:flamingo/feature/vendor/data/remote/vendor_remote.dart';

class VendorRemoteImpl implements VendorRemote {
  final ApiClient _apiClient;

  VendorRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<FetchResponse<Vendor>> getVendors(
      PaginationOption? paginationOption) async {
    final apiResponse = await _apiClient.get(
      ApiUrls.vendors,
      queryParams: paginationOption?.toJson(),
    );
    return FetchResponse.fromJson(
      apiResponse.data,
      Vendor.fromJsonList,
    );
  }

  @override
  Future updateFavouriteVendor(UpdateFavouriteVendorRequest request) async {
    await _apiClient.post(ApiUrls.updateFavouriteVendor,
        body: request.toJson());
  }

  @override
  Future<FetchResponse<Vendor>> getFavouriteVendors() async {
    final apiResponse = await _apiClient.get(ApiUrls.customerFavouriteVendor);
    return FetchResponse.fromJson(
      apiResponse.data,
      Vendor.fromFavouriteJsonList,
    );
  }

  @override
  Future<VendorLikeResponse> getVendorLikes(String vendorId) async {
    final url = ApiUrls.vendorLikes.replaceFirst(':id', vendorId);
    final apiResponse = await _apiClient.get(url);
    return VendorLikeResponse.fromJson(apiResponse.data);
  }

  @override
  Future<Vendor> getVendorBySellerId(String sellerId) async {
    final url = ApiUrls.vendorBySellerId.replaceFirst(':id', sellerId);
    final apiResponse = await _apiClient.get(url);
    return Vendor.fromJson(apiResponse.data);
  }
}
