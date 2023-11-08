import 'package:flamingo/feature/dashboard/screen/home/home/home_screen_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SnippetHomeNavBar extends StatelessWidget {
  const SnippetHomeNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomescreenviewModel>(
      builder: (context, mainScreenProvider, child) => Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          iconSize: 20,
          currentIndex: mainScreenProvider.pageIndex,
          onTap: (value) {
            mainScreenProvider.setPageIndex(value);
          },
          selectedIconTheme: const IconThemeData(color: AppColors.primaryMain),
          unselectedFontSize: Dimens.fontSizeExtraSmall,
          selectedFontSize: Dimens.fontSizeExtraSmall,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              label: 'SEARCH',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.tag),
              label: 'BRAND',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.heart),
              label: 'WISHLIST',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'ME',
            ),
          ],
        ),
      ),
    );
  }
}
