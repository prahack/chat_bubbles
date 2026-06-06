import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('BubbleNormal', () {
    testWidgets('renders the provided text', (tester) async {
      await pumpInApp(tester, const BubbleNormal(text: 'Hello world'));

      expect(find.text('Hello world'), findsOneWidget);
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

    testWidgets('fires onTap when tapped outside the SelectableText',
        (tester) async {
      var tapped = 0;
      await pumpInApp(
        tester,
        // isSender: false so the bubble hugs the left edge — sender bubbles
        // have an Expanded spacer that absorbs a centered tap on the Row.
        BubbleNormal(
          text: 'tap me',
          isSender: false,
          onTap: () => tapped++,
        ),
      );

      // The bubble wraps its text in a SelectableText, which consumes taps
      // for text selection. To exercise the outer GestureDetector.onTap, tap
      // in the bubble's padding area just above the text.
      final textRect = tester.getRect(find.byType(SelectableText));
      await tester.tapAt(Offset(textRect.center.dx, textRect.top - 3));
      await tester.pump();

      expect(tapped, 1);
    });

    testWidgets('renders timestamp when provided', (tester) async {
      await pumpInApp(
        tester,
        const BubbleNormal(text: 'with time', timestamp: '12:30 PM'),
      );

      expect(find.text('12:30 PM'), findsOneWidget);
    });
  });
}
