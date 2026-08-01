import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/advertisement/advertisement_listing_view_model.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/feature/dashboard/screen/dashboard/dashboard_view_model.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_advertisement.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_brands.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_for_you.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_new_in.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_screen_story.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_trending.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_home_search.dart';
import 'package:flamingo/feature/dashboard/screen/home/measurements_prompt_screen.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_measurements_banner.dart';
import 'package:flamingo/feature/dashboard/screen/home/snippet_promo_banners.dart';
import 'package:flamingo/feature/fit-reference/data/fit_reference_repository.dart';
import 'package:flamingo/feature/fit-reference/data/model/fit_reference.dart';
import 'package:flamingo/feature/notification/notification_view_model.dart';
import 'package:flamingo/feature/promo-banner/promo_banner_view_model.dart';
import 'package:flamingo/feature/product-story/product_story_view_model.dart';
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
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
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
  // Guards against overlapping checks (e.g. the auth listener and a resume
  // event firing close together), not against repeat checks in general - the
  // popup itself is now allowed to reappear up to twice a day (see
  // _shownInCurrentHalfDayWindow).
  bool _measurementsNudgeCheckInFlight = false;
  DateTime? _lastMeasurementsNudgeCheckAt;

  @override
  void initState() {
    super.initState();
    getData();
    WidgetsBinding.instance.addObserver(this);
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // AuthViewModel.isLoggedIn starts false and only flips (via
    // notifyListeners) once its constructor's fire-and-forget syncLocally()
    // resolves - on a cold launch that hasn't happened yet by the time this
    // screen's first frame renders, which is why initState also listens for
    // that separately. Re-checking on resume is what actually makes the
    // twice-a-day popup work for a customer who keeps the app running in the
    // background across the AM/PM boundary instead of cold-launching again.
    if (state == AppLifecycleState.resumed) {
      _maybeEvaluateMeasurementsNudges();
    }
  }

  void _maybeEvaluateMeasurementsNudges() {
    if (!mounted || _measurementsNudgeCheckInFlight) return;
    if (!Provider.of<AuthViewModel>(context, listen: false).isLoggedIn) {
      return;
    }
    // Cheap rate-limit so rapid-fire lifecycle/auth events (e.g. resuming
    // twice in quick succession) don't each trigger their own network call -
    // this is not what enforces the twice-a-day popup cadence, the server
    // timestamp check inside _evaluateMeasurementsNudges is.
    final lastCheck = _lastMeasurementsNudgeCheckAt;
    if (lastCheck != null &&
        DateTime.now().difference(lastCheck) < const Duration(minutes: 1)) {
      return;
    }
    _lastMeasurementsNudgeCheckAt = DateTime.now();
    _evaluateMeasurementsNudges();
  }

  Future<void> _evaluateMeasurementsNudges() async {
    _measurementsNudgeCheckInFlight = true;
    try {
      await _doEvaluateMeasurementsNudges();
    } finally {
      _measurementsNudgeCheckInFlight = false;
    }
  }

  Future<void> _doEvaluateMeasurementsNudges() async {
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

    // Popup: shown up to twice a day - once in the 12am-12pm window and once
    // in the 12pm-12am window - until the customer actually saves a
    // measurement (references.isNotEmpty above stops it for good at that
    // point). Tracked server-side (Customer.measurementPromptSeenAt, which
    // now means "last shown at" rather than a one-time flag) rather than in
    // local storage, so the cadence stays correct across reinstalls/devices
    // instead of resetting with the app's local state.
    //
    // Fetched fresh here rather than read off AuthViewModel.user: that field
    // is also being raced by DashboardScreen's own independent syncRemotely()
    // call on every launch, and syncLocally()'s local-cache read (fast, but
    // possibly stale by up to a half-day window) resolves first - trusting
    // it caused this check to intermittently see yesterday's/this-morning's
    // cached timestamp instead of the true current one.
    DateTime? lastShownAt;
    try {
      lastShownAt =
          (await locator<UserRepository>().getCustomer()).measurementPromptSeenAt;
    } catch (_) {
      // Fall back to whatever AuthViewModel already has rather than skip the
      // check entirely - stale-but-present beats not checking at all.
      lastShownAt = Provider.of<AuthViewModel>(context, listen: false)
          .user
          ?.measurementPromptSeenAt;
    }
    if (!mounted) return;
    final alreadyShownThisWindow =
        lastShownAt != null && _sameHalfDayWindow(lastShownAt, DateTime.now());
    if (!alreadyShownThisWindow && mounted) {
      _showMeasurementsPromptDialog();
      try {
        await locator<UserRepository>().markMeasurementPromptSeen();
      } catch (_) {
        // Best effort - if this fails we might show the popup again sooner
        // than the cadence intends, an acceptable outcome for a soft nudge.
      }
    }
  }

  // Both instants compared in local time, since "12am-12pm" is about the
  // customer's own clock, not UTC. measurementPromptSeenAt comes back from
  // the API as UTC, so .toLocal() matters here.
  bool _sameHalfDayWindow(DateTime a, DateTime b) {
    final localA = a.toLocal();
    final localB = b.toLocal();
    final sameDay = localA.year == localB.year &&
        localA.month == localB.month &&
        localA.day == localB.day;
    return sameDay && (localA.hour < 12) == (localB.hour < 12);
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
    WidgetsBinding.instance.removeObserver(this);
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

                          // New in this week — compact rail (see
                          // SnippetHomeNewIn / HOME_SCREEN_OVERHAUL_PLAN.md
                          // module C). Same "Latest" fetch as before; smaller
                          // cards so a freshness signal doesn't cost half a
                          // screen.
                          ChangeNotifierProvider(
                            create: (context) => _latestProductListingViewModel,
                            child: Consumer<ProductListingViewModel>(
                              builder: (context, viewModel, child) {
                                return SnippetHomeNewIn(
                                  isLoading:
                                      viewModel.getProductsUseCase.isLoading,
                                  products:
                                      viewModel.getProductsUseCase.data?.rows ??
                                          [],
                                );
                              },
                            ),
                          ),
                          const VerticalSpaceWidget(
                              height: Dimens.spacingSizeLarge),

                          // Most wanted right now — ranked list (see
                          // SnippetHomeTrending / HOME_SCREEN_OVERHAUL_PLAN.md
                          // module B). Same view model and fetch as before;
                          // only the rendering changed from a generic rail to
                          // a legible, numbered ranking.
                          ChangeNotifierProvider(
                            create: (context) =>
                                _trendingProductListingViewModel,
                            child: Consumer<ProductListingViewModel>(
                              builder: (context, viewModel, child) {
                                return SnippetHomeTrending(
                                  isLoading:
                                      viewModel.getProductsUseCase.isLoading,
                                  products:
                                      viewModel.getProductsUseCase.data?.rows ??
                                          [],
                                );
                              },
                            ),
                          ),
                          const VerticalSpaceWidget(
                              height: Dimens.spacingSizeLarge),

                          // Brands you follow — a standalone entry-point card
                          // (see SnippetHomeBrands / HOME_SCREEN_OVERHAUL_PLAN.md
                          // module D) opening FollowedBrandsScreen. Same
                          // "favorite vendor" fetch as before, used only to
                          // decide whether the card is worth showing.
                          if (authViewModel.isLoggedIn) ...[
                            ChangeNotifierProvider(
                              create: (context) =>
                                  _favVendorProductListingViewModel,
                              child: Consumer<ProductListingViewModel>(
                                builder: (context, viewModel, child) {
                                  return SnippetHomeBrands(
                                    isLoading:
                                        viewModel.getProductsUseCase.isLoading,
                                    products: viewModel
                                            .getProductsUseCase.data?.rows ??
                                        [],
                                  );
                                },
                              ),
                            ),
                            const VerticalSpaceWidget(
                                height: Dimens.spacingSizeLarge),
                          ],
                        ],
                      ),
                    ),

                    // For You — one editorial pair from the user's top
                    // category (see SnippetHomeForYou / HOME_SCREEN_OVERHAUL_PLAN.md).
                    SliverToBoxAdapter(
                      child: SnippetHomeForYou(),
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
