// This file contains a custom widget for efficiently loading and caching network images.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../constants/constants.dart';

// CacheNetworkImageWithManager is a StatelessWidget that uses CachedNetworkImage
// with a custom CacheManager for improved performance and user experience.
class CacheNetworkImageWithManager extends StatelessWidget {
  final String imageUrl; // URL of the image to be loaded
  final String imageKey; // Unique key for the image, used for caching

  // Constructor requiring imageUrl and imageKey
  const CacheNetworkImageWithManager(
      {super.key, required this.imageUrl, required this.imageKey});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: Key(imageKey), // Unique key for the widget
      imageUrl: imageUrl, // URL of the image to load
      placeholder: (context, url) => const SizedBox(
        height: 50.0,
        width: 50.0,
        child: Center(child: CircularProgressIndicator()),
      ), // Shown while the image is loading
      errorWidget: (context, url, error) =>
          const Icon(Icons.error), // Shown if image fails to load
      fit: BoxFit.cover, // Image scaling mode
      cacheManager: CacheManager(
        Config(
          cacheKey,
          stalePeriod: const Duration(hours: 1), // Cache validity period
        ),
      ), // Custom cache manager for improved caching
    );
  }
}
