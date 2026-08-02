import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A modern price-range control: a two-thumb [RangeSlider] kept in sync with two
/// manual number fields, so a buyer can drag for a quick range or type exact
/// figures. Values are in rupees. Reports the current selection through
/// [onChanged] on every edit; the parent decides when to apply it.
class PriceRangeSelector extends StatefulWidget {
  const PriceRangeSelector({
    super.key,
    required this.maxBound,
    required this.onChanged,
    this.initialMin,
    this.initialMax,
  });

  /// Upper end of the slider track, in rupees. See [priceUpperBoundRupees].
  final double maxBound;

  /// Initial selected values in rupees (null = start of range / full range).
  final int? initialMin;
  final int? initialMax;

  /// Called with the current (min, max) in rupees whenever either changes.
  final void Function(int min, int max) onChanged;

  @override
  State<PriceRangeSelector> createState() => _PriceRangeSelectorState();
}

class _PriceRangeSelectorState extends State<PriceRangeSelector> {
  late double _min;
  late double _max;
  late final TextEditingController _minCtrl;
  late final TextEditingController _maxCtrl;

  double get _bound => widget.maxBound <= 0 ? 10000 : widget.maxBound;

  @override
  void initState() {
    super.initState();
    _min = (widget.initialMin?.toDouble() ?? 0).clamp(0, _bound);
    _max = (widget.initialMax?.toDouble() ?? _bound).clamp(_min, _bound);
    _minCtrl = TextEditingController(text: _min.round().toString());
    _maxCtrl = TextEditingController(text: _max.round().toString());
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  void _emit() => widget.onChanged(_min.round(), _max.round());

  void _onSlider(RangeValues values) {
    setState(() {
      _min = values.start;
      _max = values.end;
      _minCtrl.text = _min.round().toString();
      _maxCtrl.text = _max.round().toString();
    });
    _emit();
  }

  void _onMinTyped(String raw) {
    final parsed = double.tryParse(raw) ?? 0;
    _min = parsed.clamp(0, _max);
    _emit();
    setState(() {});
  }

  void _onMaxTyped(String raw) {
    final parsed = double.tryParse(raw) ?? _bound;
    _max = parsed.clamp(_min, _bound);
    _emit();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final primary = themedPrimaryColor(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _PriceField(
                label: 'Min',
                controller: _minCtrl,
                onChanged: _onMinTyped,
                onSubmitted: (_) => _syncFieldsToSlider(),
              ),
            ),
            const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
            Container(
              width: 14,
              height: 1.5,
              color: AppColors.grayLight,
            ),
            const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
            Expanded(
              child: _PriceField(
                label: 'Max',
                controller: _maxCtrl,
                onChanged: _onMaxTyped,
                onSubmitted: (_) => _syncFieldsToSlider(),
              ),
            ),
          ],
        ),
        const VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            activeTrackColor: primary,
            inactiveTrackColor: AppColors.grayLight.withOpacity(0.4),
            thumbColor: primary,
            overlayColor: primary.withOpacity(0.12),
            rangeThumbShape:
                const RoundRangeSliderThumbShape(enabledThumbRadius: 9),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
            showValueIndicator: ShowValueIndicator.never,
          ),
          child: RangeSlider(
            min: 0,
            max: _bound,
            values: RangeValues(_min.clamp(0, _bound), _max.clamp(0, _bound)),
            onChanged: _onSlider,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rs 0', style: _hintStyle(context)),
              Text('Rs ${_bound.round()}+', style: _hintStyle(context)),
            ],
          ),
        ),
      ],
    );
  }

  // On submit/blur, re-clamp the text values back onto the slider so a typed
  // number out of order (min > max) settles into a valid range.
  void _syncFieldsToSlider() {
    setState(() {
      _minCtrl.text = _min.round().toString();
      _maxCtrl.text = _max.round().toString();
    });
  }

  TextStyle _hintStyle(BuildContext context) => textTheme(context)
      .bodySmall!
      .copyWith(color: AppColors.grayMain, fontSize: Dimens.fontSizeSmall);
}

class _PriceField extends StatelessWidget {
  const _PriceField({
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: TypographyStyles.labelLarge,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        prefixText: 'Rs ',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimens.spacingSizeSmall,
          vertical: Dimens.spacingSizeSmall,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusSmall),
          borderSide: const BorderSide(color: AppColors.grayLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusSmall),
          borderSide: const BorderSide(color: AppColors.grayLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusSmall),
          borderSide: BorderSide(color: themedPrimaryColor(context)),
        ),
      ),
    );
  }
}
