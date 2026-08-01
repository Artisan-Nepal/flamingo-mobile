import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/customer-activity/create_activity_view_model.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/search/data/model/search_request.dart';
import 'package:flamingo/feature/search/data/search_repository.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flamingo/feature/vendor/data/vendor_repository.dart';
import 'package:flamingo/shared/constant/user_activity_type.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

/// Curated placeholder for "trending" searches — there's no analytics
/// pipeline behind this yet, just a small set of popular category terms
/// shown to give first-time searchers somewhere to start.
const List<String> trendingSearchTerms = [
  'Sneakers',
  'Jeans',
  'Sarees',
  'Handbags',
  'T-Shirts',
  'Watches',
];

class SearchViewModel extends ChangeNotifier {
  final SearchRepository _searchRepository;
  final VendorRepository _vendorRepository;

  SearchViewModel({
    required SearchRepository searchRepository,
    required VendorRepository vendorRepository,
  })  : _searchRepository = searchRepository,
        _vendorRepository = vendorRepository;

  Response<List<ProductDetail>> _searchProductsUseCase = Response();
  Response<List<String>> _getSuggestionsUseCase = Response();
  Response<List<Vendor>> _vendorSuggestionsUseCase = Response();
  Response<List<Vendor>> _searchVendorsUseCase = Response();
  List<ProductDetail> _recentlySearchedProducts = [];
  List<String> _searchTextHistory = [];
  SearchScope _scope = SearchScope.product;

  Response<List<ProductDetail>> get searchProductsUseCase =>
      _searchProductsUseCase;
  Response<List<String>> get getSuggestionsUseCase => _getSuggestionsUseCase;
  Response<List<Vendor>> get vendorSuggestionsUseCase =>
      _vendorSuggestionsUseCase;
  Response<List<Vendor>> get searchVendorsUseCase => _searchVendorsUseCase;
  List<ProductDetail> get recentlySearchedProducts => _recentlySearchedProducts;
  List<String> get searchTextHistory => _searchTextHistory;
  SearchScope get scope => _scope;

  void setScope(SearchScope scope) {
    _scope = scope;
    notifyListeners();
  }

  void setSearchProductsUseCase(Response<List<ProductDetail>> response,
      {bool notify = true}) {
    _searchProductsUseCase = response;
    if (notify) notifyListeners();
  }

  void setSuggestionsUseCase(Response<List<String>> response,
      {bool notify = true}) {
    _getSuggestionsUseCase = response;
    if (notify) notifyListeners();
  }

  void setVendorSuggestionsUseCase(Response<List<Vendor>> response,
      {bool notify = true}) {
    _vendorSuggestionsUseCase = response;
    if (notify) notifyListeners();
  }

  void setSearchVendorsUseCase(Response<List<Vendor>> response,
      {bool notify = true}) {
    _searchVendorsUseCase = response;
    if (notify) notifyListeners();
  }

  void appendSearchProductsUseCase(List<ProductDetail> products) {
    if (_searchProductsUseCase.data != null) {
      _searchProductsUseCase.data!.addAll(products);
    } else {
      _searchProductsUseCase.data = [...products];
    }
    _searchProductsUseCase.state = ResponseState.complete;
    notifyListeners();
  }

  void init() async {
    setSearchProductsUseCase(Response(), notify: false);
    setSuggestionsUseCase(Response(), notify: false);
    setVendorSuggestionsUseCase(Response(), notify: false);
    setSearchVendorsUseCase(Response(), notify: false);
  }

  void getSearchHistory() async {
    _searchTextHistory = await _searchRepository.getSearchedText();
    notifyListeners();
  }

  removeSearchedText(String text, {bool notify = true}) {
    _searchTextHistory.removeWhere((element) => element == text);
    _searchRepository.saveSearchedText(_searchTextHistory);
    if (notify) notifyListeners();
  }

  clearSearchHistory() {
    // Clears the in-memory list too, not just the stored one - and notifies,
    // so the "Recent" section actually disappears. (Previously this emptied
    // _searchProductsUseCase.data, which holds search *results*, not history,
    // and never notified; nothing called it, so the bug was invisible.)
    _searchTextHistory = [];
    _searchRepository.clearSearchHistory();
    notifyListeners();
  }

  searchProducts(String text, {bool isNewSearch = true}) async {
    try {
      if (isNewSearch) {
        // _offset = 0;

        // save search text
        // first remove if already present
        removeSearchedText(text, notify: false);
        _searchTextHistory.add(text);
        _searchRepository.saveSearchedText(_searchTextHistory);
        setSearchProductsUseCase(Response.loading(), notify: false);
      }

      final response =
          await _searchRepository.searchProducts(SearchRequest(key: text));
      if (isNewSearch) {
        setSearchProductsUseCase(Response.complete(response.rows));
      } else {
        appendSearchProductsUseCase(response.rows);
      }
      _logSearchActivity(response.rows);
    } catch (exception) {
      setSearchProductsUseCase(Response.error(exception));
    }
  }

  searchVendors(String text) async {
    try {
      removeSearchedText(text, notify: false);
      _searchTextHistory.add(text);
      _searchRepository.saveSearchedText(_searchTextHistory);
      setSearchVendorsUseCase(Response.loading(), notify: false);

      final response = await _vendorRepository.searchVendors(text);
      setSearchVendorsUseCase(Response.complete(response.rows));
    } catch (exception) {
      setSearchVendorsUseCase(Response.error(exception));
    }
  }

  _logSearchActivity(List<ProductDetail> productList) async {
    List<ProductDetail> productsToLog = [];

    if (productList.length < 3) {
      productsToLog.addAll([...productList]);
    } else {
      productsToLog.addAll(productList.sublist(0, 3));
    }

    for (ProductDetail product in productsToLog) {
      await locator<CreateActivityViewModel>().createUserActivity(
        sellerId: product.seller.id,
        productId: product.id,
        activityType: UserActivityType.searchProduct,
      );
    }
  }

  getSuggestions(String text) async {
    if (text.isEmpty) {
      setSuggestionsUseCase(Response());
      return;
    }
    try {
      final response = await _searchRepository
          .getSearchSuggestions(SearchRequest(key: text));
      setSuggestionsUseCase(Response.complete(response));
    } catch (exception) {
      setSuggestionsUseCase(Response.error(exception));
    }
  }

  getVendorSuggestions(String text) async {
    if (text.isEmpty) {
      setVendorSuggestionsUseCase(Response());
      return;
    }
    try {
      final response = await _vendorRepository.searchVendors(text);
      setVendorSuggestionsUseCase(Response.complete(response.rows));
    } catch (exception) {
      setVendorSuggestionsUseCase(Response.error(exception));
    }
  }
}
