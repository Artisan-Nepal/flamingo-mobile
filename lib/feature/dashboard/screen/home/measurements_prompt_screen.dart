import 'package:flamingo/feature/fit-reference/screen/fit-reference-listing/fit_reference_listing_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/text/text_widget.dart';
import 'package:flutter/material.dart';

// Full-screen "standout" intro for the Size & Fit feature, shown once (per
// account, server-tracked) after login when the customer has no saved
// measurements. Presented as a fullscreen modal route from HomeScreen so it
// reads as a proper feature moment rather than a small dismissable sheet.
class MeasurementsPromptScreen extends StatelessWidget {
  const MeasurementsPromptScreen({super.key});

  static const List<_FitBenefit> _benefits = [
    _FitBenefit(
      icon: Icons.straighten,
      title: 'Measure once',
      subtitle: 'Save a garment you already own and love the fit of.',
    ),
    _FitBenefit(
      icon: Icons.compare_arrows,
      title: 'Compare instantly',
      subtitle: "See how each new item's measurements stack up against it.",
    ),
    _FitBenefit(
      icon: Icons.verified_outlined,
      title: 'Buy with confidence',
      subtitle: 'Fewer size guesses, fewer surprises, fewer returns.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip / dismiss - counts as "maybe later" (the prompt is already
            // marked seen server-side by the caller regardless).
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: Dimens.spacingSizeSmall,
                  right: Dimens.spacingSizeSmall,
                ),
                child: IconButton(
                  onPressed: () => NavigationHelper.pop(context),
                  icon: const Icon(Icons.close),
                  color: AppColors.grayDark,
                ),
              ),
            ),
            Expanded(child: _buildHero(context)),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.spacingSizeLarge,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SIZE & FIT',
                    style: textTheme(context).bodySmall!.copyWith(
                          color: AppColors.secondaryMain,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),
                  Text(
                    'Get a better fit',
                    style: textTheme(context).headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
                  Text(
                    "Stop guessing your size. Save the measurements of one garment you love, and we'll do the comparing for you.",
                    style: textTheme(context).bodyMedium!.copyWith(
                          color: AppColors.grayDark,
                        ),
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
                  ..._benefits.map((b) => _buildBenefitRow(context, b)),
                ],
              ),
            ),
            _buildCtas(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Center(
      // scaleDown keeps the whole composition on screen on shorter devices
      // instead of overflowing the space the CTAs and copy leave for it.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.spacingSizeSmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
          // Layered circles behind the ruler icon give the hero depth without
          // needing a bespoke illustration asset.
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 180,
                width: 180,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryLight,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 128,
                width: 128,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondaryMain.withOpacity(0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.straighten,
                  size: Dimens.spacing_56,
                  color: AppColors.primaryMain,
                ),
              ),
            ],
          ),
          const VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
          // Size-scale motif to reinforce the sizing theme.
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _SizeChip(label: 'S'),
              _SizeChip(label: 'M', highlighted: true),
              _SizeChip(label: 'L'),
            ],
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitRow(BuildContext context, _FitBenefit benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.spacingSizeDefault),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: Dimens.spacing_48,
            width: Dimens.spacing_48,
            decoration: const BoxDecoration(
              color: AppColors.grayLighter,
              shape: BoxShape.circle,
            ),
            child: Icon(
              benefit.icon,
              size: Dimens.iconSize_20,
              color: AppColors.primaryMain,
            ),
          ),
          const HorizontalSpaceWidget(width: Dimens.spacingSizeDefault),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  benefit.title,
                  style: textTheme(context).bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const VerticalSpaceWidget(height: Dimens.spacing_2),
                TextWidget(
                  benefit.subtitle,
                  style: textTheme(context).bodySmall!.copyWith(
                        color: AppColors.grayMain,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCtas(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimens.spacingSizeLarge,
        Dimens.spacingSizeDefault,
        Dimens.spacingSizeLarge,
        Dimens.spacingSizeDefault,
      ),
      child: Column(
        children: [
          FilledButtonWidget(
            label: 'Add my measurements',
            onPressed: () {
              NavigationHelper.pushReplacement(
                context,
                const FitReferenceListingScreen(),
              );
            },
          ),
          TextButton(
            onPressed: () => NavigationHelper.pop(context),
            child: Text(
              'Maybe later',
              style: textTheme(context).bodyMedium!.copyWith(
                    color: AppColors.grayDark,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FitBenefit {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FitBenefit({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class _SizeChip extends StatelessWidget {
  const _SizeChip({required this.label, this.highlighted = false});

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeExtraSmall),
      height: Dimens.spacing_32,
      width: Dimens.spacing_32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primaryMain : AppColors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: highlighted ? AppColors.primaryMain : AppColors.grayLight,
        ),
      ),
      child: Text(
        label,
        style: textTheme(context).bodySmall!.copyWith(
              color: highlighted ? AppColors.white : AppColors.grayDark,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
