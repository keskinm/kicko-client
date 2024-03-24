import 'package:flutter/material.dart';
import 'package:kicko/professional/domain/models.dart';
import 'package:kicko/professional/ui/professional_home_page.dart';
import 'package:kicko/shared/validator.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/services/firebase.dart';
import 'package:kicko/shared/common.dart';
import 'package:provider/provider.dart';

class AccountLogic {
  Future<String> getProfileImage(Future<Map<String, dynamic>> profile,
      String imagesBucket, BuildContext context) async {
    String bucket;

    Map<String, dynamic> profileJson = await profile;

    String? profileImageId = profileJson['image_id'];

    if (profileImageId == null) {
      bucket = 'default';
      profileImageId = 'ca_default_profile.jpg';
    } else {
      bucket = imagesBucket;
    }

    return Provider.of<FireBaseServiceInterface>(context, listen: false)
        .downloadFile(bucket, profileImageId);
  }
}
