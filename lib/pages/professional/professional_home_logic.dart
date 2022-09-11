import 'package:kicko/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kicko/pages/professional/professional_home_page.dart';
import 'package:kicko/widgets/forms/validator.dart';

import '../../services/app_state.dart';

class ProfessionalHomeLogic {
  final formKey = GlobalKey<FormState>();

  Validator validator = Validator();
  late String jobOfferName;
  late String jobOfferDescription;
  late String jobOfferRequires;

  void setAttr(String name, value) {
    switch (name) {
      case "jobOfferName":
        {
          jobOfferName = value;
        }
        break;

      case "jobOfferDescription":
        {
          jobOfferDescription = value;
        }
        break;

      case "jobOfferRequires":
        {
          jobOfferRequires = value;
        }
        break;
    }
  }

  Future<void> validateJobOffer({required BuildContext context}) async {
    if (formKey.currentState!.validate()) {
      bool success = await addJobOffer(
          jobOfferName: jobOfferName,
          jobOfferDescription: jobOfferDescription,
          jobOfferRequires: jobOfferRequires);

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

  String? nonNullable({required String? value, required String key}) {
    if (!validator.nonNullable(value: value)) {
      return 'Le champ ne doit pas être vide.';
    } else {
      setAttr(key, value);
      return null;
    }
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

  Future<bool> addJobOffer(
      {required String jobOfferName,
      required String jobOfferDescription,
      required String jobOfferRequires}) async {
    String userId = appState.currentUser.id;
    String body =
        '{"name": "$jobOfferName", "description":"$jobOfferDescription", "requires":"$jobOfferRequires", "user_id": "$userId"}';
    Response response = await dioHttpPost(
      route: 'add_job_offer',
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
