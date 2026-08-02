import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/coupon/screen/coupon-listing/coupon_listing_view_model.dart';
import 'package:flamingo/feature/order/data/model/saved_coupon.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/loader/default_screen_loader_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CouponListingScreen extends StatefulWidget {
  const CouponListingScreen({super.key});

  @override
  State<CouponListingScreen> createState() => _CouponListingScreenState();
}

class _CouponListingScreenState extends State<CouponListingScreen> {
  final _viewModel = locator<CouponListingViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.getCoupons();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _viewModel,
      builder: (context, child) {
        return TitledScreen(
          title: 'COUPONS',
          scrollable: false,
          child: Consumer<CouponListingViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.couponsUseCase.isLoading) {
                return const DefaultScreenLoaderWidget();
              }
              if (viewModel.couponsUseCase.hasError) {
                return DefaultErrorWidget(
                  manuallyCenter: true,
                  errorMessage: viewModel.couponsUseCase.exception!,
                  onActionButtonPressed: () => viewModel.getCoupons(),
                );
              }
              final coupons = viewModel.couponsUseCase.data ?? [];
              if (coupons.isEmpty) {
                return const DefaultErrorWidget(
                  manuallyCenter: true,
                  errorMessage:
                      'No coupons yet.\nTap a promo banner on the home screen to redeem one.',
                );
              }
              return RefreshIndicator.adaptive(
                onRefresh: () => viewModel.getCoupons(updateState: false),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: Dimens.spacingSizeLarge),
                  itemCount: coupons.length,
                  separatorBuilder: (_, __) =>
                      const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
                  itemBuilder: (context, index) =>
                      _CouponCard(coupon: coupons[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _CouponCard extends StatelessWidget {
  const _CouponCard({required this.coupon});

  final SavedCoupon coupon;

  String get _redeemableText {
    final remaining = coupon.remainingRedemptions;
    if (remaining == null) return 'Unlimited';
    return remaining == 1 ? '1 redeemable' : '$remaining redeemable';
  }

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.secondaryMain;
    return Container(
      decoration: BoxDecoration(
        color: accent.withOpacity(0.06),
        borderRadius: BorderRadius.circular(Dimens.radiusDefault),
        border: Border.all(color: accent.withOpacity(0.35)),
      ),
      padding: const EdgeInsets.all(Dimens.spacingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coupon.label,
                      style: textTheme(context).titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const VerticalSpaceWidget(height: Dimens.spacing_2),
                    Row(
                      children: [
                        Icon(Icons.local_offer_outlined,
                            size: Dimens.iconSizeSmall, color: accent),
                        const HorizontalSpaceWidget(
                            width: Dimens.spacingSizeExtraSmall),
                        Text(
                          coupon.code,
                          style: textTheme(context).bodyLarge!.copyWith(
                                fontWeight: FontWeight.w700,
                                color: accent,
                                letterSpacing: 1.1,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _CopyButton(code: coupon.code),
            ],
          ),
          const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
          const Divider(height: 1, color: AppColors.grayLighter),
          const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (coupon.validUntil != null)
                _MetaChip(
                  icon: Icons.schedule,
                  text: formatTimeLeft(coupon.validUntil!),
                )
              else
                const SizedBox(),
              _MetaChip(
                icon: Icons.confirmation_number_outlined,
                text: _redeemableText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: Dimens.iconSizeSmall, color: AppColors.grayMain),
        const HorizontalSpaceWidget(width: Dimens.spacingSizeExtraSmall),
        Text(
          text,
          style: textTheme(context)
              .bodySmall!
              .copyWith(color: AppColors.grayDark, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: code));
        if (!context.mounted) return;
        showToast(context, message: 'Code $code copied.');
      },
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondaryMain,
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.spacingSizeSmall,
        ),
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: const Icon(Icons.copy, size: Dimens.iconSizeSmall),
      label: const Text('Copy'),
    );
  }
}
