import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('DateChip', () {
    testWidgets('renders "Today" for the current date', (tester) async {
      await pumpInApp(tester, DateChip(date: DateTime.now()));

      expect(find.text('Today'), findsOneWidget);
    });

    testWidgets('renders a formatted date for older dates', (tester) async {
      await pumpInApp(tester, DateChip(date: DateTime(2024, 1, 15)));

      expect(find.text('15 January 2024'), findsOneWidget);
    });
  });
}
