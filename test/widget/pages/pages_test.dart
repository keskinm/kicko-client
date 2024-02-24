import 'package:flutter_test/flutter_test.dart';
// void main() {
//   test('test_name', () {
//     var expected = 42;
//     expect(expected, 42);
//   });
// }

import 'package:kicko/pages/candidate/candidate_home_page.dart';

void main() {
  testWidgets('Mon test de widget', (WidgetTester tester) async {
    await tester.pumpWidget(CandidateHome());

    // final titleFinder = find.text('Title');
//     expect(titleFinder, findsOneWidget);
  });
}



