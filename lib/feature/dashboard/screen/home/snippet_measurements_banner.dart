import 'package:flamingo/feature/fit-reference/screen/fit-reference-listing/fit_reference_listing_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/text/text_widget.dart';
import 'package:flutter/material.dart';

// A lighter-weight cousin of SnippetPromoBanners (below it on the home
// screen) - nudges a logged-in customer with no saved measurements toward
// "My Sizes". Deliberately muted (light fill, thin border, no chevron
// urgency) so it doesn't compete visually with real promotions. Whether to
// render at all, and for how long, is decided by HomeScreen
// (_evaluateMeasurementsNudges) - this widget just renders when told to.
class SnippetMeasurementsBanner extends StatelessWidget {
  const SnippetMeasurementsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimens.spacingSizeSmall,
        right: Dimens.spacingSizeSmall,
        bottom: Dimens.spacingSizeSmall,
      ),
      child: GestureDetector(
        onTap: () => NavigationHelper.push(
          context,
          const FitReferenceListingScreen(),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.spacingSizeDefault,
            vertical: Dimens.spacingSizeSmall,
          ),
          decoration: BoxDecoration(
            color: AppColors.grayLighter,
            borderRadius: BorderRadius.circular(Dimens.radius_5),
            border: Border.all(color: AppColors.grayLine),
          ),
          child: Row(
            children: [
              Icon(
                Icons.straighten,
                size: Dimens.iconSize_15,
                color: AppColors.grayMain,
              ),
              const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
              Expanded(
                child: TextWidget(
                  'Save your measurements for a better fit',
                  style: textTheme(context).bodySmall!.copyWith(
                        color: AppColors.grayDark,
                      ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: Dimens.iconSize_15,
                color: AppColors.grayMain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
