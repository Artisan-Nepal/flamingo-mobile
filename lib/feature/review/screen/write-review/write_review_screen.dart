import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/review/screen/write-review/write_review_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/alert-dialog/alert_dialog_widget.dart';
import 'package:flamingo/widget/button/variants/text_button_widget.dart';
import 'package:flamingo/widget/loader/default_screen_loader_widget.dart';
import 'package:flamingo/widget/rating/star_rating_input.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _commentMaxLength = 1000;

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({
    super.key,
    required this.productId,
    required this.productTitle,
  });

  final String productId;
  final String productTitle;

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _viewModel = locator<WriteReviewViewModel>();
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();

  // Guards the one-time seed of the text controllers once prefillFor()
  // resolves an existing review - without it, every rebuild would stomp
  // whatever the user has already typed.
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _viewModel.prefillFor(widget.productId);
    _commentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: Consumer<WriteReviewViewModel>(
        builder: (context, viewModel, child) {
          if (!_seeded && viewModel.myReviewUseCase.hasCompleted) {
            _seeded = true;
            _titleController.text = viewModel.existingReview?.title ?? '';
            _commentController.text = viewModel.existingReview?.comment ?? '';
          }
          return TitledScreen(
            title: viewModel.isEditing ? 'Edit your review' : 'Write a review',
            child: viewModel.myReviewUseCase.isLoading
                ? const DefaultScreenLoaderWidget()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        widget.productTitle,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                        style: textTheme(context).bodyMedium!.copyWith(
                              color: AppColors.grayMain,
                            ),
                      ),
                      const SizedBox(height: Dimens.spacingSizeLarge),
                      TextWidget(
                        'Your rating',
                        style: textTheme(context).bodyMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: Dimens.spacingSizeSmall),
                      StarRatingInput(
                        value: viewModel.rating,
                        onChanged: viewModel.setRating,
                      ),
                      const SizedBox(height: Dimens.spacingSizeLarge),
                      TextFieldWidget(
                        label: 'Title (optional)',
                        controller: _titleController,
                        hintText: 'Sum up your review',
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: Dimens.spacingSizeLarge),
                      TextFieldWidget(
                        label: 'Your review (optional)',
                        controller: _commentController,
                        hintText: 'What did you like or dislike?',
                        maxLines: 5,
                        maxLength: _commentMaxLength,
                        textInputAction: TextInputAction.newline,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextWidget(
                          '${_commentController.text.length} / $_commentMaxLength',
                          style: textTheme(context).bodySmall!.copyWith(
                                color: AppColors.grayMain,
                              ),
                        ),
                      ),
                      const SizedBox(height: Dimens.spacingSizeLarge),
                      FilledButtonWidget(
                        label: 'Submit review',
                        enabled: viewModel.canSubmit,
                        isLoading: viewModel.submitUseCase.isLoading,
                        onPressed: () => _onSubmit(viewModel),
                      ),
                      if (viewModel.isEditing) ...[
                        const SizedBox(height: Dimens.spacingSizeSmall),
                        Center(
                          child: TextButtonWidget(
                            label: 'Delete review',
                            isLoading: viewModel.deleteUseCase.isLoading,
                            onPressed: () => _onDelete(viewModel),
                          ),
                        ),
                      ],
                    ],
                  ),
          );
        },
      ),
    );
  }

  Future<void> _onSubmit(WriteReviewViewModel viewModel) async {
    await viewModel.submit(
      productId: widget.productId,
      title: _titleController.text.trim(),
      comment: _commentController.text.trim(),
    );
    if (!mounted) return;
    if (viewModel.submitUseCase.hasCompleted) {
      NavigationHelper.pop(context);
      showToast(context, message: 'Review submitted', isSuccess: true);
    } else {
      showToast(context,
          message: viewModel.submitUseCase.exception, isSuccess: false);
    }
  }

  void _onDelete(WriteReviewViewModel viewModel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialogWidget(
        title: 'Delete this review?',
        description: 'This cannot be undone.',
        needSecondButton: true,
        firstButtonLabel: 'Delete',
        firstButtonOnPressed: () async {
          Navigator.pop(ctx);
          await viewModel.delete();
          if (!mounted) return;
          if (viewModel.deleteUseCase.hasCompleted) {
            NavigationHelper.pop(context);
            showToast(context, message: 'Review deleted', isSuccess: true);
          } else {
            showToast(context,
                message: viewModel.deleteUseCase.exception, isSuccess: false);
          }
        },
      ),
    );
  }
}
