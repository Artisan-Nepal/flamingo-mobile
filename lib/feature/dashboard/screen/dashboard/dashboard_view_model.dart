import 'package:flutter/cupertino.dart';

class DashboardViewModel extends ChangeNotifier {
  int _pageIndex = 0;
  late PageController pageController;

  int get pageIndex => _pageIndex;

  /// Invoked when the HOME tab is tapped while already on HOME, so the home
  /// screen can scroll itself back to the top. Registered by HomeScreen.
  VoidCallback? onHomeReselected;

  int get homePageIndex => 0;

  init(int initialPageIndex) {
    _pageIndex = initialPageIndex;
    pageController = PageController(initialPage: initialPageIndex);
  }

  setPageIndex(int value, {bool notify = true}) {
    // Re-tapping the HOME tab while already on it scrolls home to the top
    // instead of being a no-op.
    if (value == homePageIndex && _pageIndex == homePageIndex) {
      onHomeReselected?.call();
      return;
    }
    _pageIndex = value;
    pageController.jumpToPage(_pageIndex);
    if (notify) {
      notifyListeners();
    }
  }
}
