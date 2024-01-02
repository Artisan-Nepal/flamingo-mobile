import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/search/data/local/search_local.dart';

class SearchLocalImpl implements SearchLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  SearchLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;

  @override
  Future<void> clearSearchHistory() async {
    await _sharedPrefManager.remove(LocalStorageKeys.searchedTextHistory);
  }

  @override
  Future<List<String>> getSearchedText() async {
    return (await _sharedPrefManager
            .getStringList(LocalStorageKeys.searchedTextHistory)) ??
        [];
  }

  @override
  Future<void> saveSearchedText(List<String> texts) async {
    await _sharedPrefManager.setStringList(
        LocalStorageKeys.searchedTextHistory, texts);
  }
}
