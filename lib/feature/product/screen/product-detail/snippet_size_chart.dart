import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/product/data/model/product_size.dart';
import 'package:flamingo/feature/product/data/model/variant_measurement.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const Map<String, String> _fitTypeLabels = {
  'SLIM': 'Slim fit',
  'REGULAR': 'Regular fit',
  'RELAXED': 'Relaxed fit',
  'OVERSIZED': 'Oversized fit',
};

const Map<String, String> _stretchLevelLabels = {
  'NONE': 'No stretch',
  'SLIGHT': 'Slight stretch',
  'MODERATE': 'Moderate stretch',
  'HIGH': 'Very stretchy',
};

// The buyer-facing half of SIZE_AND_FIT_PLAN.md Stage 3 (first slice): shows
// what Flamingo staff physically measured, per size. Deliberately NOT a fit
// predictor - no "this will fit you" - just the numbers, same as any size
// chart, sourced from a verified measurement instead of a seller's claim.
// Reference-garment comparison (§4.3) is a later slice on top of this.
class SnippetSizeChart extends StatefulWidget {
  final ProductDetail product;
  final List<ProductSizeOption> availableSizes;

  const SnippetSizeChart({
    super.key,
    required this.product,
    required this.availableSizes,
  });

  @override
  State<SnippetSizeChart> createState() => _SnippetSizeChartState();
}

class _SnippetSizeChartState extends State<SnippetSizeChart> {
  late Future<Map<String, List<VariantMeasurement>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadMeasurements();
  }

  Future<Map<String, List<VariantMeasurement>>> _loadMeasurements() async {
    final viewModel =
        Provider.of<ProductDetailViewModel>(context, listen: false);
    final entries = await Future.wait(widget.availableSizes.map((size) async {
      final variant = viewModel.getVariantBySize(size);
      final measurements = await viewModel.getVariantMeasurements(variant.id);
      return MapEntry(size.value, measurements);
    }));
    return Map.fromEntries(entries);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<VariantMeasurement>>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: Dimens.spacingSizeLarge),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          // Fails soft: the size selector above still works fully without
          // this - a chart that can't load is not worth blocking the page for.
          return const SizedBox();
        }

        final bySize = snapshot.data!;
        final dimensions = measurementDimensionOrder
            .where((dim) => bySize.values.any(
                (list) => list.any((m) => m.dimension == dim)))
            .toList();

        if (dimensions.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.product.fitType != null ||
                widget.product.stretchLevel != null) ...[
              Text(
                [
                  if (widget.product.fitType != null)
                    _fitTypeLabels[widget.product.fitType] ??
                        widget.product.fitType!,
                  if (widget.product.stretchLevel != null)
                    _stretchLevelLabels[widget.product.stretchLevel] ??
                        widget.product.stretchLevel!,
                ].join(' · '),
                style: textTheme(context)
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
            ],
            Text(
              'Measured flat, in cm, on Flamingo\'s QC table.',
              style: textTheme(context)
                  .bodySmall!
                  .copyWith(color: AppColors.grayMain),
            ),
            const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
            _buildTable(context, dimensions, bySize),
          ],
        );
      },
    );
  }

  Widget _buildTable(
    BuildContext context,
    List<String> dimensions,
    Map<String, List<VariantMeasurement>> bySize,
  ) {
    final sizeLabels = widget.availableSizes.map((s) => s.value).toList();

    Widget headerCell(String text) => Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimens.spacingSizeSmall,
            horizontal: Dimens.spacingSizeExtraSmall,
          ),
          child: Text(
            text,
            style: textTheme(context)
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
        );

    Widget dataCell(String text) => Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimens.spacingSizeSmall,
            horizontal: Dimens.spacingSizeExtraSmall,
          ),
          child: Text(text, style: textTheme(context).bodyMedium),
        );

    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: AppColors.grayLight, width: 0.5),
      ),
      columnWidths: {
        0: const FlexColumnWidth(1.4),
        for (var i = 0; i < sizeLabels.length; i++) i + 1: const FlexColumnWidth(1),
      },
      children: [
        TableRow(children: [
          headerCell(''),
          ...sizeLabels.map((label) => headerCell(label)),
        ]),
        for (final dimension in dimensions)
          TableRow(children: [
            dataCell(measurementDimensionLabels[dimension] ?? dimension),
            ...sizeLabels.map((sizeLabel) {
              final measurement = bySize[sizeLabel]?.firstWhere(
                (m) => m.dimension == dimension,
                orElse: () => VariantMeasurement(
                    dimension: dimension, valueMm: 0, geometry: ''),
              );
              final value = measurement != null && measurement.valueMm > 0
                  ? measurement.valueCm.toStringAsFixed(1)
                  : '—';
              return dataCell(value);
            }),
          ]),
      ],
    );
  }
}
