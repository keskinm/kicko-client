import 'package:flutter/material.dart';
import 'package:kicko/services/network_image.dart';

class MockImageNetworkService implements ImageNetworkServiceInterface {
  @override
  ImageProvider getImageProvider(String imageUrl) {
    return AssetImage('assets/images/PNG_transparency_demonstration_1.png');
  }
}
