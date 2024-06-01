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
          selectedIconTheme:
              const IconThemeData(color: AppColors.secondaryMain),
          selectedLabelStyle: TextStyle(
            color: AppColors.secondaryMain,
          ),
          selectedItemColor: AppColors.secondaryMain,
          unselectedFontSize: Dimens.fontSizeExtraSmall,
          selectedFontSize: Dimens.fontSizeExtraSmall,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                ImageConstants.appIcon,
                height: 24,
                color: viewModel.pageIndex == 0
                    ? AppColors.secondaryMain
                    : AppColors.grayMain,
              ),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: viewModel.pageIndex == 1
                  ? Icon(CupertinoIcons.square_grid_2x2_fill)
                  : Icon(CupertinoIcons.square_grid_2x2),
              label: 'CATEGORY',
            ),
            BottomNavigationBarItem(
              icon: viewModel.pageIndex == 2
                  ? Icon(CupertinoIcons.tag_fill)
                  : Icon(CupertinoIcons.tag),
              label: 'BRAND',
            ),
            BottomNavigationBarItem(
              icon: viewModel.pageIndex == 3
                  ? Icon(CupertinoIcons.heart_fill)
                  : Icon(CupertinoIcons.heart),
              label: 'WISHLIST',
            ),
            BottomNavigationBarItem(
              icon: viewModel.pageIndex == 4
                  ? Icon(CupertinoIcons.person_fill)
                  : Icon(CupertinoIcons.person),
              label: 'ME',
            ),
          ],
        ),
      ),
    );
  }
}
