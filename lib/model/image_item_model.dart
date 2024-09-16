// This file defines the ImageItem model class, which represents an image from the Pixabay API.

import 'dart:convert';

// Function to convert a JSON string to an ImageItem object
ImageItem imageItemFromJson(String str) => ImageItem.fromJson(json.decode(str));

// Function to convert an ImageItem object to a JSON string
String imageItemToJson(ImageItem data) => json.encode(data.toJson());

// ImageItem class definition
class ImageItem {
  // Properties representing various attributes of an image
  int id;
  String pageUrl;
  String type;
  String tags;
  String previewUrl;
  int previewWidth;
  int previewHeight;
  String webformatUrl;
  int webformatWidth;
  int webformatHeight;
  String largeImageUrl;
  int imageWidth;
  int imageHeight;
  int imageSize;
  int views;
  int downloads;
  int collections;
  int likes;
  int comments;
  int userId;
  String user;
  String userImageUrl;

  // Constructor for the ImageItem class
  ImageItem({
    required this.id,
    required this.pageUrl,
    required this.type,
    required this.tags,
    required this.previewUrl,
    required this.previewWidth,
    required this.previewHeight,
    required this.webformatUrl,
    required this.webformatWidth,
    required this.webformatHeight,
    required this.largeImageUrl,
    required this.imageWidth,
    required this.imageHeight,
    required this.imageSize,
    required this.views,
    required this.downloads,
    required this.collections,
    required this.likes,
    required this.comments,
    required this.userId,
    required this.user,
    required this.userImageUrl,
  });

  // Factory constructor to create an ImageItem from a JSON map
  factory ImageItem.fromJson(Map<String, dynamic> json) => ImageItem(
        id: json["id"],
        pageUrl: json["pageURL"],
        type: json["type"],
        tags: json["tags"],
        previewUrl: json["previewURL"],
        previewWidth: json["previewWidth"],
        previewHeight: json["previewHeight"],
        webformatUrl: json["webformatURL"],
        webformatWidth: json["webformatWidth"],
        webformatHeight: json["webformatHeight"],
        largeImageUrl: json["largeImageURL"],
        imageWidth: json["imageWidth"],
        imageHeight: json["imageHeight"],
        imageSize: json["imageSize"],
        views: json["views"],
        downloads: json["downloads"],
        collections: json["collections"],
        likes: json["likes"],
        comments: json["comments"],
        userId: json["user_id"],
        user: json["user"],
        userImageUrl: json["userImageURL"],
      );

  // Method to convert an ImageItem object to a JSON map
  Map<String, dynamic> toJson() => {
        "id": id,
        "pageURL": pageUrl,
        "type": type,
        "tags": tags,
        "previewURL": previewUrl,
        "previewWidth": previewWidth,
        "previewHeight": previewHeight,
        "webformatURL": webformatUrl,
        "webformatWidth": webformatWidth,
        "webformatHeight": webformatHeight,
        "largeImageURL": largeImageUrl,
        "imageWidth": imageWidth,
        "imageHeight": imageHeight,
        "imageSize": imageSize,
        "views": views,
        "downloads": downloads,
        "collections": collections,
        "likes": likes,
        "comments": comments,
        "user_id": userId,
        "user": user,
        "userImageURL": userImageUrl,
      };
}
