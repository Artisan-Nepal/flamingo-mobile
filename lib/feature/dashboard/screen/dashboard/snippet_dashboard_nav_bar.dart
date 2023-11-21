import 'package:flamingo/feature/dashboard/screen/dashboard/dashboard_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SnippetDashboardNavBar extends StatelessWidget {
  const SnippetDashboardNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) => Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          iconSize: 20,
          currentIndex: viewModel.pageIndex,
          onTap: (value) {
            viewModel.setPageIndex(value);
          },
          // selectedIconTheme: const IconThemeData(color:is),
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
