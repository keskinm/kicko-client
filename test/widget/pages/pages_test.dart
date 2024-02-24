import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kicko/pages/candidate/candidate_home_page.dart';
import 'package:kicko/firebase_options.dart';

// void main() {
//   test('test_name', () {
//     var expected = 42;
//     expect(expected, 42);
//   });
// }

import 'package:kicko/pages/candidate/candidate_home_page.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  testWidgets('Mon test de widget', (WidgetTester tester) async {
    await tester.pumpWidget(CandidateHome());

    // final titleFinder = find.text('Title');
//     expect(titleFinder, findsOneWidget);
  });
}
