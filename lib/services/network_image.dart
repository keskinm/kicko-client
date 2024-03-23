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

class CustomCircleAvatar extends StatelessWidget {
  final String imageUrl;
  final ImageNetworkServiceInterface imageService;

  const CustomCircleAvatar({
    Key? key,
    required this.imageUrl,
    required this.imageService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image(
        image: imageService.getImageProvider(imageUrl),
        fit: BoxFit.cover,
      ),
    );
  }
}

class PageCircleAvatar extends StatelessWidget {
  final String imageUrl;
  final ImageNetworkServiceInterface imageService;

  const PageCircleAvatar({
    Key? key,
    required this.imageUrl,
    required this.imageService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: ClipOval(
        child: Image(
          image: imageService.getImageProvider(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
