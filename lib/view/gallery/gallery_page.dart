// This file contains the GalleryPage widget, which is the main screen of the image gallery app.

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_app/api/pixabay_service.dart';
import 'package:image_gallery_app/model/image_item_model.dart';
import 'package:image_gallery_app/utils/constants/constants.dart';
import 'package:image_gallery_app/utils/widgets/common_widgets.dart';
import 'package:image_gallery_app/view/gallery/full_screen_image.dart';

// GalleryPage is a StatefulWidget that displays a grid of images fetched from the Pixabay API.
class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

// _GalleryPageState manages the state of the GalleryPage.
class _GalleryPageState extends State<GalleryPage> {
  final PixabayService pixabayService = PixabayService();
  List<ImageItem> images = [];
  int currentPage = 1;
  bool isLoading = false;
  String searchQuery = '';

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchImages();
    // Set up scroll listener for infinite scrolling
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading) {
        _fetchImages();
      }
    });
  }

  // Fetches images from the Pixabay API
  void _fetchImages() async {
    setState(() {
      isLoading = true;
    });
    List<ImageItem> newImages =
        await pixabayService.fetchImages(searchQuery, currentPage);
    setState(() {
      images.addAll(newImages);
      currentPage++;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // Clean up resources when the widget is disposed
    DefaultCacheManager().removeFile(cacheKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Search bar in the app bar
        title: TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value;
              currentPage = 1;
              images.clear();
              _fetchImages();
            });
          },
          decoration: const InputDecoration(
            hintText: 'Search images...',
          ),
        ),
      ),
      // Grid view of images
      body: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final imageData = images[index];
          return GestureDetector(
            onTap: () => _openImageDetail(imageData),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Stack(
                alignment: AlignmentDirectional.center,
                fit: StackFit.expand,
                children: [
                  // Displays the image with caching
                  Hero(
                      tag: imageData.id,
                      child: CacheNetworkImageWithManager(
                        imageKey: imageData.id.toString(),
                        imageUrl: imageData.previewUrl,
                      )),
                  // Overlay with likes and views information
                  Positioned(
                    bottom: 0,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: const BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Icon(
                            Icons.favorite_sharp,
                            color: Colors.red,
                          ),
                          Text(' ${imageData.likes}'),
                          const SizedBox(
                            width: 4,
                          ),
                          const Icon(
                            Icons.remove_red_eye,
                            color: Colors.blue,
                          ),
                          Text(' ${imageData.views}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Opens the full screen view of the selected image
  void _openImageDetail(ImageItem imageItem) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FullScreenImage(imageItem: imageItem)));
  }
}
