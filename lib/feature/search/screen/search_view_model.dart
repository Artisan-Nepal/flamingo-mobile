import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/search/data/model/search_request.dart';
import 'package:flamingo/feature/search/data/search_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchRepository _searchRepository;

  SearchViewModel({required SearchRepository searchRepository})
      : _searchRepository = searchRepository;

  Response<List<Product>> _searchProductsUseCase = Response();
  List<Product> _recentlySearchedProducts = [];
  List<String> _searchTextHistory = [];
  String _title = '';

  Response<List<Product>> get searchProductsUseCase => _searchProductsUseCase;
  List<Product> get recentlySearchedProducts => _recentlySearchedProducts;
  List<String> get searchTextHistory => _searchTextHistory;
  String get title => _title;

  void setSearchProductsUseCase(Response<List<Product>> response) {
    _searchProductsUseCase = response;
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
    _searchProductsUseCase.data = [];
  }

  searchProducts(String text, {bool isNewSearch = true}) async {
    try {
      if (isNewSearch) {
        _title = 'Search Result :';
        // _offset = 0;

        // save search text
        // first remove if already present
        removeSearchedText(text);
        _searchTextHistory.add(text);
        _searchRepository.saveSearchedText(_searchTextHistory);
        setSearchProductsUseCase(Response.loading());
      }

      final response =
          await _searchRepository.searchProducts(SearchRequest(key: text));
      if (isNewSearch) {
        _searchProductsUseCase.data?.clear();
      }
      _searchProductsUseCase.data?.addAll(response.rows);
      notifyListeners();
    } catch (exception) {
      setSearchProductsUseCase(Response.error(exception));
    }
  }
}
