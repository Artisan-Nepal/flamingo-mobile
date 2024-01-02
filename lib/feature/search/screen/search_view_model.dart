import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/search/data/model/search_request.dart';
import 'package:flamingo/feature/search/data/search_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchRepository _searchRepository;

  SearchViewModel({required SearchRepository searchRepository})
      : _searchRepository = searchRepository;

  Response<List<Product>> _searchedProductsUseCase = Response();
  List<Product> _recentlySearchedProducts = [];
  List<String> _searchTextHistory = [];
  String _title = '';

  Response<List<Product>> get searchedProducts => _searchedProductsUseCase;
  List<Product> get recentlySearchedProducts => _recentlySearchedProducts;
  List<String> get searchTextHistory => _searchTextHistory;
  String get title => _title;

  void setSendOtpUseCase(Response<List<Product>> response) {
    _searchedProductsUseCase = response;
    notifyListeners();
  }

  void init() async {
    _searchTextHistory = await _searchRepository.getSearchedText();
    notifyListeners();
  }

  removeSearchedText(String text) {
    _searchTextHistory.removeWhere((element) => element == text);
    _searchRepository.saveSearchedText(_searchTextHistory);
    notifyListeners();
  }

  clearSearchHistory() {
    _searchRepository.clearSearchHistory();
    _searchedProductsUseCase.data = [];
  }

  searchProducts(String text, {bool isNewSearch = true}) async {
    try {
      if (isNewSearch) {
        _searchedProductsUseCase = Response.loading();
        _title = 'Search Result :';
        // _offset = 0;

        // save search text
        // first remove if already present
        removeSearchedText(text);
        _searchTextHistory.add(text);
        _searchRepository.saveSearchedText(_searchTextHistory);
        notifyListeners();
      }

      final response =
          await _searchRepository.searchProducts(SearchRequest(key: text));
      if (isNewSearch) {
        _searchedProductsUseCase.data?.clear();
      }
      _searchedProductsUseCase.data?.addAll(response.rows);

      notifyListeners();
    } catch (exception) {
      _searchedProductsUseCase = Response.error(exception);
    }
  }
}
