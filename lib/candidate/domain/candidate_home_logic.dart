import 'package:flutter/material.dart';
import 'package:kicko/shared/validator.dart';

class CandidateHomeLogic {
  final candidateForm = GlobalKey<FormState>();
  Validator validator = Validator();

  Map<String, dynamic> formatJobOfferFilters(Map jobOfferFilters) {
    Map<String, dynamic> newMap = {};
    for (var entry in jobOfferFilters.entries) {
      newMap[entry.key] =
          entry.value is TextEditingController ? entry.value.text : entry.value;
    }
    return newMap;
  }
}
