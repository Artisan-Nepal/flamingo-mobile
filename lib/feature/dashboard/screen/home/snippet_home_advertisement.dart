import 'package:flamingo/feature/advertisement/data/model/advertisement.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flutter/material.dart';

class SnippetHomeAdvertisement extends StatelessWidget {
  const SnippetHomeAdvertisement({
    super.key,
    required this.advertisement,
  });

  final Advertisement advertisement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImageWidget(image: advertisement.images.first.url),
        Text(advertisement.title),
        Text(advertisement.description),
      ],
    );
  }
}
