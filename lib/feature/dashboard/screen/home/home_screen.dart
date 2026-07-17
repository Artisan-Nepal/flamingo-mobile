import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/advertisement/advertisement_listing_view_model.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/feature/dashboard/screen/dashboard/dashboard_view_model.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_advertisement.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_screen_story.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_products.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_search.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_promo_banners.dart';
import 'package:flamingo/feature/notification/notification_view_model.dart';
import 'package:flamingo/feature/promo-banner/promo_banner_view_model.dart';
import 'package:flamingo/feature/product-story/product_story_view_model.dart';
import 'package:flamingo/feature/product/data/model/for_you_section.dart';
import 'package:flamingo/feature/product/screen/product-listing/for_you_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/notification_glow_widget.dart';
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
  final _trendingProductListingViewModel = locator<ProductListingViewModel>();
  final _favVendorProductListingViewModel = locator<ProductListingViewModel>();
  final _forYouViewModel = locator<ForYouViewModel>();
  final _storyViewModel = locator<ProductStoryViewModel>();
  final _promoBannerViewModel = locator<PromoBannerViewModel>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getData();
    // Let re-tapping the HOME nav tab scroll this screen back to the top.
    Provider.of<DashboardViewModel>(context, listen: false).onHomeReselected =
        _scrollToTop;
  }

  @override
  void dispose() {
    final dashboardViewModel =
        Provider.of<DashboardViewModel>(context, listen: false);
    if (dashboardViewModel.onHomeReselected == _scrollToTop) {
      dashboardViewModel.onHomeReselected = null;
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  getData() async {
    _latestProductListingViewModel.getProducts(productType: ProductType.LATEST);
    _trendingProductListingViewModel.getProducts(
        productType: ProductType.TRENDING);

    _forYouViewModel.getForYou();
    _advertisementListingViewModel.getAdvertisements();
    _storyViewModel.getLikedVendorStories();
    _promoBannerViewModel.getBanners();

    if (Provider.of<AuthViewModel>(context, listen: false).isLoggedIn) {
      _favVendorProductListingViewModel.getProducts(
          productType: ProductType.FAVORITE_VENDOR);
      locator<CustomerActivityViewModel>().getCustomerCountInfo();
      locator<NotificationViewModel>().getNotifications();
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
          create: (context) => _forYouViewModel,
        ),
        ChangeNotifierProvider(
          create: (context) => _promoBannerViewModel,
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
                  controller: _scrollController,
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
                            child: SnippetHomeSearch(),
                          ),
                          const SnippetPromoBanners(),
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
                              height: Dimens.spacingSizeDefault),
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

                          // Trending now
                          ChangeNotifierProvider(
                            create: (context) =>
                                _trendingProductListingViewModel,
                            child: Consumer<ProductListingViewModel>(
                              builder: (context, viewModel, child) {
                                return SnippetHomeProducts(
                                  isLoading:
                                      viewModel.getProductsUseCase.isLoading,
                                  title: 'Trending now',
                                  productType: ProductType.TRENDING,
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

                    // For You — category-grouped horizontal rows built from the
                    // user's own activity (see ForYouViewModel).
                    SliverToBoxAdapter(
                      child: Consumer<ForYouViewModel>(
                        builder: (context, viewModel, child) {
                          final sections =
                              viewModel.getForYouUseCase.data ?? <ForYouSection>[];
                          if (!viewModel.getForYouUseCase.hasCompleted ||
                              sections.isEmpty) {
                            return const SizedBox();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: Dimens.spacingSizeSmall,
                                    bottom: Dimens.spacingSizeDefault),
                                child: Text(
                                  'FOR YOU',
                                  style:
                                      textTheme(context).bodyLarge!.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                ),
                              ),
                              for (final section in sections) ...[
                                SnippetHomeProducts(
                                  title: section.categoryName,
                                  productType: ProductType.CATEGORY,
                                  categoryId: section.categoryId,
                                  products: section.products,
                                ),
                                const VerticalSpaceWidget(
                                    height: Dimens.spacingSizeLarge),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
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
      title: Image.asset(
        ImageConstants.appIconWithName,
        height: SizeConfig.appBarHeight - 25,
      ),
      centerTitle: true,
      leadingWidth: 52,
      leading: const Padding(
        padding: EdgeInsets.only(left: Dimens.spacingSizeSmall),
        child: NotificationGlowWidget(),
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
