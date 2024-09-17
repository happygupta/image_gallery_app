// This file contains the GalleryPage widget, which is the main screen of the image gallery app.

// Import necessary packages and files
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_app/api/pixabay_service.dart';
import 'package:image_gallery_app/model/image_item_model.dart';
import 'package:image_gallery_app/utils/constants/constants.dart';
import 'package:image_gallery_app/utils/widgets/common_widgets.dart';
import 'package:image_gallery_app/view/gallery/full_screen_image.dart';

// Define GalleryPage as a StatefulWidget
class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

// Define _GalleryPageState to manage the state of GalleryPage
class _GalleryPageState extends State<GalleryPage> {
  // Initialize variables for API service, image list, pagination, loading state, and search
  final PixabayService pixabayService = PixabayService();
  List<ImageItem> images = [];
  int currentPage = 1;
  bool isLoading = false;
  String searchQuery = '';

  // Timer for debouncing search input
  Timer? _debounce;

  // ScrollController for implementing infinite scrolling
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch initial images and set up scroll listener for infinite scrolling
    _fetchImages();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading) {
        _fetchImages();
      }
    });
  }

  // Method to fetch images from the Pixabay API
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

  // Method to handle search input changes
  void onSearchValueChange(value) {
    setState(() {
      searchQuery = value;
    });
    // Implement debounce to avoid excessive API calls
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      setState(() {
        currentPage = 1;
        images.clear();
        _fetchImages();
      });
    });
  }

  @override
  void dispose() {
    // Clean up resources when the widget is disposed
    DefaultCacheManager().removeFile(cacheKey);
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with search functionality
      appBar: AppBar(
        title: TextField(
          onChanged: onSearchValueChange,
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
                  // Display image with caching using Hero widget for smooth transitions
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
                          const Icon(Icons.favorite_sharp, color: Colors.red),
                          Text(' ${imageData.likes}'),
                          const SizedBox(width: 4),
                          const Icon(Icons.remove_red_eye, color: Colors.blue),
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

  // Method to open full screen view of the selected image
  void _openImageDetail(ImageItem imageItem) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FullScreenImage(imageItem: imageItem)));
  }
}
