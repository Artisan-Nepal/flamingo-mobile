import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/advertisement/advertisement_listing_view_model.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_advertisement.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_screen_story.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_latest_products.dart';
import 'package:flamingo/feature/product-story/product_story_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_view_model.dart';
import 'package:flamingo/feature/search/screen/search_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/not-logged-in/not_logged_in_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _advertisementListingViewModel =
      locator<AdvertisementListingViewModel>();
  final _latestProductListingViewModel = locator<ProductListingViewModel>();
  final _storyViewModel = locator<ProductStoryViewModel>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    _latestProductListingViewModel.getLatestProducts();
    _advertisementListingViewModel.getAdvertisements();
    _storyViewModel.getLikedVendorStories();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final authViewModel = Provider.of<AuthViewModel>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _advertisementListingViewModel,
        ),
        ChangeNotifierProvider(
          create: (context) => _latestProductListingViewModel,
        ),
        ChangeNotifierProvider(
          create: (context) => _storyViewModel,
        ),
      ],
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              await getData();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.spacingSizeSmall),
                    child: SearchBarFieldWidget(
                      hintText: "Search for products",
                      readOnly: true,
                      onTap: () {
                        NavigationHelper.pushWithoutAnimation(
                          context,
                          const SearchScreen(
                            isInitial: true,
                          ),
                        );
                      },
                    ),
                  ),
                  if (!authViewModel.isLoggedIn)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.spacingSizeSmall,
                      ),
                      child: NotLoggedInWidget(
                          title: 'LET\'S GET PERSONAL',
                          message:
                              'Sign in for a tailored shopping experience'),
                    ),
                  if (authViewModel.isLoggedIn) ...[
                    const VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
                    SnippetHomeScreenStory(),
                  ],
                  const VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
                  SnippetHomeAdvertisement(),
                  SnippetLatestProducts(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text(
        'Flamingo',
        style: textTheme(context).headlineSmall!.copyWith(
              color: isLightMode(context)
                  ? themedPrimaryColor(context)
                  : AppColors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            top: Dimens.spacingSizeExtraSmall - 1,
            right: Dimens.spacingSizeSmall,
          ),
          child: const CartButtonWidget(),
        )
      ],
    );
  }
}
