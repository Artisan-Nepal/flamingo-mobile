import 'package:flamingo/feature/review/data/model/review.dart';
import 'package:flamingo/feature/review/data/model/review_reply.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/rating/star_rating_widget.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';

class SnippetReviewTile extends StatelessWidget {
  const SnippetReviewTile({super.key, required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.grayLighter,
              // ResizeImage caps the DECODE size to the ~32px the avatar is
              // ever drawn at - a raw NetworkImage decodes at the source's full
              // resolution regardless of display size, which is exactly the
              // per-image memory cost the app already fights elsewhere (see
              // CachedNetworkImageWidget's decode-cap comment).
              backgroundImage: review.reviewerAvatar != null
                  ? ResizeImage(
                      NetworkImage(review.reviewerAvatar!),
                      width: (32 * MediaQuery.devicePixelRatioOf(context)).round(),
                    )
                  : null,
              child: review.reviewerAvatar == null
                  ? TextWidget(
                      review.reviewerName.isNotEmpty
                          ? review.reviewerName[0].toUpperCase()
                          : '?',
                      style: textTheme(context).bodyMedium!.copyWith(
                            color: AppColors.grayDark,
                          ),
                    )
                  : null,
            ),
            const SizedBox(width: Dimens.spacingSizeSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    review.reviewerName,
                    style: textTheme(context).bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (review.isVerifiedPurchase) ...[
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle,
                            size: Dimens.iconSizeExtraSmall,
                            color: AppColors.success),
                        const SizedBox(width: 4),
                        TextWidget(
                          'Verified purchase',
                          style: textTheme(context).bodySmall!.copyWith(
                                color: AppColors.grayMain,
                              ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            TextWidget(
              _relativeTime(review.createdAt),
              style: textTheme(context).bodySmall!.copyWith(
                    color: AppColors.grayMain,
                  ),
            ),
          ],
        ),
        const SizedBox(height: Dimens.spacingSizeSmall),
        StarRatingWidget(value: review.rating.toDouble()),
        if (review.title != null && review.title!.isNotEmpty) ...[
          const SizedBox(height: Dimens.spacingSizeExtraSmall),
          TextWidget(
            review.title!,
            style: textTheme(context).bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
        if (review.comment != null && review.comment!.isNotEmpty) ...[
          const SizedBox(height: Dimens.spacingSizeExtraSmall),
          TextWidget(
            review.comment!,
            style: textTheme(context).bodyMedium!,
          ),
        ],
        if (review.reply != null) ...[
          const SizedBox(height: Dimens.spacingSizeSmall),
          _SnippetReviewReply(reply: review.reply!),
        ],
      ],
    );
  }
}

// "Response from {storeName}" (VENDOR_REVIEW_REPLIES_PLAN.md §6) - indented
// under the review it answers, read-only here. The left border (rather than
// a filled card) keeps it visually subordinate to the review itself.
class _SnippetReviewReply extends StatelessWidget {
  const _SnippetReviewReply({required this.reply});

  final ReviewReply reply;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 40),
      padding: const EdgeInsets.only(left: Dimens.spacingSizeSmall),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: AppColors.grayLine, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextWidget(
                  'Response from ${reply.storeName}',
                  style: textTheme(context).bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              TextWidget(
                _relativeTime(reply.createdAt),
                style: textTheme(context).bodySmall!.copyWith(
                      color: AppColors.grayMain,
                    ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.spacingSizeExtraSmall),
          TextWidget(
            reply.body,
            style: textTheme(context).bodyMedium!,
          ),
        ],
      ),
    );
  }
}

String _relativeTime(DateTime date) {
  final diff = DateTime.now().difference(date.toLocal());
  if (diff.inDays >= 365) {
    final years = (diff.inDays / 365).floor();
    return '${years}y ago';
  }
  if (diff.inDays >= 30) {
    final months = (diff.inDays / 30).floor();
    return '${months}mo ago';
  }
  if (diff.inDays >= 1) return '${diff.inDays}d ago';
  if (diff.inHours >= 1) return '${diff.inHours}h ago';
  if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
  return 'Just now';
}
