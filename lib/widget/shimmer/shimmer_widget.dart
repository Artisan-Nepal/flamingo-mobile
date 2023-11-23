import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final ShapeBorder shapeBorder;
  final bool smoothEdge;
  final double edgeRadius;

  const ShimmerWidget.rectangular({
    Key? key,
    required this.height,
    this.width = double.infinity,
    this.shapeBorder = const RoundedRectangleBorder(),
    this.smoothEdge = true,
    this.edgeRadius = 4,
  }) : super(key: key);

  const ShimmerWidget.circular({
    Key? key,
    required this.height,
    required this.width,
    this.shapeBorder = const CircleBorder(),
    this.smoothEdge = true,
    this.edgeRadius = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:
          isLightMode(context) ? AppColors.grayLighter : AppColors.grayMain,
      highlightColor:
          isLightMode(context) ? Colors.grey.shade100 : AppColors.grayLight,
      period: const Duration(milliseconds: 800),
      child: ClipRRect(
        borderRadius: smoothEdge
            ? BorderRadius.circular(edgeRadius)
            : BorderRadius.circular(0),
        child: Container(
          height: height,
          width: width,
          decoration: ShapeDecoration(
            color: isLightMode(context)
                ? AppColors.grayLighter
                : AppColors.grayMain,
            shape: shapeBorder,
          ),
        ),
      ),
    );
  }
}
