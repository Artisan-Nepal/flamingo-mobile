import 'package:flutter/material.dart';

class LoadMoreViewModel extends ChangeNotifier {
  bool _isLoading = false;
  late int _page;
  late int _limit;

  bool get isLoading => _isLoading;
  int get page => _page;
  int get limit => _limit;

  init(int page, int limit) {
    _page = page;
    _limit = limit;
  }

  increasePage() {
    _page++;
  }

  setLoader(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
