import 'package:flamingo/shared/util/util.dart';
import 'package:flutter/material.dart';

class ExpansionTileWidget extends StatelessWidget {
  const ExpansionTileWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.initiallyExpanded = false,
    required this.children,
  });

  final Widget title;
  final Widget? subtitle;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
        dividerColor: AppColors.transparent,
      ),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        title: title,
        subtitle: subtitle,
        tilePadding: EdgeInsets.all(0),
        childrenPadding: EdgeInsets.all(0),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.centerLeft,
        children: children,
      ),
    );
  }
}
