import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/search/data/local/search_local.dart';

class SearchLocalImpl implements SearchLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  SearchLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
