import 'package:flutter/material.dart';
import 'package:kicko/services/firebase.dart';
import 'package:provider/provider.dart';

Future<String> getProfileImage(Future<Map<String, dynamic>> imageIdGetter,
    String imagesBucket, BuildContext context) async {
  String bucket;

  Map<String, dynamic> imageIdContainer = await imageIdGetter;

  String? profileImageId = imageIdContainer['image_id'];

  if (profileImageId == null) {
    bucket = 'default';
    profileImageId = 'ca_default_profile.jpg';
  } else {
    bucket = imagesBucket;
  }

  return Provider.of<FireBaseServiceInterface>(context, listen: false)
      .downloadFile(bucket, profileImageId);
}
