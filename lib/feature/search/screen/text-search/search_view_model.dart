import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/customer-activity/create_activity_view_model.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/search/data/model/search_request.dart';
import 'package:flamingo/feature/search/data/search_repository.dart';
import 'package:flamingo/shared/constant/user_activity_type.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchRepository _searchRepository;

  SearchViewModel({required SearchRepository searchRepository})
      : _searchRepository = searchRepository;

  Response<List<ProductDetail>> _searchProductsUseCase = Response();
  Response<List<String>> _getSuggestionsUseCase = Response();
  List<ProductDetail> _recentlySearchedProducts = [];
  List<String> _searchTextHistory = [];

  Response<List<ProductDetail>> get searchProductsUseCase =>
      _searchProductsUseCase;
  Response<List<String>> get getSuggestionsUseCase => _getSuggestionsUseCase;
  List<ProductDetail> get recentlySearchedProducts => _recentlySearchedProducts;
  List<String> get searchTextHistory => _searchTextHistory;

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
    _searchRepository.clearSearchHistory();
    _searchProductsUseCase.data = [];
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
      _logSearchActivity(response.rows);
      if (isNewSearch) {
        setSearchProductsUseCase(Response.complete(response.rows));
      } else {
        appendSearchProductsUseCase(response.rows);
      }
    } catch (exception) {
      setSearchProductsUseCase(Response.error(exception));
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
        vendorId: product.vendor.id,
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
}
