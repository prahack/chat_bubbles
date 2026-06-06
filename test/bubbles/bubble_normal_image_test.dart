import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('BubbleNormalImage', () {
    testWidgets('renders the provided image widget', (tester) async {
      await pumpInApp(
        tester,
        BubbleNormalImage(
          id: 'img-1',
          image: Container(
            key: const Key('test-image'),
            width: 100,
            height: 100,
            color: Colors.blue,
          ),
        ),
      );

      expect(find.byKey(const Key('test-image')), findsOneWidget);
    });

    testWidgets('fires onTap when the image is tapped', (tester) async {
      var taps = 0;
      await pumpInApp(
        tester,
        BubbleNormalImage(
          id: 'img-2',
          image: Container(
            key: const Key('tap-target'),
            width: 100,
            height: 100,
            color: Colors.red,
          ),
          onTap: () => taps++,
        ),
      );

      await tester.tap(find.byKey(const Key('tap-target')));
      await tester.pump();

      expect(taps, 1);
    });
  });
}
