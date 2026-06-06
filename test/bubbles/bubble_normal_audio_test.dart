import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('BubbleNormalAudio', () {
    testWidgets('renders without crashing in non-loading state',
        (tester) async {
      await pumpInApp(
        tester,
        BubbleNormalAudio(
          duration: 30000,
          position: 5000,
          isLoading: false,
          onPlayPauseButtonClick: () {},
          onSeekChanged: (_) {},
        ),
      );

      expect(find.byType(BubbleNormalAudio), findsOneWidget);
    });

    testWidgets('fires onPlayPauseButtonClick when the play icon is tapped',
        (tester) async {
      var clicks = 0;
      await pumpInApp(
        tester,
        BubbleNormalAudio(
          duration: 30000,
          position: 0,
          isLoading: false,
          isPlaying: false,
          onPlayPauseButtonClick: () => clicks++,
          onSeekChanged: (_) {},
        ),
      );

      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();

      expect(clicks, 1);
    });

    testWidgets('renders a slider when waveformData is null', (tester) async {
      await pumpInApp(
        tester,
        BubbleNormalAudio(
          duration: 30000,
          position: 0,
          isLoading: false,
          onPlayPauseButtonClick: () {},
          onSeekChanged: (_) {},
        ),
      );

      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('omits the slider when waveformData is provided',
        (tester) async {
      await pumpInApp(
        tester,
        BubbleNormalAudio(
          duration: 30000,
          position: 0,
          isLoading: false,
          onPlayPauseButtonClick: () {},
          onSeekChanged: (_) {},
          waveformData: List.generate(20, (i) => i / 20),
        ),
      );

      expect(find.byType(Slider), findsNothing);
    });
  });
}
