import 'package:kicko/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kicko/widgets/forms/validator.dart';


class JobOfferLogic {
  final candidateForm = GlobalKey<FormState>();

  Validator validator = Validator();
  Map<String, dynamic> businessJson = {};

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
      throw Exception("JobOfferLogic.getJobOffer server error");
    }
  }

}
