import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class SnippetOrderDetailInfo extends StatelessWidget {
  const SnippetOrderDetailInfo({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 50,
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
          Text(value)
        ],
      ),
    );
  }
}
