import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/get_it_service_locator.dart';

// MIGRATE TO end_point.dart !!!

Future<Response> dioHttpPost(
    {required String route,
    required String jsonData,
    required bool token}) async {
  Dio dio = getDio(token: token);
  String serverUrl;
  if (kIsWeb) {
    serverUrl = 'http://127.0.0.1:5000/api/';
  } else {
    serverUrl = 'http://10.0.2.2:5000/api/';
  }
  return await dio.post(serverUrl + route, data: jsonData);
}

Dio getDio({required bool token}) {
  final dio = getIt<Dio>();
  dio.options = BaseOptions(
      followRedirects: false,
      headers: token
          ? {
              HttpHeaders.authorizationHeader:
                  'Bearer ${appState.currentUser.token}',
              HttpHeaders.contentTypeHeader: 'application/json'
            }
          : {'content-Type': 'application/json'},
      validateStatus: (status) {
        return status! <= 500;
      });
  return dio;
}
