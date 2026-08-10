import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/auth/screen/login/login_screen.dart';
import 'package:flamingo/feature/review/screen/product-reviews/product_review_view_model.dart';
import 'package:flamingo/feature/review/screen/product-reviews/review_list_screen.dart';
import 'package:flamingo/feature/review/screen/product-reviews/snippet_review_summary.dart';
import 'package:flamingo/feature/review/screen/product-reviews/snippet_review_tile.dart';
import 'package:flamingo/feature/review/screen/write-review/write_review_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Compact reviews block embedded on the PDP: summary + up to 2 preview
// tiles + entry points to the full list and the write-review form.
// Eligibility (purchase-gated - only customers with a delivered order can
// actually submit) is enforced by the backend on POST /reviews, not here -
// tapping through always opens the form, and an ineligible attempt surfaces
// the backend's rejection message via toast.
class SnippetProductReviews extends StatelessWidget {
  const SnippetProductReviews({
    super.key,
    required this.productId,
    required this.productTitle,
  });

  final String productId;
  final String productTitle;

  static const _previewCount = 2;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductReviewViewModel>(context);
    final summaryUseCase = viewModel.summaryUseCase;

    if (summaryUseCase.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: Dimens.spacingSizeLarge),
        child: DefaultScreenLoaderWidget(),
      );
    }
    if (summaryUseCase.hasError) return const SizedBox();

    final summary = summaryUseCase.data;
    final reviews = viewModel.reviewsUseCase.data?.rows ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              'Ratings & Reviews',
              style: textTheme(context).bodyLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (summary != null && summary.totalCount > 0)
              GestureDetector(
                onTap: () => NavigationHelper.push(
                  context,
                  ReviewListScreen(
                    productId: productId,
                    productTitle: productTitle,
                  ),
                ),
                child: Row(
                  children: [
                    TextWidget(
                      'See all',
                      style: textTheme(context).bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Icon(Icons.chevron_right, size: 16),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: Dimens.spacingSizeDefault),
        if (summary == null || summary.totalCount == 0) ...[
          TextWidget(
            'No reviews yet - be the first to review this product.',
            style: textTheme(context).bodyMedium!.copyWith(
                  color: AppColors.grayMain,
                ),
          ),
        ] else ...[
          SnippetReviewSummary(summary: summary),
          const SizedBox(height: Dimens.spacingSizeDefault),
          for (var i = 0; i < reviews.length && i < _previewCount; i++) ...[
            if (i > 0) ...[
              const SizedBox(height: Dimens.spacingSizeDefault),
              Divider(color: AppColors.grayLight),
              const SizedBox(height: Dimens.spacingSizeDefault),
            ],
            SnippetReviewTile(review: reviews[i]),
          ],
        ],
        const SizedBox(height: Dimens.spacingSizeDefault),
        OutlinedButtonWidget(
          height: 40,
          label: 'Write a review',
          onPressed: () => _onWriteReview(context),
        ),
      ],
    );
  }

  void _onWriteReview(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (!authViewModel.isLoggedIn) {
      NavigationHelper.push(context, LoginScreen(needContinueAsGuest: false));
      return;
    }
    NavigationHelper.push(
      context,
      WriteReviewScreen(productId: productId, productTitle: productTitle),
    );
  }
}
