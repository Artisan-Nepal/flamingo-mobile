// ignore_for_file: unused_field
import 'package:flamingo/data/model/fetch_response.dart';
import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/search/data/local/search_local.dart';
import 'package:flamingo/feature/search/data/model/search_request.dart';
import 'package:flamingo/feature/search/data/remote/search_remote.dart';
import 'package:flamingo/feature/search/data/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchLocal _searchLocal;
  final SearchRemote _searchRemote;

  SearchRepositoryImpl({
    required SearchLocal searchLocal,
    required SearchRemote searchRemote,
    required AuthRepository authRepository,
  })  : _searchLocal = searchLocal,
        _searchRemote = searchRemote;

  @override
  Future<void> clearSearchHistory() async {
    return await _searchLocal.clearSearchHistory();
  }

  @override
  Future<List<String>> getSearchedText() async {
    return await _searchLocal.getSearchedText();
  }

  @override
  Future<void> saveSearchedText(List<String> texts) async {
    return await _searchLocal.saveSearchedText(texts);
  }

  @override
  Future<FetchResponse<Product>> searchProducts(SearchRequest request) async {
    return await _searchRemote.searchProducts(request);
  }

  @override
  Future<List<String>> getSearchSuggestions(SearchRequest request) async {
    return await _searchRemote.getSearchSuggestions(request);
  }
}
