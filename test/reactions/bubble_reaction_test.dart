import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('BubbleReaction', () {
    testWidgets('renders one chip per reaction with count > 1', (tester) async {
      await pumpInApp(
        tester,
        const BubbleReaction(
          reactions: [
            Reaction(emoji: '❤️', count: 3),
            Reaction(emoji: '😂', count: 1),
          ],
          showAddButton: false,
        ),
      );

      expect(find.text('❤️'), findsOneWidget);
      expect(find.text('😂'), findsOneWidget);
      // count is only rendered when > 1
      expect(find.text('3'), findsOneWidget);
      expect(find.text('1'), findsNothing);
    });

    testWidgets('fires onAddReactionTap when the add button is tapped',
        (tester) async {
      var taps = 0;
      await pumpInApp(
        tester,
        BubbleReaction(
          reactions: const [],
          onAddReactionTap: () => taps++,
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('renders nothing when reactions are empty and add is hidden',
        (tester) async {
      await pumpInApp(
        tester,
        const BubbleReaction(reactions: [], showAddButton: false),
      );

      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(Chip), findsNothing);
    });
  });

  group('ReactionPicker', () {
    testWidgets('fires onReactionSelected with the tapped emoji',
        (tester) async {
      String? selected;
      await pumpInApp(
        tester,
        ReactionPicker(
          reactions: const ['❤️', '👍'],
          onReactionSelected: (emoji) => selected = emoji,
        ),
      );

      await tester.tap(find.text('👍'));
      await tester.pump();

      expect(selected, '👍');
    });
  });
}
