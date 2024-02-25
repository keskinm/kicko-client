import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:kicko/services/database.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kicko/easy_tests/mock_firebase_app_workaround.dart';
// import 'package:mockito/mockito.dart';
// import 'package:kicko/firebase_options.dart';
import 'package:kicko/pages/candidate/candidate_home_page.dart';
import 'package:kicko/easy_tests/test_page.dart';

// the firebase app mocking is FOUND HERE: https://stackoverflow.com/questions/63662031/how-to-mock-the-firebaseapp-in-flutter

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('shows messages', (WidgetTester tester) async {
    final fakeStorage = MockFirebaseStorage();
    final fakeFirestore = FakeFirebaseFirestore();

    await tester.pumpWidget(
      Provider<FireBaseServiceInterface>(
        create: (_) => FireBaseService(
            firestore: fakeFirestore, firebaseStorage: fakeStorage),
        child: MaterialApp(
          home: CandidateHome(),
        ),
      ),
    );
  });
}
