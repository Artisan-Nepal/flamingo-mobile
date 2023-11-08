import 'package:flamingo/widget/text/text.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flamingo/shared/shared.dart';

class DescriptionCard extends StatelessWidget {
  final double verticalSpaceHeight;
  final String label;
  final String value;

  DescriptionCard({
    required this.verticalSpaceHeight,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalSpaceWidget(height: verticalSpaceHeight),
        Wrap(
          children: [
            TextWidget(
              label,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextWidget(
              value,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
