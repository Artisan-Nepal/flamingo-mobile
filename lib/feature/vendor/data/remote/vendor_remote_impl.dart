import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flamingo/feature/vendor/data/remote/vendor_remote.dart';

class VendorRemoteImpl implements VendorRemote {
  final ApiClient _apiClient;

  VendorRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<FetchResponse<Vendor>> getVendors() async {
    final apiResponse = await _apiClient.get(ApiUrls.vendors);
    return FetchResponse.fromJson(
      apiResponse.data,
      Vendor.fromJsonList,
    );
  }
}
