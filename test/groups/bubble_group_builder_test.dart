import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('BubbleGroupBuilder', () {
    testWidgets('returns an empty box when itemCount is zero', (tester) async {
      await pumpInApp(
        tester,
        BubbleGroupBuilder(
          itemCount: 0,
          senderIdOf: (_) => 'x',
          itemBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      );

      expect(find.byType(BubbleGroupBuilder), findsOneWidget);
    });

    testWidgets('calls itemBuilder once per item with grouping info',
        (tester) async {
      final senders = ['alice', 'alice', 'bob'];
      final infos = <GroupInfo>[];

      await pumpInApp(
        tester,
        BubbleGroupBuilder(
          itemCount: senders.length,
          senderIdOf: (i) => senders[i],
          itemBuilder: (_, i, info) {
            infos.add(info);
            return Text('msg-$i');
          },
        ),
      );

      expect(find.text('msg-0'), findsOneWidget);
      expect(find.text('msg-1'), findsOneWidget);
      expect(find.text('msg-2'), findsOneWidget);

      expect(infos, hasLength(3));
      expect(infos[0].isGroupStart, isTrue);
      expect(infos[1].isGroupEnd, isTrue);
      expect(infos[2].isAlone, isTrue);
    });
  });
}
