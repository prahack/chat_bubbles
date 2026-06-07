import 'package:chat_bubbles/utils/timestamped_chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('TimestampedChatMessage', () {
    testWidgets('places meta on the same line for a short message',
        (tester) async {
      // Short message + short meta: should fit on one line, so widget height
      // is roughly the line height of the message text (not text + meta).
      await pumpInApp(
        tester,
        const SizedBox(
          width: 300,
          child: TimestampedChatMessage(
            text: 'Hi',
            textStyle: TextStyle(fontSize: 16),
            timestamp: '12:34',
          ),
        ),
      );

      final box =
          tester.renderObject<RenderBox>(find.byType(TimestampedChatMessage));
      // One line of 16px text plus typical line-height multiplier ≈ < 30
      expect(box.size.height, lessThan(30));
    });

    testWidgets('wraps meta below when the last line is full', (tester) async {
      // Long single line that already fills the width: meta should NOT fit
      // inline and must wrap to a new line, doubling the widget height.
      const text =
          'This is a long message that should definitely fill the entire '
          'available width so the timestamp has nowhere to sit on the last '
          'line and must drop to a new row below.';

      await pumpInApp(
        tester,
        const SizedBox(
          width: 200,
          child: TimestampedChatMessage(
            text: text,
            textStyle: TextStyle(fontSize: 14),
            timestamp: '12:34 PM',
          ),
        ),
      );

      final box =
          tester.renderObject<RenderBox>(find.byType(TimestampedChatMessage));
      // Several wrapped lines of text + an additional line for the meta.
      expect(box.size.height, greaterThan(60));
    });

    testWidgets('renders pure text with no meta block', (tester) async {
      await pumpInApp(
        tester,
        const SizedBox(
          width: 300,
          child: TimestampedChatMessage(
            text: 'Just text, no meta',
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
      );

      // Sanity check: widget builds and is non-empty.
      final box =
          tester.renderObject<RenderBox>(find.byType(TimestampedChatMessage));
      expect(box.size.width, greaterThan(0));
      expect(box.size.height, greaterThan(0));
    });

    testWidgets('combines edited label, timestamp and status icon in meta',
        (tester) async {
      await pumpInApp(
        tester,
        const SizedBox(
          width: 300,
          child: TimestampedChatMessage(
            text: 'msg',
            textStyle: TextStyle(fontSize: 16),
            timestamp: '12:34',
            isEdited: true,
            statusIcon: Icons.done_all,
          ),
        ),
      );

      // Widget builds without exception when all three meta items are set.
      expect(find.byType(TimestampedChatMessage), findsOneWidget);
    });
  });
}
