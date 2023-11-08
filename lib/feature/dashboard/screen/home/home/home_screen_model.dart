import 'package:flutter/cupertino.dart';

class HomescreenviewModel extends ChangeNotifier {
  int _pageIndex = 0;
  late PageController pageController;

  int get pageIndex => _pageIndex;

  init(int initialPageIndex) {
    //for beginning to keep at 0 page
    _pageIndex = initialPageIndex;
    pageController = PageController(initialPage: initialPageIndex);
  }

  setPageIndex(int value, {bool notify = true}) {
    //change page
    _pageIndex = value;
    pageController.jumpToPage(_pageIndex);
    if (notify) {
      notifyListeners();
    }
  }
}
