import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('BubbleLinkPreview', () {
    testWidgets('renders url, title and description', (tester) async {
      await pumpInApp(
        tester,
        const BubbleLinkPreview(
          url: 'https://example.com',
          title: 'Example',
          description: 'An example domain',
          text: 'Check this out',
        ),
      );

      expect(find.text('Example'), findsOneWidget);
      expect(find.text('An example domain'), findsOneWidget);
      expect(find.text('Check this out'), findsOneWidget);
    });
  });
}
