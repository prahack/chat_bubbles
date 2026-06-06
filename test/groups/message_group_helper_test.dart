import 'package:chat_bubbles/groups/message_group_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MessageGroupHelper.compute', () {
    test('returns empty list for empty input', () {
      expect(MessageGroupHelper.compute(senderIds: []), isEmpty);
    });

    test('marks a lone message as alone with tail and avatar', () {
      final result = MessageGroupHelper.compute(senderIds: ['alice']);

      expect(result, hasLength(1));
      expect(result[0].isAlone, isTrue);
      expect(result[0].showTail, isTrue);
      expect(result[0].showAvatar, isTrue);
      expect(result[0].isGroupStart, isTrue);
      expect(result[0].isGroupEnd, isTrue);
    });

    test('groups consecutive messages from the same sender', () {
      final result = MessageGroupHelper.compute(
        senderIds: ['alice', 'alice', 'alice'],
      );

      expect(result[0].isGroupStart, isTrue);
      expect(result[0].isGroupEnd, isFalse);
      expect(result[0].showTail, isFalse);

      expect(result[1].isGroupStart, isFalse);
      expect(result[1].isGroupEnd, isFalse);

      expect(result[2].isGroupStart, isFalse);
      expect(result[2].isGroupEnd, isTrue);
      expect(result[2].showTail, isTrue);
    });

    test('splits a group when the sender changes', () {
      final result = MessageGroupHelper.compute(
        senderIds: ['alice', 'alice', 'bob', 'alice'],
      );

      expect(result[0].isGroupStart, isTrue);
      expect(result[1].isGroupEnd, isTrue);
      expect(result[2].isAlone, isTrue);
      expect(result[3].isAlone, isTrue);
    });

    test('splits a group when timestamps exceed the threshold', () {
      final base = DateTime(2024, 1, 1, 12, 0);
      final result = MessageGroupHelper.compute(
        senderIds: ['alice', 'alice'],
        timestamps: [base, base.add(const Duration(minutes: 5))],
        threshold: const Duration(minutes: 1),
      );

      expect(result[0].isAlone, isTrue);
      expect(result[1].isAlone, isTrue);
    });

    test('keeps a group when timestamps are within the threshold', () {
      final base = DateTime(2024, 1, 1, 12, 0);
      final result = MessageGroupHelper.compute(
        senderIds: ['alice', 'alice'],
        timestamps: [base, base.add(const Duration(seconds: 30))],
        threshold: const Duration(minutes: 1),
      );

      expect(result[0].isGroupStart, isTrue);
      expect(result[0].isGroupEnd, isFalse);
      expect(result[1].isGroupEnd, isTrue);
    });
  });
}
