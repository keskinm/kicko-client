import 'dart:convert';

import 'package:kicko/dio.dart';
import 'package:dio/dio.dart';


class CandidateLogic {
  Future<Map> getCandidateSyntax({required String userGroup, required String userId}) async {
    Map bodyMap = {"id": userId, "user_group": userGroup};

    String body = json.encode(bodyMap);

    Response response = await dioHttpPost(
      route: 'get_candidate_syntax',
      jsonData: body,
      token: false,
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("CandidateLogic.getCandidateSyntax server error");
    }
  }
}

