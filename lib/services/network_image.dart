import 'package:flutter/material.dart';

abstract class ImageNetworkServiceInterface {
  ImageProvider getImageProvider(String imageUrl);
}

class ImageNetworkService implements ImageNetworkServiceInterface {
  @override
  ImageProvider getImageProvider(String imageUrl) {
    return NetworkImage(imageUrl);
  }
}
