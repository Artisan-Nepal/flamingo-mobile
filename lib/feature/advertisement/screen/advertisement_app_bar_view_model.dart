import 'package:flutter/cupertino.dart';

class AdvertisementAppBarViewModel extends ChangeNotifier {
  double _scrollOffset = 0.0;
  int _selectedTabIndex = 0;

  double get productDetailsOffset => _scrollOffset;
  int get selectedTabIndex => _selectedTabIndex;

  init() {
    _scrollOffset = 0.0;
    _selectedTabIndex = 0;
  }

  setSelectedTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  setScrollOffset(double offset) {
    _scrollOffset = offset;
    notifyListeners();
  }
}
