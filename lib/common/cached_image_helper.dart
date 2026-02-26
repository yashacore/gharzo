import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const ColoredBox(color: Colors.black12);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,

      /// ⚡ FAST placeholder
      placeholder: (_, __) => const Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),

      /// ❌ Error fallback
      errorWidget: (_, __, ___) =>
      const Icon(Icons.broken_image, size: 40),

      /// ⚡ Memory optimization
      memCacheHeight: 600,
      memCacheWidth: 1000,
    );
  }
}