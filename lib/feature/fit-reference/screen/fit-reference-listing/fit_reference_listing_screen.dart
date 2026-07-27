import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/fit-reference/data/model/fit_reference.dart';
import 'package:flamingo/feature/fit-reference/screen/fit-reference-listing/fit_reference_listing_view_model.dart';
import 'package:flamingo/feature/fit-reference/screen/manage-fit-reference/manage_fit_reference_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/alert-dialog/alert_dialog_widget.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

  Widget _buildList(
    FitReferenceListingViewModel viewModel,
    List<FitReference> references,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: Dimens.spacingSizeSmall),
      physics: const BouncingScrollPhysics(),
      itemCount: references.length,
        itemBuilder: (context, index) {
          final reference = references[index];
          return Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    NavigationHelper.push(
                      context,
                      ChangeNotifierProvider.value(
                        value: viewModel,
                        builder: (context, child) => ManageFitReferenceScreen(
                          existingReference: reference,
                        ),
                      ),
                    );
                  },
                  backgroundColor: Colors.blue,
                  icon: Icons.edit,
                ),
                SlidableAction(
                  onPressed: (_) => _handleDelete(viewModel, reference.id),
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: Dimens.spacingSizeDefault),
              child: ListTile(
                onTap: reference.isDefaultForZone
                    ? null
                    : () => viewModel.setDefault(reference.id),
                title: Row(
                  children: [
                    Flexible(
                      child: Text(
                        reference.label,
                        style: textTheme(context)
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (reference.isDefaultForZone) ...[
                      const HorizontalSpaceWidget(
                          width: Dimens.spacingSizeExtraSmall),
                      _buildDefaultBadge(context),
                    ],
                  ],
                ),
                subtitle: Text(
                  [
                    garmentZoneLabels[reference.garmentZone] ??
                        reference.garmentZone,
                    if (reference.fitTypeHint != 'UNKNOWN')
                      fitTypeHintLabels[reference.fitTypeHint] ??
                          reference.fitTypeHint,
                  ].join(' · '),
                ),
                trailing: reference.isDefaultForZone
                    ? null
                    : TextButton(
                        onPressed: () => viewModel.setDefault(reference.id),
                        child: const Text('Set default'),
                      ),
              ),
            ),
          );
        },
    );
  }

  Widget _buildDefaultBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius: BorderRadius.circular(Dimens.radius_5),
      ),
      child: const Text(
        'DEFAULT',
        style: TextStyle(color: AppColors.white, fontSize: 10),
      ),
    );
  }

  void _openManageScreen() {
    NavigationHelper.push(
      context,
      ChangeNotifierProvider.value(
        value: _viewModel,
        builder: (context, child) => const ManageFitReferenceScreen(),
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
