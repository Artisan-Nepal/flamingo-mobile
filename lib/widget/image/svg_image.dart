import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgImageWidget extends StatelessWidget {
  final String image;
  final double width;
  final double height;
  final Color? color;
  const SvgImageWidget({
    super.key,
    required this.image,
    this.width = 200,
    this.height = 200,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      image,
      alignment: Alignment.center,
      colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).iconTheme.color!,
        BlendMode.srcIn,
      ),
      width: width,
      height: height,
    );
  }
}
