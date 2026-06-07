import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_bubbles/utils/timestamped_chat_message.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('BubbleSpecialOne', () {
    testWidgets('renders the provided text via TimestampedChatMessage',
        (tester) async {
      await pumpInApp(tester, const BubbleSpecialOne(text: 'one'));

      final w = tester
          .widget<TimestampedChatMessage>(find.byType(TimestampedChatMessage));
      expect(w.text, 'one');
    });
  });

  group('BubbleSpecialTwo', () {
    testWidgets('renders the provided text via TimestampedChatMessage',
        (tester) async {
      await pumpInApp(tester, const BubbleSpecialTwo(text: 'two'));

      final w = tester
          .widget<TimestampedChatMessage>(find.byType(TimestampedChatMessage));
      expect(w.text, 'two');
    });
  });

  group('BubbleSpecialThree', () {
    testWidgets('renders the provided text via TimestampedChatMessage',
        (tester) async {
      await pumpInApp(tester, const BubbleSpecialThree(text: 'three'));

      final w = tester
          .widget<TimestampedChatMessage>(find.byType(TimestampedChatMessage));
      expect(w.text, 'three');
    });
  });
}
