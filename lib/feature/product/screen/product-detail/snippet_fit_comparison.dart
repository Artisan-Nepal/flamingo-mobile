import 'package:flamingo/feature/fit-reference/data/model/fit_comparison.dart';
import 'package:flamingo/feature/fit-reference/data/model/fit_reference.dart';
import 'package:flamingo/feature/fit-reference/screen/manage-fit-reference/manage_fit_reference_screen.dart';
import 'package:flamingo/feature/product/data/model/variant_measurement.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Compares the currently selected size against a garment the buyer already
// owns and likes the fit of - SIZE_AND_FIT_PLAN.md §4.3. Deliberately
// information, never a verdict: no pass/fail, no "will fit you". See §2.2 -
// this is policy (business plan §9.3, §11), not a UI preference. Re-fetches
// whenever the buyer changes size, since the comparison is against THIS
// variant's measurements specifically.
class SnippetFitComparison extends StatefulWidget {
  final String productId;
  final String variantId;
  // UPPER | LOWER | FULL - the product's category zone. Only references that
  // share this zone (or are themselves FULL, which carries both upper- and
  // lower-body dimensions) are eligible to auto-select or compare against
  // (SIZE_AND_FIT_PLAN.md §9 A1).
  final String productFitZone;
  // The customer's currently selected size (e.g. "S") - shown in the header
  // so "Compared with X" reads as what it actually is: a comparison against
  // THIS size, not the product as a whole.
  final String sizeLabel;
  // Reports the suggested size (SIZE_AND_FIT_PLAN.md §9/B1) up to the parent
  // screen so it can also show a hint next to the size selector itself -
  // "where the decision is actually made" per the plan - without a second,
  // duplicate reference-selection fetch of its own.
  final void Function(String? suggestedSizeLabel)? onSuggestionChanged;

  const SnippetFitComparison({
    super.key,
    required this.productId,
    required this.variantId,
    required this.productFitZone,
    required this.sizeLabel,
    this.onSuggestionChanged,
  });

  @override
  State<SnippetFitComparison> createState() => _SnippetFitComparisonState();
}

class _SnippetFitComparisonState extends State<SnippetFitComparison> {
  List<FitReference>? _references;
  FitReference? _selectedReference;
  Future<FitComparisonResult>? _comparisonFuture;
  String? _suggestedSizeLabel;
  bool _loadingReferences = true;

  bool _matchesZone(FitReference r) =>
      r.garmentZone == widget.productFitZone || r.garmentZone == 'FULL';

  List<FitReference> _candidates(List<FitReference> references) =>
      references.where(_matchesZone).toList();

  @override
  void initState() {
    super.initState();
    _loadReferences();
  }

