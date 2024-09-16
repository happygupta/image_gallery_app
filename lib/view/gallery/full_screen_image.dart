// This file contains the FullScreenImage widget, which displays a single image in full-screen mode.

import 'package:flutter/material.dart';
import 'package:image_gallery_app/model/image_item_model.dart';
import 'package:image_gallery_app/utils/widgets/common_widgets.dart';

class FullScreenImage extends StatelessWidget {
  // The ImageItem to be displayed in full-screen
  final ImageItem imageItem;

  // Constructor for the FullScreenImage widget
  const FullScreenImage({super.key, required this.imageItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // When the user taps anywhere on the screen, navigate back to the previous page
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            // Use a Hero widget for a smooth transition animation
            // The tag is set to the image's id for unique identification
            tag: imageItem.id,
            child: CacheNetworkImageWithManager(
              // Use a custom widget to load and cache the network image
              imageKey: imageItem.id.toString(),
              imageUrl: imageItem.largeImageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
