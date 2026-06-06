import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('SwipeableBubble', () {
    testWidgets('renders its child', (tester) async {
      await pumpInApp(
        tester,
        const SwipeableBubble(
          child: Text('child content'),
        ),
      );

      expect(find.text('child content'), findsOneWidget);
    });

    testWidgets('fires onSwipeRight when dragged right past the threshold',
        (tester) async {
      var rightSwipes = 0;
      await pumpInApp(
        tester,
        SwipeableBubble(
          enableHaptics: false,
          swipeThreshold: 50,
          onSwipeRight: () => rightSwipes++,
          child: const SizedBox(width: 200, height: 60, child: Text('drag')),
        ),
      );

      await tester.drag(find.text('drag'), const Offset(120, 0));
      await tester.pumpAndSettle();

      expect(rightSwipes, 1);
    });

    testWidgets('fires onSwipeLeft when dragged left past the threshold',
        (tester) async {
      var leftSwipes = 0;
      await pumpInApp(
        tester,
        SwipeableBubble(
          enableHaptics: false,
          swipeThreshold: 50,
          onSwipeLeft: () => leftSwipes++,
          child: const SizedBox(width: 200, height: 60, child: Text('drag')),
        ),
      );

      await tester.drag(find.text('drag'), const Offset(-120, 0));
      await tester.pumpAndSettle();

      expect(leftSwipes, 1);
    });
  });
}
