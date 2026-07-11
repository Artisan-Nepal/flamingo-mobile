import 'dart:async';

import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/auth/screen/login/login_screen.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_screen.dart';
import 'package:flamingo/feature/promo-banner/data/model/promo_banner.dart';
import 'package:flamingo/feature/promo-banner/promo_banner_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// The dark promotional card on the home screen (below the search bar). Only
// one banner shows at a time even when several are active - it auto-advances
// every 5 seconds with a crossfade, and the customer can also swipe
// left/right to move between banners manually. Tapping the visible card
// either logs in (requiresLogin), saves a coupon to the wallet (hasCoupon),
// or opens the Sale listing (SALE link).
class SnippetPromoBanners extends StatelessWidget {
  const SnippetPromoBanners({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PromoBannerViewModel>(
      builder: (context, viewModel, child) {
        final banners = viewModel.getBannersUseCase.data ?? [];
        if (banners.isEmpty) return const SizedBox.shrink();
        return Column(
          children: [
            // Matches the gap below the banner (its own bottom padding plus
            // the story section's leading space) so the search-to-banner and
            // banner-to-story gaps read as consistent.
            const VerticalSpaceWidget(
              height: Dimens.spacingSizeSmall + Dimens.spacingSizeLarge,
            ),
            _PromoBannerCarousel(banners: banners, viewModel: viewModel),
          ],
        );
      },
    );
  }
}

class _PromoBannerCarousel extends StatefulWidget {
  const _PromoBannerCarousel({
    required this.banners,
    required this.viewModel,
  });

  final List<PromoBanner> banners;
  final PromoBannerViewModel viewModel;

  @override
  State<_PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<_PromoBannerCarousel> {
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scheduleAdvance();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _scheduleAdvance() {
    _timer?.cancel();
    if (widget.banners.length < 2) return;
    _timer = Timer(const Duration(seconds: 5), () => _goTo(_index + 1));
  }

  void _goTo(int nextIndex) {
    if (!mounted) return;
    final length = widget.banners.length;
    setState(() => _index = ((nextIndex % length) + length) % length);
    _scheduleAdvance();
  }

  @override
  Widget build(BuildContext context) {
    final index = _index >= widget.banners.length ? 0 : _index;
    final banner = widget.banners[index];
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity < 0) {
          _goTo(index + 1);
        } else if (velocity > 0) {
          _goTo(index - 1);
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _PromoBannerCard(
          key: ValueKey(banner.id),
          banner: banner,
          viewModel: widget.viewModel,
        ),
      ),
    );
  }
}

class _PromoBannerCard extends StatelessWidget {
  const _PromoBannerCard({
    super.key,
    required this.banner,
    required this.viewModel,
  });

  final PromoBanner banner;
  final PromoBannerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimens.spacingSizeSmall,
        right: Dimens.spacingSizeSmall,
        bottom: Dimens.spacingSizeSmall,
      ),
      child: GestureDetector(
        onTap: () => _onTap(context, viewModel, banner),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.spacingSizeDefault,
            vertical: Dimens.spacingSizeDefault,
          ),
          decoration: BoxDecoration(
            // Same black used for body text/headings elsewhere, so the card
            // reads as part of the app's palette rather than an arbitrary gray.
            color: AppColors.black,
            borderRadius: BorderRadius.circular(Dimens.radius_5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      banner.title,
                      style: textTheme(context).titleSmall!.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (banner.subtitle != null &&
                        banner.subtitle!.isNotEmpty) ...[
                      const VerticalSpaceWidget(height: Dimens.spacing_2),
                      Text(
                        banner.subtitle!,
                        style: textTheme(context).bodySmall!.copyWith(
                              color: AppColors.grayLight,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              if (banner.linksToSale || banner.requiresLogin)
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.white,
                  size: Dimens.iconSize_20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onTap(
    BuildContext context,
    PromoBannerViewModel viewModel,
    PromoBanner banner,
  ) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    if (banner.requiresLogin && !authViewModel.isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(needContinueAsGuest: false),
        ),
      );
      return;
    }

    // A coupon-carrying banner redeems (saves to wallet) on tap - primary
    // action even if it also links to Sale.
    if (banner.hasCoupon) {
      final ok = await viewModel.redeem(banner.couponId!);
      if (!context.mounted) return;
      showToast(
        context,
        message: ok
            ? 'Code ${banner.couponCode} saved — apply it at checkout.'
            : 'Could not save the code. Please try again.',
        isSuccess: ok,
      );
      return;
    }

    if (banner.linksToSale) {
      NavigationHelper.push(
        context,
        const ProductListingScreen(
          title: 'Sale',
          productType: ProductType.SALE,
        ),
      );
    }
  }
}
