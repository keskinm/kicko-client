import 'package:dio/dio.dart';
import 'dart:io';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/get_it_service_locator.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

String getServerUrl() {
  String serverUrl;
  final String apiTargetEnv =
      const String.fromEnvironment('API_TARGET_ENV', defaultValue: 'dev');
  if (kIsWeb) {
    if (apiTargetEnv == "dev") {
      serverUrl = 'http://127.0.0.1:5000/api/';
    } else {
      serverUrl = 'https://shashou.pythonanywhere.com/api';
    }
  } else {
    serverUrl = 'http://10.0.2.2:5000/api/';
  }
  return serverUrl;
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

class UrlPattern {
  final String url;
  final bool token;
  final bool getData;
  UrlPattern({required this.url, this.token = false, this.getData = true});
}

Future<T> getRequest<T>(
  String url,
  List<dynamic> args,
) async {
  if (!urlPatterns.containsKey(url)) {
    throw Exception("URL pattern for '$url' not registered.");
  }

  final pattern = urlPatterns[url]!;
  String compiledUrl = pattern.url;
  for (var arg in args) {
    compiledUrl = compiledUrl.replaceFirst(RegExp("<[^>]+>"), arg);
  }

  Dio dio = getDio(token: pattern.token);

  try {
    final response = await dio.get(getServerUrl() + compiledUrl);
    if (!pattern.getData) {
      return response as T;
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("HTTP Error: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Network or parsing error: $e");
  }
}

Future<T> postRequest<T>(String url, List<dynamic> args, Map jsonData) async {
  if (!urlPatterns.containsKey(url)) {
    throw Exception("URL pattern for '$url' not registered.");
  }

  final pattern = urlPatterns[url]!;
  String compiledUrl = pattern.url;
  for (var arg in args) {
    compiledUrl = compiledUrl.replaceFirst(RegExp("<[^>]+>"), arg);
  }

  Dio dio = getDio(token: pattern.token);

  try {
    final response = await dio.post(getServerUrl() + compiledUrl,
        data: json.encode(jsonData));
    if (!pattern.getData) {
      return response as T;
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("HTTP Error: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Network or parsing error: $e");
  }
}

final Map<String, UrlPattern> urlPatterns = {
  // -----------GET METHODS-----------------
  "candidate_get_profile": UrlPattern(
    url: "candidate_get_profile/<id>",
  ),
  "professional_get_profile": UrlPattern(
    url: "professional_get_profile/<id>",
  ),
  "apply_job_offer":
      UrlPattern(url: "apply_job_offer/<candidate_id>/<job_offer_id>"),
  "applied_job_offer":
      UrlPattern(url: "applied_job_offer/<candidate_id>/<job_offer_id>"),
  "get_business": UrlPattern(url: "get_business/<pro_id>"),
  "professional_get_job_offers":
      UrlPattern(url: "professional_get_job_offers/<pro_id>"),
  "delete_account": UrlPattern(
      url: "delete_user_account/<userGroup>", token: true, getData: false),
  "get_current_user": UrlPattern(url: "user/<userGroup>", token: true),
  "get_candidate_syntax": UrlPattern(url: "get_candidate_syntax"),
  "candidate_get_job_offer":
      UrlPattern(url: "candidate_get_job_offer/<j_o_id>"),
  "professional_get_job_offer":
      UrlPattern(url: "professional_get_job_offer/<username_id>/<j_o_id>"),
  // -----------POST METHODS-----------------
  "candidate_update_profile": UrlPattern(
    url: "candidate_update_profile/<id>",
  ),
  "professional_update_profile": UrlPattern(
    url: "professional_update_profile/<id>",
  ),
  "candidate_get_job_offers": UrlPattern(url: "candidate_get_job_offers"),
  "delete_job_offer":
      UrlPattern(url: "delete_job_offer/<pro_id>/<job_offer_id>"),
  "professional_get_appliers":
      UrlPattern(url: "professional_get_appliers/<pro_id>"),
  "update_business_fields":
      UrlPattern(url: "update_business_fields/<professional_id>"),
  "user_register": UrlPattern(url: "<user_group>_register", getData: false),
  "authentication_token":
      UrlPattern(url: "user_authentication_token/<user_group>"),
  "add_job_offer": UrlPattern(url: "add_job_offer", getData: false),
};
