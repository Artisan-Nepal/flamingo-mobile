import 'package:flamingo/feature/review/data/model/review_filter_params.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/bottom-sheet/bottom_sheet_widget.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';

class SnippetReviewSortSheet extends StatelessWidget {
  const SnippetReviewSortSheet({super.key, required this.selected});

  final ReviewSort selected;

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      topContent: TextWidget(
        'Sort by',
        style: textTheme(context).bodyLarge!.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: ReviewSort.values.map((sort) {
          final isSelected = sort == selected;
          return ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () => Navigator.pop(context, sort),
            title: TextWidget(
              sort.label,
              style: textTheme(context).bodyMedium!.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : null,
                  ),
            ),
            trailing: isSelected
                ? Icon(Icons.check, color: themedPrimaryColor(context))
                : null,
          );
        }).toList(),
      ),
    );
  }
}
