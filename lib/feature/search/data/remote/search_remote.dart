import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/search/data/model/search_request.dart';

abstract class SearchRemote {
  Future<FetchResponse<Product>> searchProducts(SearchRequest request);
  Future<List<String>> getSearchSuggestions(SearchRequest request);
}
