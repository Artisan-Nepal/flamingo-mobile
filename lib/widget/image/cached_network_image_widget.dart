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
    this.fadeDuration = const Duration(milliseconds: 100),
  }) : super(key: key);
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool needPlaceHolder;
  final String placeHolder;
  final Duration fadeDuration;

  @override
  Widget build(BuildContext context) {
    // Cap the DECODE size. A decoded image costs width*height*4 bytes of RAM
    // regardless of how small it's drawn, so a 1800x2400 product photo costs
    // ~16.5MB per copy even in a small grid tile. Without this the app walked
    // up to iOS's ~3GB per-process limit and got jetsam-killed while scrolling
    // (see the OOM investigation, 2026-07-31).
    //
    // Only ONE dimension is ever passed: ResizeImage stretches to fit when both
    // are given, so capping a single axis is what preserves the aspect ratio.
    // Falls back to the screen width so full-bleed images (no explicit size)
    // are still bounded - the cap must hold no matter what a vendor uploads.
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    int? decodeWidth;
    int? decodeHeight;
    if (width != null && width!.isFinite) {
      decodeWidth = (width! * devicePixelRatio).round();
    } else if (height != null && height!.isFinite) {
      decodeHeight = (height! * devicePixelRatio).round();
    } else {
      decodeWidth = (MediaQuery.sizeOf(context).width * devicePixelRatio).round();
    }

    return CachedNetworkImage(
      memCacheWidth: decodeWidth,
      memCacheHeight: decodeHeight,
      fadeInDuration: fadeDuration,
      fadeOutDuration: fadeDuration,
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
