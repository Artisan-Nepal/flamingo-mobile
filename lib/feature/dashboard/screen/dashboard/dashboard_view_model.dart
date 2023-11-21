import 'package:flutter/cupertino.dart';

class DashboardViewModel extends ChangeNotifier {
  int _pageIndex = 0;
  late PageController pageController;

  int get pageIndex => _pageIndex;

  init(int initialPageIndex) {
    _pageIndex = initialPageIndex;
    pageController = PageController(initialPage: initialPageIndex);
  }

  setPageIndex(int value, {bool notify = true}) {
    _pageIndex = value;
    pageController.jumpToPage(_pageIndex);
    if (notify) {
      notifyListeners();
    }
  }
}
