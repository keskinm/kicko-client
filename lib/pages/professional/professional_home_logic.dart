import 'package:kicko/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kicko/pages/professional/models.dart';
import 'package:kicko/pages/professional/professional_home_page.dart';
import 'package:kicko/widgets/forms/validator.dart';

import '../../services/app_state.dart';

class ProfessionalHomeLogic {
  final jobOfferForm = GlobalKey<FormState>();
  final businessForm = GlobalKey<FormState>();

  Validator validator = Validator();
  Map<String, dynamic> jobOfferJson = {};
  Map<String, dynamic> businessJson = {};

  Future<void> validateBusiness({required BuildContext context}) async {
    if (businessForm.currentState!.validate()) {

      Business business = Business.fromJson(businessJson);
      bool success = await business.updateFields(userId: appState.currentUser.id);

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProHome()),
        );
      } else {
        buildPopupDialog(context,
            "Nous avons rencontré un problème lors de la validation de votre offre d'emploi.");
      }
    }
  }

  Future<void> validateJobOffer({required BuildContext context}) async {
    if (jobOfferForm.currentState!.validate()) {

      JobOffer jobOffer = JobOffer.fromJson(jobOfferJson);
      bool success = await jobOffer.addJobOffer(userId: appState.currentUser.id);

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProHome()),
        );
      } else {
        buildPopupDialog(context,
            "Nous avons rencontré un problème lors de la validation de votre offre d'emploi.");
      }
    }
  }

  Widget buildPopupDialog(BuildContext context, String message) {
    return AlertDialog(
      title: const Text('Oups !'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(message),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fermer'),
        ),
      ],
    );
  }

  String? nonNullable({required String? value, required String key, required Map jsonModel}) {
    if (!validator.nonNullable(value: value)) {
      return 'Le champ ne doit pas être vide.';
    } else {
      jsonModel[key] = value;
      return null;
    }
  }

  Future<Map<String, dynamic>> getBusiness() async {
    String userId = appState.currentUser.id;
    String body = '{"user_id": "$userId"}';
    Response response = await dioHttpPost(
      route: 'get_business',
      jsonData: body,
      token: false,
    );
    // Map<String, String> jsonResponse = json.decode(response.data);
    return response.data;
  }

  Future<List> getJobOffers() async {
    String userId = appState.currentUser.id;
    String body = '{"user_id": "$userId"}';
    Response response = await dioHttpPost(
      route: 'get_job_offers',
      jsonData: body,
      token: false,
    );
    return response.data;
  }

  Future<bool> deleteJobOffer(String jobOfferId) async {
    String userId = appState.currentUser.id;
    String body = '{"user_id": "$userId", "id": "$jobOfferId"}';
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
