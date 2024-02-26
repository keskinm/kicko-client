import 'package:flutter_test/flutter_test.dart';
import 'package:kicko/end_point.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:kicko/get_it_service_locator.dart';
import 'dart:convert';

void main() {
  late DioAdapter dioAdapter;

  setUpAll(() async {
    Dio dio = Dio();
    getIt.registerLazySingleton<Dio>(() => dio);
  });

  tearDownAll(() async {
    getIt.unregister<Dio>();
  });

  test('test getRequest', () async {
    Dio dio = getIt<Dio>();
    dioAdapter = DioAdapter(dio: dio);
    dioAdapter.onGet('http://10.0.2.2:5000/api/candidate_get_profile/123',
        (server) {
      server.reply(200, {"": ""});
    });
    // dio.httpClientAdapter = dioAdapter;

    final result = await getRequest('candidate_get_profile', ["123"]);
    expect(result, isA<Map>());
    expect(result, containsPair("", ""));
  });

  test('test postRequest', () async {
    Dio dio = getIt<Dio>();
    dioAdapter = DioAdapter(dio: dio);
    dioAdapter.onPost('http://10.0.2.2:5000/api/candidate_update_profile/123',
        (server) {
      server.reply(200, {"": ""});
    }, data: json.encode({"k": "v"}));
    // dio.httpClientAdapter = dioAdapter;

    final result =
        await postRequest('candidate_update_profile', ["123"], {"k": "v"});
    expect(result, isA<Map>());
    expect(result, containsPair("", ""));
  });
}
