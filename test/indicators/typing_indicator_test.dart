import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('TypingIndicator', () {
    testWidgets('renders when showIndicator is true', (tester) async {
      await pumpInApp(tester, const TypingIndicator());

      expect(find.byType(TypingIndicator), findsOneWidget);

      // pump a frame to advance the animation, then settle by stopping
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('renders nothing visible when showIndicator is false',
        (tester) async {
      await pumpInApp(tester, const TypingIndicator(showIndicator: false));

      expect(find.byType(TypingIndicator), findsOneWidget);
    });
  });

  group('TypingIndicatorWave', () {
    testWidgets('renders without crashing', (tester) async {
      await pumpInApp(tester, const TypingIndicatorWave());

      expect(find.byType(TypingIndicatorWave), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
