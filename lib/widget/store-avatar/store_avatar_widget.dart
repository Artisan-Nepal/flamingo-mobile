import 'package:cached_network_image/cached_network_image.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

/// Circular store avatar that shows the store's uploaded picture
/// ([imageUrl]) when available, and otherwise falls back to a white badge with
/// the store's black initials derived from [name]. The initials are also shown
/// while the image loads or if it fails to load, so a missing/broken logo never
/// renders as an empty placeholder.
class StoreAvatarWidget extends StatelessWidget {
  const StoreAvatarWidget({
    super.key,
    required this.name,
    required this.size,
    this.imageUrl,
    this.fontSize,
  });

  final String name;
  final double size;
  final String? imageUrl;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final initials = _buildInitials();
    if (url == null || url.isEmpty) {
      return initials;
    }
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        // Decode at avatar size, not the store logo's full upload resolution -
        // see CachedNetworkImageWidget for why this matters. Square target, so
        // capping width alone is enough.
        memCacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round(),
        width: size,
        height: size,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 100),
        placeholder: (_, __) => initials,
        errorWidget: (_, __, ___) => initials,
      ),
    );
  }

  Widget _buildInitials() {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
      ),
      child: Text(
        _initialsFor(name),
        style: TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.w700,
          fontSize: fontSize ?? size * 0.4,
        ),
      ),
    );
  }

  static String _initialsFor(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final word = parts.first;
      return (word.length >= 2 ? word.substring(0, 2) : word).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
