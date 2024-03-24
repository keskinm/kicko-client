import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:kicko/user/ui/medias.dart';
import 'package:kicko/shared/route.dart';

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

Widget UIImage(String imageUrl, BuildContext context, String imagesBucket,
    String updateRoute, Function onReBuild) {
  return Stack(
    children: [
      PageCircleAvatar(
        imageUrl: imageUrl,
        imageService:
            Provider.of<ImageNetworkServiceInterface>(context, listen: false),
      ),
      Positioned(
        bottom: 1,
        right: 1,
        child: Container(
          child: IconButton(
            icon: const Icon(Icons.add_a_photo, color: Colors.black),
            onPressed: () {
              pushSetStateWhenBack(
                  context,
                  (context) => DisplayProfileImages(
                        bucket: imagesBucket,
                        updateRoute: updateRoute,
                      ),
                  onReBuild);
            },
          ),
          decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: Colors.white,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  50,
                ),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(2, 4),
                  color: Colors.black.withOpacity(
                    0.3,
                  ),
                  blurRadius: 3,
                ),
              ]),
        ),
      ),
    ],
  );
}
