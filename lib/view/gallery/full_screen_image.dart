import 'package:flutter/material.dart';
import 'package:image_gallery_app/model/image_item_model.dart';
import 'package:image_gallery_app/utils/widgets/common_widgets.dart';

class FullScreenImage extends StatelessWidget {
  final ImageItem imageItem;

  const FullScreenImage({super.key, required this.imageItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: imageItem.id,
            child: CacheNetworkImageWithManager(
              imageKey: imageItem.id.toString(),
              imageUrl: imageItem.largeImageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
