import 'package:flutter_test/flutter_test.dart';
import 'package:kicko/pages/candidate/candidate_home_page.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';


void main() {
  testWidgets('shows messages', (WidgetTester tester) async {
    final firestore = FakeFirebaseFirestore();

    await firestore.collection('messages').add({
      'message': 'Hello world!',
      'created_at': DateTime.now(),
    });

    await tester.pumpWidget(MaterialApp(home: CandidateHome(firestore: firestore)));

    await tester.pumpAndSettle();

    expect(find.text('Hello world!'), findsOneWidget);
  });
}

