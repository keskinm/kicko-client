import 'package:flutter/material.dart';
import 'package:kicko/shared/validator.dart';

import 'package:kicko/services/app_state.dart';
import '../../shared/common.dart';
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

  Map<String, dynamic> formatJobOfferFilters(Map jobOfferFilters) {
    Map<String, dynamic> newMap = {};
    for (var entry in jobOfferFilters.entries) {
      newMap[entry.key] =
          entry.value is TextEditingController ? entry.value.text : entry.value;
    }
    return newMap;
  }
}
