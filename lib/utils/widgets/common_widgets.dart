import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../constants/constants.dart';

class CacheNetworkImageWithManager extends StatelessWidget {
  final String imageUrl;
  final String imageKey;
  const CacheNetworkImageWithManager(
      {super.key, required this.imageUrl, required this.imageKey});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: Key(imageKey),
      imageUrl: imageUrl,
      placeholder: (context, url) => const SizedBox(
        height: 50.0,
        width: 50.0,
        child: Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: BoxFit.cover,
      cacheManager: CacheManager(
        Config(
          cacheKey,
          stalePeriod: const Duration(hours: 1),
          //one hour cache period
        ),
      ),
    );
  }
}
