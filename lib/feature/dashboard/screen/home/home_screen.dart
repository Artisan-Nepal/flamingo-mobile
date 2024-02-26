import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/advertisement/advertisement_listing_view_model.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_advertisement.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_screen_story.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_products.dart';
import 'package:flamingo/feature/product-story/product_story_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/min_product_listing_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_product_listing.dart';
import 'package:flamingo/feature/search/screen/text-search/search_screen.dart';
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
  final _favVendorProductListingViewModel = locator<ProductListingViewModel>();
  final _recommendedProductListingViewModel =
      locator<MinProductListingViewModel>();
  final _storyViewModel = locator<ProductStoryViewModel>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    _latestProductListingViewModel.getProducts(productType: ProductType.LATEST);

    _recommendedProductListingViewModel.getUserRecommendation();
    _advertisementListingViewModel.getAdvertisements();
    _storyViewModel.getLikedVendorStories();

    if (Provider.of<AuthViewModel>(context, listen: false).isLoggedIn) {
      _favVendorProductListingViewModel.getProducts(
          productType: ProductType.FAVORITE_VENDOR);
    }
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
          create: (context) => _storyViewModel,
        ),
        ChangeNotifierProvider(
          create: (context) => _recommendedProductListingViewModel,
        ),
      ],
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              await getData();
            },
            child: Builder(
              builder: (context) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const VerticalSpaceWidget(
                              height: Dimens.spacingSizeSmall),
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
                            const VerticalSpaceWidget(
                                height: Dimens.spacingSizeLarge),
                            SnippetHomeScreenStory(),
                          ],
                          const VerticalSpaceWidget(
                              height: Dimens.spacingSizeLarge),
                          SnippetHomeAdvertisement(),

                          // Latest products
                          ChangeNotifierProvider(
                            create: (context) => _latestProductListingViewModel,
                            child: Consumer<ProductListingViewModel>(
                              builder: (context, viewModel, child) {
                                return SnippetHomeProducts(
                                  isLoading:
                                      viewModel.getProductsUseCase.isLoading,
                                  title: 'Latest',
                                  productType: ProductType.LATEST,
                                  products:
                                      viewModel.getProductsUseCase.data?.rows ??
                                          [],
                                );
                              },
                            ),
                          ),
                          const VerticalSpaceWidget(
                              height: Dimens.spacingSizeLarge),

                          // Favorite vendor products
                          if (authViewModel.isLoggedIn) ...[
                            ChangeNotifierProvider(
                              create: (context) =>
                                  _favVendorProductListingViewModel,
                              child: Consumer<ProductListingViewModel>(
                                builder: (context, viewModel, child) {
                                  return SnippetHomeProducts(
                                    isLoading:
                                        viewModel.getProductsUseCase.isLoading,
                                    title: 'Favorite brands',
                                    productType: ProductType.FAVORITE_VENDOR,
                                    products: viewModel
                                            .getProductsUseCase.data?.rows ??
                                        [],
                                  );
                                },
                              ),
                            ),
                            const VerticalSpaceWidget(
                                height: Dimens.spacingSizeLarge),
                          ]
                        ],
                      ),
                    ),

                    // All Products
                    SliverToBoxAdapter(
                      child: Builder(builder: (context) {
                        final _viewModel =
                            Provider.of<MinProductListingViewModel>(context);
                        if (_viewModel.getProductsUseCase.hasCompleted &&
                            (_viewModel.getProductsUseCase.data ?? [])
                                .isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: Dimens.spacingSizeSmall,
                                bottom: Dimens.spacingSizeDefault),
                            child: Text(
                              'FOR YOU',
                              style: textTheme(context).bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          );
                        }

                        return SizedBox();
                      }),
                    ),
                    SnippetProductListing(
                        useSliver: true,
                        padding: 0,
                        products:
                            (Provider.of<MinProductListingViewModel>(context)
                                    .getProductsUseCase
                                    .data ??
                                [])),
                    SliverToBoxAdapter(
                      child: VerticalSpaceWidget(
                        height: Dimens.spacingSizeDefault,
                      ),
                    )
                  ],
                );
              },
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
              fontWeight: FontWeight.w500,
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
