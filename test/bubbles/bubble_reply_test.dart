import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_bubbles/utils/timestamped_chat_message.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('BubbleReply', () {
    testWidgets('renders replied message and sender labels', (tester) async {
      await pumpInApp(
        tester,
        const BubbleReply(
          repliedMessage: 'original message',
          repliedMessageSender: 'Alice',
          text: 'my reply',
        ),
      );

      expect(find.text('original message'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('passes the reply text to TimestampedChatMessage',
        (tester) async {
      await pumpInApp(
        tester,
        const BubbleReply(
          repliedMessage: 'original',
          repliedMessageSender: 'Alice',
          text: 'my reply',
        ),
      );

      final w = tester
          .widget<TimestampedChatMessage>(find.byType(TimestampedChatMessage));
      expect(w.text, 'my reply');
    });

    testWidgets('fires onReplyTap when the quoted block is tapped',
        (tester) async {
      var tapped = 0;
      await pumpInApp(
        tester,
        BubbleReply(
          repliedMessage: 'original',
          repliedMessageSender: 'Alice',
          text: 'reply',
          onReplyTap: () => tapped++,
        ),
      );

      await tester.tap(find.text('original'));
      await tester.pump();

      expect(tapped, 1);
    });
  });
}
