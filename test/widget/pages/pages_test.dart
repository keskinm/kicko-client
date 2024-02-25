import 'package:flutter_test/flutter_test.dart';
import 'package:kicko/pages/candidate/candidate_home_page.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kicko/services/database.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kicko/providers.dart';

void main() {
  testWidgets('shows messages', (WidgetTester tester) async {
    final fakeFirestore = FakeFirebaseFirestore();
    final mockDatabaseService = DatabaseMethods(firestore: fakeFirestore);

    await mockDatabaseService.addMessage("EH", {'coucou': 'hello world'});

    final message = await fakeFirestore
        .collection("chatRoom")
        .doc("EH")
        .collection("chats")
        .get();
    for (var document in message.docs) {
      print(document.data());
    }

    // final messages = await fakeFirestore.collection('messages').get();
    // expect(messages.docs.length, 1);
    // expect(messages.docs.first['message'], 'Hello world!');

    // ----------------------------------------

    // await fakeFirestore.collection('messages').add({
    //   'message': 'Hello world!',
    //   'created_at': DateTime.now(),
    // });

    // await tester.pumpWidget(
    //   ProviderScope(
    //     overrides: [
    //       databaseServiceProvider.overrideWithValue(mockDatabaseService),
    //     ],
    //     child: MaterialApp(home: CandidateHome()),
    //   ),
    // );
  });
}
