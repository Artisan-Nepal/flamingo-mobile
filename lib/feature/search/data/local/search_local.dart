abstract class SearchLocal {
  Future<void> saveSearchedText(List<String> texts);
  Future<List<String>> getSearchedText();
  Future<void> clearSearchHistory();
}
