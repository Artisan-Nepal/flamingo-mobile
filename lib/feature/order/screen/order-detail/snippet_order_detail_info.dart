import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class SnippetOrderDetailInfo extends StatelessWidget {
  const SnippetOrderDetailInfo({
    Key? key,
    required this.label,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  final String label;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme(context)
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Text(title),
          if (subtitle != null) Text(subtitle!)
        ],
      ),
    );
  }
}
