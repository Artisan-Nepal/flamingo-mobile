import 'package:flamingo/data/data.dart';
import 'package:flamingo/data/model/paginated_option.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flamingo/feature/vendor/data/vendor_repository.dart';
import 'package:flamingo/feature/vendor/favourite_vendor_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

// One A-Z bucket in the brand directory: a section letter (A..Z, or '#' for
// names that don't start with a latin letter) and the brands filed under it.
class BrandSection {
  final String letter;
  final List<Vendor> vendors;

  const BrandSection({required this.letter, required this.vendors});
}

class VendorListingViewModel extends ChangeNotifier {
  final VendorRepository _vendorRepository;

  VendorListingViewModel({required VendorRepository vendorRepository})
      : _vendorRepository = vendorRepository;

  // The Brands screen loads the whole vendor set in one shot (small at this
  // stage) so search and the A-Z index can work over everything client-side,
  // rather than only the slice that happens to be paged in.
  static const int _fetchAllLimit = 1000;

  Response<FetchResponse<Vendor>> _vendorUseCase =
      Response<FetchResponse<Vendor>>();
  Response<FetchResponse<Vendor>> get vendorUseCase => _vendorUseCase;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  bool get isSearching => _searchQuery.trim().isNotEmpty;

  void setVendorUseCase(Response<FetchResponse<Vendor>> response) {
    _vendorUseCase = response;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> getVendors({bool updateState = true}) async {
    try {
      if (updateState) setVendorUseCase(Response.loading());
      final response = await _vendorRepository
          .getVendors(PaginationOption(page: 1, limit: _fetchAllLimit));
      locator<FavouriteVendorViewModel>()
          .initFavouriteVendorStatus(response.rows);
      setVendorUseCase(Response.complete(response));
    } catch (exception) {
      if (updateState) setVendorUseCase(Response.error(exception));
    }
  }

  List<Vendor> get _allVendors => _vendorUseCase.data?.rows ?? [];

  int _byName(Vendor a, Vendor b) => a.seller.storeName
      .toLowerCase()
      .compareTo(b.seller.storeName.toLowerCase());

  // The brands the customer follows, surfaced as a shortcut strip above the
  // full index. Uncapped - the strip scrolls horizontally.
  List<Vendor> get favoriteBrands {
    final fav = _allVendors
        .where((v) => locator<FavouriteVendorViewModel>().isFavourited(v.id))
        .toList()
      ..sort(_byName);
    return fav;
  }

  // Every brand (including followed ones) that matches the current search,
  // sorted A-Z. The index is meant to be complete, so favourites are not
  // subtracted here the way the old two-list layout did.
  List<Vendor> get _visibleVendors {
    final query = _searchQuery.trim().toLowerCase();
    final list = query.isEmpty
        ? _allVendors
        : _allVendors
            .where((v) => v.seller.storeName.toLowerCase().contains(query))
            .toList();
    return [...list]..sort(_byName);
  }

  static String _sectionLetterFor(String storeName) {
    final name = storeName.trim();
    if (name.isEmpty) return '#';
    final first = name[0].toUpperCase();
    return RegExp(r'[A-Z]').hasMatch(first) ? first : '#';
  }

  // The visible brands grouped into A-Z sections, '#' always sorted last.
  List<BrandSection> get sections {
    final map = <String, List<Vendor>>{};
    for (final vendor in _visibleVendors) {
      final letter = _sectionLetterFor(vendor.seller.storeName);
      map.putIfAbsent(letter, () => []).add(vendor);
    }
    final letters = map.keys.toList()
      ..sort((a, b) {
        if (a == '#') return 1;
        if (b == '#') return -1;
        return a.compareTo(b);
      });
    return [
      for (final letter in letters)
        BrandSection(letter: letter, vendors: map[letter]!)
    ];
  }
}
