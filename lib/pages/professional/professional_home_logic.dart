import 'dart:convert';

import 'package:kicko/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kicko/pages/professional/models.dart';
import 'package:kicko/pages/professional/professional_home_page.dart';
import 'package:kicko/widgets/forms/validator.dart';

import 'package:kicko/services/app_state.dart';
import 'package:kicko/services/database.dart';

import 'package:kicko/pages/common.dart';

class ProfessionalHomeLogic {
  final jobOfferForm = GlobalKey<FormState>();
  final businessForm = GlobalKey<FormState>();

  Validator validator = Validator();
  Map<String, dynamic> jobOfferJson = {};
  Map<String, dynamic> businessJson = {};

  Future<void> validateBusiness({required BuildContext context}) async {
    if (businessForm.currentState!.validate()) {
      Business business = Business.fromJson(businessJson);
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
                  "Nous avons rencontré un problème lors de la mise à jour de votre offre d'emploi.",
                  "oups",
                  "fermer");
            });
      }
    }
  }

  Future<void> validateJobOffer({required BuildContext context}) async {
    if (jobOfferForm.currentState!.validate()) {
      jobOfferJson["business_id"] = businessJson["id"];
      JobOffer jobOffer = JobOffer.fromJson(jobOfferJson);
      bool success = await jobOffer.addJobOffer();

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProHome()),
        );
      } else {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return buildPopupDialog(
                  context,
                  "Nous avons rencontré un problème lors de la création de votre offre d'emploi.",
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

  Future<Map<String, dynamic>> getBusiness() async {
    String userId = appState.currentUser.id;
    String body = '{"professional_id": "$userId"}';
    Response response = await dioHttpPost(
      route: 'get_business',
      jsonData: body,
      token: false,
    );
    // Map<String, String> jsonResponse = json.decode(response.data);
    return response.data;
  }

  Future<String> getProfileImage(
      Future<Map<String, dynamic>> futureBusinessJson,
      String imagesBucket) async {
    String bucket;

    Map<String, dynamic> businessJson = await futureBusinessJson;

    String? profileImageId = businessJson['image_id'];

    if (profileImageId == null) {
      bucket = 'default';
      profileImageId = 'ca_default_profile.jpg';
    } else {
      bucket = imagesBucket;
    }

    return DatabaseMethods().downloadFile(bucket, profileImageId);
  }

  Future<List> getJobOffers() async {
    String userId = appState.currentUser.id;
    String body = '{"professional_id": "$userId"}';
    Response response = await dioHttpPost(
      route: 'professional_get_job_offers',
      jsonData: body,
      token: false,
    );
    return response.data;
  }

  Future<List> appliers(
      {required String jobOfferId, Map filters = const {}}) async {
    Map jobOfferIdMap = {"professional_id": jobOfferId};
    Map bodyMap = {...jobOfferIdMap, ...filters};

    String body = json.encode(bodyMap);

    Response response = await dioHttpPost(
      route: 'professional_get_appliers',
      jsonData: body,
      token: false,
    );
    return response.data;
  }

  Future<bool> deleteJobOffer(String jobOfferId) async {
    String userId = appState.currentUser.id;
    String body = '{"professional_id": "$userId", "id": "$jobOfferId"}';
    Response response = await dioHttpPost(
      route: 'delete_job_offer',
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
