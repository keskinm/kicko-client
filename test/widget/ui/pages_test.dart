import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:kicko/services/firebase.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kicko/easy_tests/mock_firebase_app_workaround.dart';
import 'package:kicko/candidate/ui/candidate_home_page.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:kicko/get_it_service_locator.dart';
import 'package:kicko/services/app_state.dart';

// the firebase app mocking is FOUND HERE: https://stackoverflow.com/questions/63662031/how-to-mock-the-firebaseapp-in-flutter

void main() {
  setupFirebaseAuthMocks();
  late DioAdapter dioAdapter;

  setUpAll(() async {
    await Firebase.initializeApp();
    // getIt.unregister<Dio>();
    Dio dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
    getIt.registerLazySingleton<Dio>(() => dio);
  });

  testWidgets('Candidate Home', (WidgetTester tester) async {
    final fakeStorage = MockFirebaseStorage();
    final fakeFirestore = FakeFirebaseFirestore();

    appState.currentUser.id = "5";

    dioAdapter
      ..onGet(
          "http://10.0.2.2:5000/api/candidate_get_profile/${appState.currentUser.id}",
          (server) {
        server.reply(200, {
          'instance': {
            'id': '5',
            'firebase_id': 'AMMRFGuk88ZCuoL5bPkfCmCOoe13',
            'username': 'bachata6',
            'password': 'bachata6',
            'email': 'bachata6@gmail.com',
            'study_level': 2,
            'l_study_level': 'Master',
            'sex': 2,
            'l_sex': 'Femme',
            'language': 'french'
          },
          'syntax': {
            'sex': ['', 'Homme', 'Femme', 'Non genré'],
            'study_level': ['', 'Licence', 'Master']
          }
        });
      })
      ..onPost("http://10.0.2.2:5000/api/candidate_get_job_offers", (server) {
        server.reply(200, []);
      }, data: Matchers.any)
      ..onPost(
          "http://10.0.2.2:5000/api/candidate_update_profile/${appState.currentUser.id}",
          (server) {
        server.reply(200, {"success": true});
      }, data: Matchers.any);

    await tester.pumpWidget(
      Provider<FireBaseServiceInterface>(
        create: (_) => FireBaseService(
            firestore: fakeFirestore, firebaseStorage: fakeStorage),
        child: MaterialApp(
          home: CandidateHome(),
        ),
      ),
    );

    // Check for loading indicators before data is fetched with pumpAndSettle
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Text && widget.data!.contains('Error'),
        ),
        findsNothing);

    expect(find.text('Mes CV'), findsOneWidget);

    // ---------------------------------------------------------

    await tester.tap(find.byKey(Key('save_profile_button')));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text('fermer'));
    await tester.pumpAndSettle();

    // ---------------------------------------------------------
  });
}
