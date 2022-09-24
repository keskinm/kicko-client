import 'package:kicko/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kicko/widgets/forms/validator.dart';

import 'package:kicko/services/app_state.dart';
import 'package:kicko/services/database.dart';

import '../common.dart';
import 'models.dart';

class CandidateHomeLogic {
  final candidateForm = GlobalKey<FormState>();

  Validator validator = Validator();
  Map<String, dynamic> businessJson = {};

  Future<void> validateBusiness({required BuildContext context}) async {
    if (candidateForm.currentState!.validate()) {
      Candidate business = Candidate.fromJson(businessJson);
      bool success =
          await business.updateFields(userId: appState.currentUser.id);

      if (success) {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return buildPopupDialog(
                  context,
                  "Vos paramètres ont été mise à jour avec succes !",
                  "Bonne nouvelle !",
                  "Fermer");
            });
      } else {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return buildPopupDialog(
                  context,
                  "Nous avons rencontré un problème lors de la suppression de votre offre d'emploi.",
                  "oups",
                  "fermer");
            });
      }
    }
  }

  String? nonNullable(
      {required String? value, required String key, required Map jsonModel}) {
    if (!validator.nonNullable(value: value)) {
      return 'Le champ ne doit pas être vide.';
    } else {
      jsonModel[key] = value;
      return null;
    }
  }

  Future<Map<String, dynamic>> getCandidate() async {
    Response response = await dioHttpPost(
      route: '',
      jsonData: '',
      token: false,
    );
    return response.data;
  }

  Future<String> getProfileImage(
      Future<Map<String, dynamic>> futureBusinessJson) async {
    String bucket;

    Map<String, dynamic> businessJson = await futureBusinessJson;

    String? profileImageId = businessJson['image_id'];

    if (profileImageId == null) {
      bucket = 'business_images';
      profileImageId = 'ca_default_profile.jpg';
    } else {
      String currentUsername = appState.currentUser.username;
      bucket = 'business_images/$currentUsername';
    }

    return DatabaseMethods().downloadFile(bucket, profileImageId);
  }

  Future<Map> getProfile() async {
    String userId = appState.currentUser.id;
    String body = '{"id": "$userId"}';

    Response response = await dioHttpPost(
      route: 'candidate_get_profile',
      jsonData: body,
      token: false,
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("getProfile HTTP Error");
    }
  }

  Future<List> getJobOffers(Map jobOfferFilters) async {
    String body = '{';

    jobOfferFilters.forEach((key, value) {
      if (value is TextEditingController) {
        value = value.text;
      }
      if (!value.isEmpty) {
        body = body + '"$key":"$value", ';
      }
    });

    if (body.endsWith(", "))
    // THROW THE COMMA
    {
      body = body.substring(0, body.length - 2);
    }

    body = body + '}';

    Response response = await dioHttpPost(
      route: 'candidate_get_job_offers',
      jsonData: body,
      token: false,
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return [
        {"error": true}
      ];
    }
  }

  Future<Map> getJobOffer({required String jobOfferId}) async {
    String body = '{"id": "$jobOfferId"}';

    Response response = await dioHttpPost(
      route: 'candidate_get_job_offer',
      jsonData: body,
      token: false,
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return {"error": true};
    }
  }

  Future<bool> appliedJobOffer({required String jobOfferId}) async {
    String userId = appState.currentUser.id;
    String body = '{"candidate_id": "$userId", "job_offer_id": "$jobOfferId"}';

    Response response = await dioHttpPost(
      route: 'applied_job_offer',
      jsonData: body,
      token: false,
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      // @todo DONT FORGET TO CATCH THIS
      throw Exception('HTTP ERROR');
    }
  }

  Future<bool> applyJobOffer({required String jobOfferId}) async {
    String userId = appState.currentUser.id;
    String body = '{"candidate_id": "$userId", "job_offer_id": "$jobOfferId"}';

    Response response = await dioHttpPost(
      route: 'apply_job_offer',
      jsonData: body,
      token: false,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
