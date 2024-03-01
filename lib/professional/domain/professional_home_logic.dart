import 'package:flutter/material.dart';
import 'package:kicko/professional/domain/models.dart';
import 'package:kicko/professional/ui/professional_home_page.dart';
import 'package:kicko/shared/validator.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/services/firebase.dart';
import 'package:kicko/shared/common.dart';

class ProfessionalHomeLogic {
  final jobOfferForm = GlobalKey<FormState>();
  final businessForm = GlobalKey<FormState>();

  Validator validator = Validator();
  Map<String, dynamic> jobOfferJson = {};
  Map<String, dynamic> businessJson = {};

  Future<void> validateBusiness({required BuildContext context}) async {
    if (businessForm.currentState!.validate()) {
      Business business = Business.fromJson(businessJson);
      Map res = await business.updateFields(userId: appState.currentUser.id);

      if (res.containsKey("success") && res["success"]) {
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
      bool success = await jobOffer.addJobOffer(context);

      if (success) {
        Navigator.pushReplacement(
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

  Future<String> getProfileImage(
      Future<Map<String, dynamic>> futureBusinessJson,
      String imagesBucket,
      BuildContext context) async {
    String bucket;

    Map<String, dynamic> businessJson = await futureBusinessJson;

    String? profileImageId = businessJson['image_id'];

    if (profileImageId == null) {
      bucket = 'default';
      profileImageId = 'ca_default_profile.jpg';
    } else {
      bucket = imagesBucket;
    }

    return FireBaseService().downloadFile(bucket, profileImageId);
  }
}
