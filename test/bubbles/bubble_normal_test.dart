import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_bubbles/utils/timestamped_chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('BubbleNormal', () {
    testWidgets('passes its text to the inline-meta render widget',
        (tester) async {
      await pumpInApp(tester, const BubbleNormal(text: 'Hello world'));

      final w = tester
          .widget<TimestampedChatMessage>(find.byType(TimestampedChatMessage));
      expect(w.text, 'Hello world');
    });

    testWidgets('adds a leading Expanded spacer when isSender is true',
        (tester) async {
      // Sender bubbles push to the right with an Expanded spacer on the left.
      await pumpInApp(
        tester,
        const BubbleNormal(text: 'mine', isSender: true),
      );

      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('renders no Expanded spacer when isSender is false',
        (tester) async {
      // Receiver bubbles have no Expanded — they hug the left edge.
      await pumpInApp(
        tester,
        const BubbleNormal(text: 'theirs', isSender: false),
      );

      expect(find.byType(Expanded), findsNothing);
    });

    testWidgets('fires onTap when tapped', (tester) async {
      var tapped = 0;
      await pumpInApp(
        tester,
        BubbleNormal(
          text: 'tap me',
          isSender: false,
          onTap: () => tapped++,
        ),
      );

      await tester.tapAt(tester.getCenter(find.byType(TimestampedChatMessage)));
      await tester.pump();

      expect(tapped, 1);
    });

    testWidgets('forwards the timestamp string to the render widget',
        (tester) async {
      await pumpInApp(
        tester,
        const BubbleNormal(text: 'with time', timestamp: '12:30 PM'),
      );

      final w = tester
          .widget<TimestampedChatMessage>(find.byType(TimestampedChatMessage));
      expect(w.timestamp, '12:30 PM');
    });

    testWidgets('selects the correct status icon for seen messages',
        (tester) async {
      await pumpInApp(
        tester,
        const BubbleNormal(text: 'seen msg', sent: true, seen: true),
      );

      final w = tester
          .widget<TimestampedChatMessage>(find.byType(TimestampedChatMessage));
      expect(w.statusIcon, Icons.done_all);
    });
  });
}
