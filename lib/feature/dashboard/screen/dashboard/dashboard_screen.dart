import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/vendor/screen/vendor-listing/vendor_listing_screen.dart';
import 'package:flamingo/feature/category/screen/category-search/category_search_screen.dart';
import 'package:flamingo/feature/dashboard/screen/account/account_screen.dart';
import 'package:flamingo/feature/dashboard/screen/dashboard/dashboard_view_model.dart';
import 'package:flamingo/feature/dashboard/screen/dashboard/snippet_dashboard_nav_bar.dart';
import 'package:flamingo/feature/dashboard/screen/home/home_screen.dart';
import 'package:flamingo/feature/wishlist/screen/wishlist-listing/wishlist_listing_screen.dart';
import 'package:flamingo/shared/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _viewModel = locator<DashboardViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.init(0);
    Provider.of<AuthViewModel>(context, listen: false).syncRemotely();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.backgroundColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: ChangeNotifierProvider(
        create: (context) => _viewModel,
        builder: (context, child) => Scaffold(
          body: Consumer<DashboardViewModel>(
            builder: (context, viewModel, child) {
              return WillPopScope(
                onWillPop: () async {
                  bool quit = false;
                  if (viewModel.pageController.page != 0) {
                    // set to home screen
                    viewModel.setPageIndex(0);
                  } else {
                    quit = true;
                  }
                  return quit;
                },
                child: PageView(
                  controller: viewModel.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    HomeScreen(),
                    CategorySearchScreen(),
                    VendorListingScreen(),
                    WishlistListingScreen(),
                    AccountScreen(),
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: const SnippetDashboardNavBar(),
        ),
      ),
    );
  }
}
