import 'package:dio/dio.dart';
import 'dart:io';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/get_it_service_locator.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

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
  UrlPattern({required this.url, required this.token});
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
  String serverUrl;
  if (kIsWeb) {
    serverUrl = 'http://127.0.0.1:5000/api/';
  } else {
    serverUrl = 'http://10.0.2.2:5000/api/';
  }

  try {
    final response = await dio.get(serverUrl + compiledUrl);
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
  String serverUrl;
  if (kIsWeb) {
    serverUrl = 'http://127.0.0.1:5000/api/';
  } else {
    serverUrl = 'http://10.0.2.2:5000/api/';
  }

  try {
    final response =
        await dio.post(serverUrl + compiledUrl, data: json.encode(jsonData));
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
  "candidate_get_profile": UrlPattern(
    url: "candidate_get_profile/<id>",
    token: false,
  ),
  "candidate_update_profile": UrlPattern(
    url: "candidate_update_profile/<id>",
    token: false,
  ),
  "candidate_get_job_offer":
      UrlPattern(url: "candidate_get_job_offer/<j_o_id>", token: false),
  "candidate_get_job_offers":
      UrlPattern(url: "candidate_get_job_offers", token: false),
};
