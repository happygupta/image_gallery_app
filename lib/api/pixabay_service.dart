import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_gallery_app/model/image_item_model.dart';

class PixabayService {
  final String apiKey = 'YOUR_PIXABAY_API_KEY';

  Future<List<ImageItem>> fetchImages(String query, int page) async {
    final url =
        'https://pixabay.com/api/?key=$apiKey&q=$query&page=$page&per_page=50';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<ImageItem> images = (data['hits'] as List)
          .map((item) => ImageItem.fromJson(item))
          .toList();
      return images;
    } else {
      throw Exception('Failed to load images');
    }
  }
}
