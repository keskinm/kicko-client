import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:kicko/services/database.dart';

// import 'package:mockito/mockito.dart';
// import 'package:kicko/firebase_options.dart';

// the firebase app mocking is FOUND HERE: https://stackoverflow.com/questions/63662031/how-to-mock-the-firebaseapp-in-flutter

void main() {
  testWidgets('shows messages', (WidgetTester tester) async {
    final fakeStorage = MockFirebaseStorage();
    final fakeFirestore = FakeFirebaseFirestore();
    final mockDatabaseService =
        FireBaseService(firestore: fakeFirestore, firebaseStorage: fakeStorage);

    await mockDatabaseService.addMessage("EH", {'coucou': 'hello world'});

    final message = await fakeFirestore
        .collection("chatRoom")
        .doc("EH")
        .collection("chats")
        .get();
    for (var document in message.docs) {
      print(document.data());
    }

    // ----------------------------------------

    // final messages = await fakeFirestore.collection('messages').get();
    // expect(messages.docs.length, 1);
    // expect(messages.docs.first['message'], 'Hello world!');

    // await fakeFirestore.collection('messages').add({
    //   'message': 'Hello world!',
    //   'created_at': DateTime.now(),
    // });

    // ----------------------------------------
  });
}
