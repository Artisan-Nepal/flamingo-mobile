import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/search/data/model/image_search_request.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/search/data/model/search_request.dart';

abstract class SearchRepository {
  Future<void> saveSearchedText(List<String> texts);
  Future<List<String>> getSearchedText();
  Future<void> clearSearchHistory();
  Future<FetchResponse<ProductDetail>> searchProducts(SearchRequest request);
  Future<List<String>> getSearchSuggestions(SearchRequest request);
  Future<List<Product>> imageSearch(ImageSearchRequest request);
}