  @override
  void didUpdateWidget(covariant SnippetFitComparison oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.variantId != widget.variantId && _selectedReference != null) {
      _loadComparison();
    }
  }

  Future<void> _loadReferences() async {
    final viewModel =
        Provider.of<ProductDetailViewModel>(context, listen: false);
    try {
      final references = await viewModel.getMyFitReferences();
      if (!mounted) return;
      setState(() {
        _references = references;
        _loadingReferences = false;
        final candidates = _candidates(references);
        if (candidates.isNotEmpty) {
          _selectedReference = candidates.firstWhere(
            (r) => r.isDefaultForZone,
            orElse: () => candidates.first,
          );
        }
      });
      if (_selectedReference != null) {
        _loadComparison();
        _loadSuggestedSize();
      }
    } catch (_) {
      if (!mounted) return;
      // Fails soft: the size chart above still works fully without this.
      setState(() => _loadingReferences = false);
    }
  }

  void _loadComparison() {
    final viewModel =
        Provider.of<ProductDetailViewModel>(context, listen: false);
    setState(() {
      _comparisonFuture = viewModel.getFitComparison(
        variantId: widget.variantId,
        referenceId: _selectedReference!.id,
      );
    });
  }

  // Product-scoped (ranks across ALL this product's sizes), unlike
  // _loadComparison() above which is variant-scoped - so this only needs
  // re-running when the selected reference changes, not on every size tap.
  Future<void> _loadSuggestedSize() async {
    final viewModel =
        Provider.of<ProductDetailViewModel>(context, listen: false);
    try {
      final result = await viewModel.getSuggestedSize(
        productId: widget.productId,
        referenceId: _selectedReference!.id,
      );
      if (!mounted) return;
      final label = result.hasSuggestion ? result.suggestedSizeLabel : null;
      setState(() => _suggestedSizeLabel = label);
      widget.onSuggestionChanged?.call(label);
    } catch (_) {
      if (!mounted) return;
      // Fails soft: the comparison above still works fully without this.
      setState(() => _suggestedSizeLabel = null);
      widget.onSuggestionChanged?.call(null);
    }
  }

  Future<void> _addReference() async {
    final result = await Navigator.push<FitReference>(
      context,
      MaterialPageRoute(
        builder: (context) => ManageFitReferenceScreen(
          initialGarmentZone: widget.productFitZone,
        ),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _references = [...?_references, result];
      _selectedReference = result;
    });
    _loadComparison();
    _loadSuggestedSize();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingReferences) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: Dimens.spacingSizeDefault),
        child: Center(
            child: CircularProgressIndicatorWidget(size: Dimens.iconSizeDefault)),
      );
    }

    final references = _references ?? [];
    final hasMatch = _selectedReference != null;

    return Container(
      margin: const EdgeInsets.only(top: Dimens.spacingSizeLarge),
      padding: const EdgeInsets.all(Dimens.spacingSizeDefault),
      decoration: BoxDecoration(
        color: AppColors.grayLighter,
        borderRadius: BorderRadius.circular(Dimens.radiusSmall),
      ),
      child: references.isEmpty
          ? _buildEmptyState()
          : (hasMatch
              ? _buildComparison(references)
              : _buildZoneMismatchState(references)),
    );
  }

  // Zone-aware copy so the prompt matches what the buyer should actually go
  // measure, instead of always saying "top" regardless of what's on screen.
  String get _garmentNoun {
    switch (widget.productFitZone) {
      case 'LOWER':
        return 'bottoms';
      case 'FULL':
        return 'dress';
      case 'UPPER':
      default:
        return 'top';
    }
  }

  String get _addReferenceCta {
    switch (widget.productFitZone) {
      case 'LOWER':
        return '+ Measure a pair of bottoms you own';
      case 'FULL':
        return '+ Measure a dress you own';
      case 'UPPER':
      default:
        return '+ Measure your favourite tee';
    }
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compare with your sizes',
          style: textTheme(context)
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        const VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),
        Text(
          "Measure a $_garmentNoun you already own and love, and we'll show how this one compares - no guessing.",
          style: textTheme(context)
              .bodySmall!
              .copyWith(color: AppColors.grayMain),
        ),
        const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
        TextButton(
          onPressed: _addReference,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text(_addReferenceCta),
        ),
      ],
    );
  }

  // The buyer has saved reference garments, just none for this product's
  // zone (e.g. only a top saved, viewing trousers) - a targeted prompt
  // instead of a blank/broken-looking panel (SIZE_AND_FIT_PLAN.md §9 A1).
  Widget _buildZoneMismatchState(List<FitReference> references) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compare with your sizes',
          style: textTheme(context)
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        const VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),
        Text(
          "You've saved sizes, but not for a $_garmentNoun yet. Measure a $_garmentNoun you own to compare this one.",
          style: textTheme(context)
              .bodySmall!
              .copyWith(color: AppColors.grayMain),
        ),
        const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
        // Wrap, not Row - "+ Measure a pair of bottoms you own" plus "See
        // your saved sizes" together don't reliably fit one line, and a Row
        // would overflow instead of dropping the second item below.
        Wrap(
          spacing: Dimens.spacingSizeDefault,
          runSpacing: Dimens.spacingSizeExtraSmall,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            TextButton(
              onPressed: _addReference,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(_addReferenceCta),
            ),
            GestureDetector(
              onTap: () => _showReferencePicker(references),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('See your saved sizes',
                      style: textTheme(context).bodySmall),
                  const Icon(Icons.arrow_drop_down, size: 18),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildComparison(List<FitReference> references) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Comparing "${_selectedReference?.label}" to size ${widget.sizeLabel}',
                style: textTheme(context)
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (references.length > 1)
              GestureDetector(
                onTap: () => _showReferencePicker(references),
                child: Row(
                  children: [
                    Text('Change', style: textTheme(context).bodySmall),
                    const Icon(Icons.arrow_drop_down, size: 18),
                  ],
                ),
              ),
          ],
        ),
        if (_suggestedSizeLabel != null) ...[
          const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
          // A similarity statement, never a fit verdict (§2.2/§9.3) - "closest
          // to", not "will fit" or a pass/fail badge. SIZE_AND_FIT_PLAN.md
          // §9/B1.
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.spacingSizeSmall,
              vertical: Dimens.spacingSizeExtraSmall,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isLightMode(context)
                      ? AppColors.black
                      : AppColors.white),
              borderRadius: BorderRadius.circular(Dimens.radiusSmall),
            ),
            child: Text(
              'Closest to your reference: $_suggestedSizeLabel',
              style: textTheme(context)
                  .bodySmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
        const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
        FutureBuilder<FitComparisonResult>(
          future: _comparisonFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: Dimens.spacingSizeSmall),
                child: CircularProgressIndicatorWidget(
                    size: Dimens.iconSizeDefault),
              );
            }
            if (snapshot.hasError || snapshot.data == null) {
              return const SizedBox();
            }
            final items = snapshot.data!.items;
            if (items.isEmpty) {
              return Text(
                "This size doesn't share any measured dimensions with your reference yet.",
                style: textTheme(context)
                    .bodySmall!
                    .copyWith(color: AppColors.grayMain),
              );
            }
            return Column(
              children: items.map(_buildComparisonRow).toList(),
            );
          },
        ),
        TextButton(
          onPressed: _addReference,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: const Text('+ Add another'),
        ),
      ],
    );
  }

  Widget _buildComparisonRow(FitComparisonItem item) {
    final label = measurementDimensionLabels[item.dimension] ?? item.dimension;
    final descriptor = fitDescriptorLabels[item.descriptorKey] ?? item.descriptorKey;
    final sign = item.deltaMm > 0 ? '+' : (item.deltaMm < 0 ? '-' : '');
    final cm = item.absDeltaCm == 0 ? '' : '$sign${item.absDeltaCm.toStringAsFixed(1)}cm  ';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: textTheme(context).bodySmall),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: textTheme(context).bodySmall!.copyWith(
                    color: item.isNotable
                        ? AppColors.black
                        : AppColors.grayMain),
                children: [
                  TextSpan(text: cm),
                  TextSpan(
                    text: descriptor,
                    style: TextStyle(
                      fontWeight:
                          item.isNotable ? FontWeight.w700 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Shows every saved reference, not just zone matches - hiding non-matching
  // ones would read as "where did my saved size go?" to a buyer who knows
  // they saved it. Non-matching entries are visible but greyed and labelled,
  // not selectable dead-ends (SIZE_AND_FIT_PLAN.md §9 A1).
  void _showReferencePicker(List<FitReference> references) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: references.map((reference) {
              final matches = _matchesZone(reference);
              return ListTile(
                title: Text(
                  reference.label,
                  style: matches
                      ? null
                      : TextStyle(color: AppColors.grayMain),
                ),
                subtitle: Text(
                  matches
                      ? (garmentZoneLabels[reference.garmentZone] ??
                          reference.garmentZone)
                      : 'Different garment type',
                  style: TextStyle(
                      color: matches ? null : AppColors.grayMain),
                ),
                selected: reference.id == _selectedReference?.id,
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedReference = reference);
                  _loadComparison();
                  _loadSuggestedSize();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
