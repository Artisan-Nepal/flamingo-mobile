import 'package:flamingo/data/data.dart';
import 'package:flamingo/data/model/paginated_option.dart';
import 'package:flamingo/feature/vendor/data/model/update_favourite_vendor_request.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flamingo/feature/vendor/data/model/vendor_like_response.dart';

abstract class VendorRepository {
  Future<FetchResponse<Vendor>> getVendors(PaginationOption? paginationOption);
  Future<FetchResponse<Vendor>> getFavouriteVendors();
  Future<VendorLikeResponse> getVendorLikes(String vendorId);
  Future updateFavouriteVendor(UpdateFavouriteVendorRequest request);
  Future<Vendor> getVendorBySellerId(String sellerId);
}
