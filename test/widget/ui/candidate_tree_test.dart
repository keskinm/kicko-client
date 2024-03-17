import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:kicko/services/firebase.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kicko/mock_firebase_app_workaround.dart';
import 'package:kicko/candidate/ui/candidate_home_page.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:kicko/get_it_service_locator.dart';
import 'package:kicko/services/app_state.dart';

void main() {
  setupFirebaseAuthMocks();
  late DioAdapter dioAdapter;
  late Dio dio;

  setUp(() async {
    await Firebase.initializeApp();
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
    getIt.registerLazySingleton<Dio>(() => dio);
  });

  tearDown(() {
    getIt.unregister<Dio>();
  });

  testWidgets('Candidate Home', (WidgetTester tester) async {
    final fakeStorage = MockFirebaseStorage();
    final fakeFirestore = FakeFirebaseFirestore();

    appState.currentUser.id = "5";
    String firstJobOfferId = "1";

    dioAdapter
      ..onGet(
          "http://10.0.2.2:5000/api/candidate_get_profile/${appState.currentUser.id}",
          (server) {
        server.reply(200, {
          'id': '5',
          'firebase_id': 'AMMRFGuk88ZCuoL5bPkfCmCOoe13',
          'username': 'bachata6',
          'email': 'bachata6@gmail.com',
          'study_level': 'Master',
          'sex': 'Homme',
        });
      })
      ..onGet("http://10.0.2.2:5000/api/get_candidate_syntax", (server) {
        server.reply(200, {
          'sex': ['', 'Homme', 'Femme', 'Non genré'],
          'study_level': ['', 'Licence', 'Master']
        });
      })
      ..onPost("http://10.0.2.2:5000/api/candidate_get_job_offers", (server) {
        server.reply(200, [
          {
            'id': firstJobOfferId,
            'name': 'post ingénieur développement',
            'description': '',
            'requires': '',
            'business_id': '1'
          },
          {
            'id': '2',
            'name': 'post chargé de marketing',
            'description': '',
            'requires': '',
            'business_id': '1'
          }
        ]);
      }, data: Matchers.any)
      ..onPost(
          "http://10.0.2.2:5000/api/candidate_update_profile/${appState.currentUser.id}",
          (server) {
        server.reply(200, {"success": true});
      }, data: Matchers.any);

    dioAdapter
      ..onGet(
          "http://10.0.2.2:5000/api/applied_job_offer/${appState.currentUser.id}/${firstJobOfferId}",
          (server) {
        server.reply(200, false);
      })
      ..onGet(
          "http://10.0.2.2:5000/api/candidate_get_job_offer/${firstJobOfferId}",
          (server) {
        server.reply(200, {
          'id': firstJobOfferId,
          'name': 'post ingénieur développement',
          'description': '',
          'requires': '',
          'business_id': '1'
        });
      })
      ..onGet(
          "http://10.0.2.2:5000/api/apply_job_offer/${appState.currentUser.id}/${firstJobOfferId}",
          (server) {
        server.reply(200, {
          'id': firstJobOfferId,
          'name': 'post ingénieur développement',
          'description': '',
          'requires': '',
          'business_id': '1'
        });
      });

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

    expect(find.byType(IconButton), findsWidgets);
    await tester.ensureVisible(find.byKey(Key('go_candidate_job_offer_page')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('go_candidate_job_offer_page')).first);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.textContaining('Je suis intéressé par cette offre'),
        findsOneWidget);
    dioAdapter
      ..onGet(
          "http://10.0.2.2:5000/api/applied_job_offer/${appState.currentUser.id}/${firstJobOfferId}",
          (server) {
        server.reply(200, true);
      });
    await tester.tap(find.textContaining('Je suis intéressé par cette offre'));
    await tester.pumpAndSettle();
    expect(find.textContaining('vous avez déjà postulé'), findsOneWidget);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // ---------------------------------------------------------
  });
}
