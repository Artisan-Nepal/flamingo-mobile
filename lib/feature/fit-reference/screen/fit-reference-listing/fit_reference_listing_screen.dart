import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/fit-reference/data/model/fit_reference.dart';
import 'package:flamingo/feature/fit-reference/screen/fit-reference-listing/fit_reference_listing_view_model.dart';
import 'package:flamingo/feature/fit-reference/screen/manage-fit-reference/manage_fit_reference_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/alert-dialog/alert_dialog_widget.dart';
import 'package:flamingo/widget/image/svg_image.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// "My sizes" (SIZE_AND_FIT_PLAN.md §4.2): the buyer's saved reference
// garments - "my favourite tee", measured flat, used as the comparison
// yardstick on product pages instead of self-measuring the body (§2.1: a
// flat garment is far more repeatable than a body, ±2-4cm self-measurement
// error).
class FitReferenceListingScreen extends StatefulWidget {
  const FitReferenceListingScreen({super.key});

  @override
  State<FitReferenceListingScreen> createState() =>
      _FitReferenceListingScreenState();
}

class _FitReferenceListingScreenState
    extends State<FitReferenceListingScreen> {
  final _viewModel = locator<FitReferenceListingViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.getReferences();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: DefaultScreen(
        appBarTitle: const Text('My Sizes'),
        scrollable: false,
        bottomNavBarWithButton: true,
        bottomNavBarWithButtonLabel: 'Measure a new garment',
        bottomNavBarWithButtonOnPressed: _openManageScreen,
        child: Consumer<FitReferenceListingViewModel>(
          builder: (context, viewModel, child) {
            if (!viewModel.getReferencesUseCase.hasCompleted) {
              return const Center(
                child: CircularProgressIndicatorWidget(
                  size: Dimens.iconSizeLarge,
                ),
              );
            }
            final references = viewModel.getReferencesUseCase.data ?? [];
            if (references.isEmpty) return _buildEmptyState();
            return _buildList(viewModel, references);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: Dimens.spacing_100,
            width: Dimens.spacing_100,
            decoration: const BoxDecoration(
              color: AppColors.grayLighter,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.straighten,
              size: Dimens.iconSizeExtraLarge,
              color: AppColors.grayMain,
            ),
          ),
          const VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
          Text(
            'No saved sizes yet',
            style: textTheme(context).bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
          Text(
            "Grab a top or pair of bottoms you love the fit of, and measure it flat. Save it here once, and we'll show you how everything compares to it.",
            textAlign: TextAlign.center,
            style: textTheme(context)
                .bodyMedium!
                .copyWith(color: AppColors.grayMain),
          ),
        ],
      ),
    );
  }

  // Fixed zone order so the sections don't reshuffle as references are added.
  static const List<String> _zoneOrder = ['UPPER', 'LOWER', 'FULL'];

  Widget _buildList(
    FitReferenceListingViewModel viewModel,
    List<FitReference> references,
  ) {
    // Group by garment zone - a Top and a Bottom can each have their own
    // default, and grouping makes that (and the two DEFAULT badges) read as
    // intentional rather than confusing.
    final byZone = <String, List<FitReference>>{};
    for (final reference in references) {
      byZone.putIfAbsent(reference.garmentZone, () => []).add(reference);
    }
    final zones = [
      ..._zoneOrder.where(byZone.containsKey),
      ...byZone.keys.where((z) => !_zoneOrder.contains(z)),
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: Dimens.spacingSizeSmall),
      physics: const BouncingScrollPhysics(),
      children: [
        for (final zone in zones) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: Dimens.spacingSizeExtraSmall,
              bottom: Dimens.spacingSizeSmall,
            ),
            child: Text(
              _zoneHeader(zone),
              style: textTheme(context).bodySmall!.copyWith(
                    color: AppColors.grayMain,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
            ),
          ),
          _buildZoneCard(viewModel, byZone[zone]!),
          const VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
        ],
      ],
    );
  }

  Widget _buildZoneCard(
    FitReferenceListingViewModel viewModel,
    List<FitReference> references,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimens.radiusSmall),
        border: Border.all(color: AppColors.grayLine),
      ),
      child: Column(
        children: [
          for (int i = 0; i < references.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.grayLine,
                indent: Dimens.spacingSizeDefault,
                endIndent: Dimens.spacingSizeDefault,
              ),
            _buildReferenceRow(viewModel, references[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildReferenceRow(
    FitReferenceListingViewModel viewModel,
    FitReference reference,
  ) {
    final fitType = reference.fitTypeHint == 'UNKNOWN'
        ? null
        : fitTypeHintLabels[reference.fitTypeHint] ?? reference.fitTypeHint;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.spacingSizeDefault,
        vertical: Dimens.spacingSizeDefault,
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.grayLighter,
              shape: BoxShape.circle,
            ),
            child: SvgImageWidget(
              image: _garmentIcon(reference.garmentZone),
              width: Dimens.iconSize_20,
              height: Dimens.iconSize_20,
              color: AppColors.primaryMain,
            ),
          ),
          const HorizontalSpaceWidget(width: Dimens.spacingSizeDefault),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        reference.label,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme(context)
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (reference.isDefaultForZone) ...[
                      const HorizontalSpaceWidget(
                          width: Dimens.spacingSizeExtraSmall),
                      _buildDefaultPill(context),
                    ],
                  ],
                ),
                if (fitType != null) ...[
                  const VerticalSpaceWidget(height: Dimens.spacing_2),
                  Text(
                    fitType,
                    style: textTheme(context)
                        .bodySmall!
                        .copyWith(color: AppColors.grayMain),
                  ),
                ],
              ],
            ),
          ),
          _buildRowMenu(viewModel, reference),
        ],
      ),
    );
  }

  Widget _buildRowMenu(
    FitReferenceListingViewModel viewModel,
    FitReference reference,
  ) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.grayMain),
      padding: EdgeInsets.zero,
      onSelected: (value) {
        switch (value) {
          case 'default':
            viewModel.setDefault(reference.id);
            break;
          case 'edit':
            _openManageScreen(existingReference: reference);
            break;
          case 'delete':
            _handleDelete(viewModel, reference.id);
            break;
        }
      },
      itemBuilder: (context) => [
        if (!reference.isDefaultForZone)
          const PopupMenuItem(
            value: 'default',
            child: Text('Set as default'),
          ),
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        const PopupMenuItem(
          value: 'delete',
          child: Text('Remove', style: TextStyle(color: AppColors.error)),
        ),
      ],
    );
  }

  Widget _buildDefaultPill(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.spacing_8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius: BorderRadius.circular(Dimens.radius_10),
      ),
      child: const Text(
        'Default',
        style: TextStyle(
          color: AppColors.white,
          fontSize: Dimens.fontSizeExtraSmall,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _zoneHeader(String zone) {
    switch (zone) {
      case 'UPPER':
        return 'Tops';
      case 'LOWER':
        return 'Bottoms';
      case 'FULL':
        return 'Full body';
      default:
        return garmentZoneLabels[zone] ?? zone;
    }
  }

  String _garmentIcon(String zone) {
    switch (zone) {
      case 'LOWER':
        return ImageConstants.garmentBottom;
      case 'FULL':
        return ImageConstants.garmentFull;
      case 'UPPER':
      default:
        return ImageConstants.garmentTop;
    }
  }

  void _openManageScreen({FitReference? existingReference}) {
    NavigationHelper.push(
      context,
      ChangeNotifierProvider.value(
        value: _viewModel,
        builder: (context, child) => ManageFitReferenceScreen(
          existingReference: existingReference,
        ),
      ),
    );
  }

  void _handleDelete(
    FitReferenceListingViewModel viewModel,
    String id,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialogWidget(
        title: 'Remove this saved size?',
        description: "You'll need to measure it again if you want it back.",
        needSecondButton: true,
        firstButtonLabel: 'Remove',
        secondButtonLabel: 'Cancel',
        firstButtonOnPressed: () async {
          Navigator.pop(dialogContext);
          await viewModel.deleteReference(id);
        },
      ),
    );
  }
}
