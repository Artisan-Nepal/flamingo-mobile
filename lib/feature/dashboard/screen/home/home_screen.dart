import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/advertisement/advertisement_listing_view_model.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/feature/dashboard/screen/dashboard/dashboard_view_model.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_advertisement.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_screen_story.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_products.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_search.dart';
import 'package:flamingo/feature/dashboard/screen/home/measurements_prompt_screen.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_measurements_banner.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_promo_banners.dart';
import 'package:flamingo/feature/fit-reference/data/fit_reference_repository.dart';
import 'package:flamingo/feature/fit-reference/data/model/fit_reference.dart';
import 'package:flamingo/feature/notification/notification_view_model.dart';
import 'package:flamingo/feature/promo-banner/promo_banner_view_model.dart';
import 'package:flamingo/feature/product-story/product_story_view_model.dart';
import 'package:flamingo/feature/product/data/model/for_you_section.dart';
import 'package:flamingo/feature/product/screen/product-listing/for_you_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_view_model.dart';
import 'package:flamingo/feature/user/data/user_repository.dart';
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

  // Whether to show the lightweight "save your measurements" banner. Decided
  // by _evaluateMeasurementsNudges once we know the customer is logged in,
  // has no saved measurements, and the banner hasn't expired yet.
  bool _showMeasurementsBanner = false;
  // AuthViewModel.isLoggedIn starts false and only flips (via notifyListeners)
  // once its constructor's fire-and-forget syncLocally() resolves - on a cold
  // `flutter run` that hasn't happened yet by the time this screen's first
  // frame renders. So this can't be a one-shot check: it re-tries off
  // AuthViewModel's own change notifications until it sees isLoggedIn true,
  // then stops for the rest of this screen's lifetime.
  bool _measurementsNudgeChecked = false;

  @override
  void initState() {
    super.initState();
    getData();
    // Let re-tapping the HOME nav tab scroll this screen back to the top.
    Provider.of<DashboardViewModel>(context, listen: false).onHomeReselected =
        _scrollToTop;
    Provider.of<AuthViewModel>(context, listen: false)
        .addListener(_maybeEvaluateMeasurementsNudges);
    // Runs after the first frame so the popup, if any, has a BuildContext
    // with the full widget tree (Navigator/Scaffold) already mounted. Also
    // covers the case where AuthViewModel had already resolved before this
    // screen mounted (e.g. switching back to the Home tab).
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _maybeEvaluateMeasurementsNudges());
  }

  void _maybeEvaluateMeasurementsNudges() {
    if (_measurementsNudgeChecked || !mounted) return;
    if (!Provider.of<AuthViewModel>(context, listen: false).isLoggedIn) {
      return;
    }
    _measurementsNudgeChecked = true;
    _evaluateMeasurementsNudges();
  }

  Future<void> _evaluateMeasurementsNudges() async {
    List<FitReference> references;
    try {
      references = await locator<FitReferenceRepository>().getFitReferences();
    } catch (_) {
      // Soft nudges - a failed lookup just means we stay quiet this time.
      return;
    }
    if (!mounted || references.isNotEmpty) return;

    final storage = locator<LocalStorageClient>(
      instanceName: ServiceNames.sharedPrefManager,
    );

    // Banner: visible for up to 14 days from the first time we show it to
    // this customer, then it stops appearing for good (per SIZE_AND_FIT
    // nudge plan - "can't leave it out forever").
    final firstShownRaw = await storage
        .getString(LocalStorageKeys.measurementsBannerFirstShownAt);
    DateTime firstShownAt;
    if (firstShownRaw == null) {
      firstShownAt = DateTime.now();
      await storage.setString(
        LocalStorageKeys.measurementsBannerFirstShownAt,
        firstShownAt.toIso8601String(),
      );
    } else {
      firstShownAt = DateTime.parse(firstShownRaw);
    }
    final bannerExpired =
        DateTime.now().difference(firstShownAt) > const Duration(days: 14);
    if (mounted && !bannerExpired) {
      setState(() => _showMeasurementsBanner = true);
    }

    // Popup: shown once ever, the first time we find a logged-in customer
    // with no saved measurements - never again after that, dismissed or not.
    // Tracked server-side (Customer.measurementPromptSeenAt) rather than in
    // local storage, so it stays dismissed across reinstalls/devices instead
    // of resetting with the app's local state.
    final alreadySeen = Provider.of<AuthViewModel>(context, listen: false)
            .user
            ?.measurementPromptSeenAt !=
        null;
    if (!alreadySeen && mounted) {
      _showMeasurementsPromptDialog();
      try {
        await locator<UserRepository>().markMeasurementPromptSeen();
      } catch (_) {
        // Best effort - if this fails we might show the popup again next
        // session, an acceptable outcome for a soft nudge.
      }
    }
  }

  void _showMeasurementsPromptDialog() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const MeasurementsPromptScreen(),
      ),
    );
  }

  @override
  void dispose() {
    final dashboardViewModel =
        Provider.of<DashboardViewModel>(context, listen: false);
    if (dashboardViewModel.onHomeReselected == _scrollToTop) {
      dashboardViewModel.onHomeReselected = null;
    }
    Provider.of<AuthViewModel>(context, listen: false)
        .removeListener(_maybeEvaluateMeasurementsNudges);
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
                          // A consistent gap sits the measurements strip below
                          // whatever precedes it (the search bar, or the promo
                          // banner when one is live) so it never glues to it.
                          if (_showMeasurementsBanner) ...[
                            const VerticalSpaceWidget(
                                height: Dimens.spacingSizeDefault),
                            const SnippetMeasurementsBanner(),
                          ],
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
                          // Story carries its own top spacing (see the widget)
                          // so an empty story row leaves no dead gap here.
                          if (authViewModel.isLoggedIn)
                            SnippetHomeScreenStory(),
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
