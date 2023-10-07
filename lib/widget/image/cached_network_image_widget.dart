import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flamingo/shared/constant/image_constants.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  const CachedNetworkImageWidget({
    Key? key,
    required this.image,
    this.height,
    this.width,
    this.fit,
    this.needPlaceHolder = true,
    this.placeHolder = ImageConstants.imagePlaceholder,
  }) : super(key: key);
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool needPlaceHolder;
  final String placeHolder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeInDuration: const Duration(milliseconds: 10),
      fadeOutDuration: const Duration(milliseconds: 10),
      placeholder: (context, _) {
        return needPlaceHolder
            ? Image.asset(
                placeHolder,
                fit: BoxFit.cover,
                height: height,
                width: width,
              )
            : const SizedBox();
      },
      fit: fit,
      imageUrl: image,
      errorWidget: (context, error, stackTrace) => needPlaceHolder
          ? Image.asset(
              placeHolder,
              fit: BoxFit.cover,
              height: height,
              width: width,
            )
          : const SizedBox(),
      height: height,
      width: width,
    );
  }
}
