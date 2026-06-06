import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('MessageBar', () {
    testWidgets('renders the default hint text', (tester) async {
      await pumpInApp(tester, MessageBar());

      expect(find.text('Type your message here'), findsOneWidget);
    });

    testWidgets('renders a custom hint when provided', (tester) async {
      await pumpInApp(
        tester,
        MessageBar(messageBarHintText: 'Say something'),
      );

      expect(find.text('Say something'), findsOneWidget);
    });

    testWidgets('shows the reply preview when replying is true',
        (tester) async {
      await pumpInApp(
        tester,
        MessageBar(replying: true, replyingTo: 'Alice'),
      );

      expect(find.text('Re : Alice'), findsOneWidget);
    });

    testWidgets('fires onSend with the entered text', (tester) async {
      String? sent;
      await pumpInApp(tester, MessageBar(onSend: (text) => sent = text));

      await tester.enterText(find.byType(TextField), 'Hello');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      expect(sent, 'Hello');
    });

    testWidgets('uses the custom sendButton widget when provided',
        (tester) async {
      await pumpInApp(
        tester,
        MessageBar(
          sendButton: const Icon(
            Icons.arrow_upward,
            key: Key('custom-send'),
          ),
        ),
      );

      expect(find.byKey(const Key('custom-send')), findsOneWidget);
      expect(find.byIcon(Icons.send), findsNothing);
    });
  });

  group('MessageBarStyle', () {
    test('exposes the documented defaults', () {
      const style = MessageBarStyle();

      expect(style.fillColor, Colors.white);
      expect(style.minLines, 1);
      expect(style.maxLines, 3);
      expect(style.keyboardType, TextInputType.multiline);
      expect(style.textCapitalization, TextCapitalization.sentences);
    });

    testWidgets('applied min/maxLines reach the underlying TextField',
        (tester) async {
      await pumpInApp(
        tester,
        MessageBar(
          messageBarStyle: const MessageBarStyle(minLines: 2, maxLines: 6),
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.minLines, 2);
      expect(field.maxLines, 6);
    });
  });
}
