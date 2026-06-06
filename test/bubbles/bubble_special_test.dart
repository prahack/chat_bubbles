import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('BubbleSpecialOne', () {
    testWidgets('renders text', (tester) async {
      await pumpInApp(tester, const BubbleSpecialOne(text: 'one'));
      expect(find.text('one'), findsOneWidget);
    });
  });

  group('BubbleSpecialTwo', () {
    testWidgets('renders text', (tester) async {
      await pumpInApp(tester, const BubbleSpecialTwo(text: 'two'));
      expect(find.text('two'), findsOneWidget);
    });
  });

  group('BubbleSpecialThree', () {
    testWidgets('renders text', (tester) async {
      await pumpInApp(tester, const BubbleSpecialThree(text: 'three'));
      expect(find.text('three'), findsOneWidget);
    });
  });
}
