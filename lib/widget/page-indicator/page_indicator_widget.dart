import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class PageIndicatorWidget extends StatelessWidget {
  const PageIndicatorWidget(
      {super.key, required this.length, required this.currentIndex});
  final int length;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) {
          return Center(
            child: buildDot(
              index == currentIndex,
            ),
          );
        },
      ),
    );
  }

  Widget buildDot(bool isActive) {
    return Container(
      width: 10.0,
      height: 10.0,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: isActive ? AppColors.secondaryMain : AppColors.grayLight,
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}
