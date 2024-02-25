import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'my_api_service.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('MyApiService Tests', () {
    late MockDio mockDio;
    late MyApiService myApiService;

    setUp(() {
      mockDio = MockDio();
      myApiService = MyApiService(dio: mockDio);
    });

    test('Test GET request', () async {
      final responsePayload = {'key': 'value'};
      when(mockDio.get(any)).thenAnswer(
          (_) async => Response(data: responsePayload, statusCode: 200));

      var result = await myApiService.fetchData();

      expect(result, equals(responsePayload));
    });
  });
}
