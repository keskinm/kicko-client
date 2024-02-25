import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:kicko/easy_tests/test_page.dart';


class MockDio extends Mock implements Dio {

}

void main() {
  group('MyApiService Tests', () {
    late MockDio mockDio;
    // late MyApiService myApiService;

    setUp(() {
      mockDio = MockDio();
      // myApiService = MyApiService(dio: mockDio);
    });

    test('Test GET request', () async {
      final responsePayload = {'key': 'value'};
      // Use `any` properly for non-nullable parameter
      when(mockDio.get('fake_route'))
          .thenAnswer((_) async => Response(
                data: responsePayload, 
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
              ));

      // var result = await myApiService.fetchData();
      // expect(result, equals(responsePayload));
      // dynamic results = MockDio().get('fake_route');
      // print("results? ${results}");

      // await tester.pumpWidget(
      //   Provider<Dio>.value(
      //     value: mockDio,
      //     child: MyApp(), // Replace with your actual app widget
      //   ),
      // );


    });
  });
}
