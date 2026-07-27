import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/fit-reference/data/model/fit_reference.dart';
import 'package:flamingo/feature/product/data/model/variant_measurement.dart';
import 'package:flamingo/feature/fit-reference/screen/fit-reference-listing/fit_reference_listing_view_model.dart';
import 'package:flamingo/feature/fit-reference/screen/manage-fit-reference/manage_fit_reference_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Measure a garment flat, in cm. Deliberately a small, curated dimension set
// per zone (not the admin station's full 15) - a buyer measuring their own
// favourite tee at home should be asked for 3-4 numbers, not put through a
// QC-grade form. See fit_reference.dart's upperBodyReferenceDimensions/
// lowerBodyReferenceDimensions.
class ManageFitReferenceScreen extends StatefulWidget {
  const ManageFitReferenceScreen({
    super.key,
    this.existingReference,
    this.initialGarmentZone,
  });

  final FitReference? existingReference;
  // Pre-selects the zone picker when reached from a product page whose
  // category has a known fitZone, so a buyer prompted from e.g. a trousers
  // page isn't first asked "top or bottom?" for a garment they're already
  // about to measure (SIZE_AND_FIT_PLAN.md §9 A1). Ignored when editing.
  final String? initialGarmentZone;

  @override
  State<ManageFitReferenceScreen> createState() =>
      _ManageFitReferenceScreenState();
}

class _ManageFitReferenceScreenState extends State<ManageFitReferenceScreen> {
  final _viewModel = locator<ManageFitReferenceViewModel>();
  final _labelController = TextEditingController();
  final Map<String, TextEditingController> _dimensionControllers = {};

  String _garmentZone = 'UPPER';
  String _fitTypeHint = 'UNKNOWN';

  bool get _isEditing => widget.existingReference != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingReference;
    if (existing != null) {
      _labelController.text = existing.label;
      _garmentZone = existing.garmentZone;
      _fitTypeHint = existing.fitTypeHint;
    } else if (widget.initialGarmentZone != null) {
      _garmentZone = widget.initialGarmentZone!;
    }
    for (final dimension in _relevantDimensions()) {
      FitReferenceMeasurement? existingValue;
      if (existing != null) {
        for (final m in existing.measurements) {
          if (m.dimension == dimension) {
            existingValue = m;
            break;
          }
        }
      }
      _dimensionControllers[dimension] = TextEditingController(
        text: existingValue != null
            ? existingValue.valueCm.toStringAsFixed(1)
            : '',
      );
    }
  }

  List<String> _relevantDimensions() {
    switch (_garmentZone) {
      case 'UPPER':
        return upperBodyReferenceDimensions;
      case 'LOWER':
        return lowerBodyReferenceDimensions;
      case 'FULL':
      default:
        return [...upperBodyReferenceDimensions, ...lowerBodyReferenceDimensions];
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    for (final c in _dimensionControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: DefaultScreen(
        appBarTitle: Text(_isEditing ? 'Edit size' : 'Measure a garment'),
        child: Consumer<ManageFitReferenceViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_isEditing) ...[
                  _buildSectionLabel('What did you measure?'),
                  const VerticalSpaceWidget(
                      height: Dimens.spacingSizeSmall),
                  _buildZonePicker(),
                  const VerticalSpaceWidget(
                      height: Dimens.spacingSizeDefault),
                ],
                _buildSectionLabel('Name it'),
                const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
                TextField(
                  controller: _labelController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. My favourite tee',
                  ),
                ),
                const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                _buildSectionLabel('How does it fit you?'),
                const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
                _buildFitTypePicker(),
                const VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
                _buildSectionLabel('Lay it flat and measure, in cm'),
                Text(
                  "Leave a field blank if you're not sure - the more you fill in, the better the comparison.",
                  style: textTheme(context)
                      .bodySmall!
                      .copyWith(color: AppColors.grayMain),
                ),
                const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                ..._buildDimensionFields(),
                const VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
                FilledButtonWidget(
                  label: 'Save',
                  width: double.infinity,
                  isLoading: viewModel.saveUseCase.isLoading,
                  onPressed: () => _onSubmit(context, viewModel),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Builder(
      builder: (context) => Text(
        text,
        style: textTheme(context)
            .bodyMedium!
            .copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildZonePicker() {
    return Wrap(
      spacing: Dimens.spacingSizeSmall,
      children: garmentZoneLabels.entries.map((entry) {
        final selected = _garmentZone == entry.key;
        return ChoiceChip(
          label: Text(entry.value),
          selected: selected,
          onSelected: (_) {
            setState(() {
              _garmentZone = entry.key;
              // Reset dimension inputs for the new zone's relevant set.
              _dimensionControllers.clear();
              for (final dimension in _relevantDimensions()) {
                _dimensionControllers[dimension] = TextEditingController();
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildFitTypePicker() {
    return Wrap(
      spacing: Dimens.spacingSizeSmall,
      children: fitTypeHintLabels.entries.map((entry) {
        return ChoiceChip(
          label: Text(entry.value),
          selected: _fitTypeHint == entry.key,
          onSelected: (_) => setState(() => _fitTypeHint = entry.key),
        );
      }).toList(),
    );
  }

  List<Widget> _buildDimensionFields() {
    return _relevantDimensions().map((dimension) {
      return Padding(
        padding: const EdgeInsets.only(bottom: Dimens.spacingSizeDefault),
        child: TextField(
          controller: _dimensionControllers[dimension],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: measurementDimensionLabels[dimension] ?? dimension,
            suffixText: 'cm',
          ),
        ),
      );
    }).toList();
  }

  Future<void> _onSubmit(
    BuildContext context,
    ManageFitReferenceViewModel viewModel,
  ) async {
    final label = _labelController.text.trim();
    if (label.isEmpty) {
      showToast(context, message: 'Give this a name first.', isSuccess: false);
      return;
    }

    final measurements = <FitReferenceMeasurement>[];
    for (final entry in _dimensionControllers.entries) {
      final text = entry.value.text.trim();
      if (text.isEmpty) continue;
      final cm = double.tryParse(text);
      if (cm == null || cm <= 0) continue;
      measurements.add(FitReferenceMeasurement(
        dimension: entry.key,
        valueMm: (cm * 10).round(),
      ));
    }

    if (measurements.isEmpty) {
      showToast(
        context,
        message: 'Enter at least one measurement.',
        isSuccess: false,
      );
      return;
    }

    if (_isEditing) {
      await viewModel.update(
        id: widget.existingReference!.id,
        label: label,
        fitTypeHint: _fitTypeHint,
        measurements: measurements,
      );
    } else {
      await viewModel.create(
        label: label,
        garmentZone: _garmentZone,
        fitTypeHint: _fitTypeHint,
        measurements: measurements,
      );
    }

    if (!context.mounted) return;

    if (viewModel.saveUseCase.hasCompleted) {
      // Best-effort: refreshes the "My Sizes" list when reached from there.
      // When reached from a product page instead (no such ancestor), this
      // throws harmlessly and is ignored - that caller gets the saved
      // reference directly via the pop result below instead.
      try {
        Provider.of<FitReferenceListingViewModel>(context, listen: false)
            .getReferences();
      } catch (_) {}
      Navigator.pop(context, viewModel.saveUseCase.data);
    } else if (viewModel.saveUseCase.hasError) {
      showToast(
        context,
        message: viewModel.saveUseCase.exception,
        isSuccess: false,
      );
    }
  }
}
