import 'package:flamingo/feature/review/data/model/review_summary.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/rating/star_rating_widget.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';

// Big average + star row on the left, 5->1 star distribution bars on the
// right. Shared by the PDP reviews section and the full review list screen.
class SnippetReviewSummary extends StatelessWidget {
  const SnippetReviewSummary({super.key, required this.summary});

  final ReviewSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            TextWidget(
              summary.averageRating.toStringAsFixed(1),
              style: textTheme(context).headlineSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: Dimens.spacingSizeExtraSmall),
            StarRatingWidget(value: summary.averageRating),
            const SizedBox(height: Dimens.spacingSizeExtraSmall),
            TextWidget(
              '${summary.totalCount} rating${summary.totalCount == 1 ? '' : 's'}',
              style: textTheme(context).bodySmall!.copyWith(
                    color: AppColors.grayMain,
                  ),
            ),
          ],
        ),
        const SizedBox(width: Dimens.spacingSizeLarge),
        Expanded(
          child: Column(
            children: List.generate(5, (index) {
              final star = 5 - index;
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Dimens.spacing_2 / 2),
                child: Row(
                  children: [
                    TextWidget(
                      '$star',
                      style: textTheme(context).bodySmall!,
                    ),
                    const SizedBox(width: Dimens.spacingSizeExtraSmall),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimens.radius_5),
                        child: LinearProgressIndicator(
                          value: summary.fractionFor(star),
                          minHeight: 6,
                          backgroundColor: AppColors.grayLine,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.warning,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimens.spacingSizeExtraSmall),
                    SizedBox(
                      width: 24,
                      child: TextWidget(
                        '${summary.countFor(star)}',
                        style: textTheme(context).bodySmall!.copyWith(
                              color: AppColors.grayMain,
                            ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
