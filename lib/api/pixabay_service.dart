import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_gallery_app/model/image_item_model.dart';

// This file contains the PixabayService class, which is responsible for fetching images from the Pixabay API.

class PixabayService {
  // The API key for accessing the Pixabay API. Replace 'YOUR_PIXABAY_API_KEY' with your actual API key.
  final String apiKey = 'YOUR_PIXABAY_API_KEY';

  // This method fetches images from the Pixabay API based on a search query and page number.
  Future<List<ImageItem>> fetchImages(String query, int page) async {
    // Construct the URL for the API request, including the API key, search query, page number, and number of results per page.
    final url =
        'https://pixabay.com/api/?key=$apiKey&q=$query&page=$page&per_page=50';

    // Send a GET request to the Pixabay API.
    final response = await http.get(Uri.parse(url));

    // Check if the request was successful (status code 200).
    if (response.statusCode == 200) {
      // Parse the JSON response.
      final data = jsonDecode(response.body);

      // Convert the 'hits' array in the response to a List of ImageItem objects.
      List<ImageItem> images = (data['hits'] as List)
          .map((item) => ImageItem.fromJson(item))
          .toList();

      // Return the list of ImageItem objects.
      return images;
    } else {
      // If the request was not successful, throw an exception.
      throw Exception('Failed to load images');
    }
  }
}
