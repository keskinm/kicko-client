import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:kicko/services/database.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kicko/easy_tests/mock_firebase_app_workaround.dart';
import 'package:kicko/easy_tests/test_page.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:kicko/get_it_service_locator.dart';

// the firebase app mocking is FOUND HERE: https://stackoverflow.com/questions/63662031/how-to-mock-the-firebaseapp-in-flutter

void main() {
  setupFirebaseAuthMocks();
  late DioAdapter dioAdapter;

  setUpAll(() async {
    await Firebase.initializeApp();
    // getIt.unregister<Dio>();
    Dio dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
    dioAdapter.onPost('http://10.0.2.2:5000/api/candidate_get_profile',
        (server) {
      server.reply(200, {"": ""});
    }, data: Matchers.any);
    getIt.registerLazySingleton<Dio>(() => dio);
  });

  testWidgets('ensure mocking database services', (WidgetTester tester) async {
    final fakeStorage = MockFirebaseStorage();
    final fakeFirestore = FakeFirebaseFirestore();

    await tester.pumpWidget(
      Provider<FireBaseServiceInterface>(
        create: (_) => FireBaseService(
            firestore: fakeFirestore, firebaseStorage: fakeStorage),
        child: MaterialApp(
          home: TestPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
  });
}
