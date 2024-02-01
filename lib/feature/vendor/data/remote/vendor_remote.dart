import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/vendor/data/model/update_favourite_vendor_request.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flamingo/feature/vendor/data/model/vendor_like_response.dart';

abstract class VendorRemote {
  Future<FetchResponse<Vendor>> getVendors();
  Future<VendorLikeResponse> getVendorLikes(String vendorId);
  Future<FetchResponse<Vendor>> getFavouriteVendors();
  Future updateFavouriteVendor(UpdateFavouriteVendorRequest request);
}
