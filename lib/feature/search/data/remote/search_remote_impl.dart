import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/search/data/remote/search_remote.dart';

class SearchRemoteImpl implements SearchRemote {
  // ignore: unused_field
  final ApiClient _apiClient;

  SearchRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;
}
