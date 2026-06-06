import 'package:chat_bubbles/algo/algo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Algo.dateChipText', () {
    test('returns "Today" for the current date', () {
      expect(Algo.dateChipText(DateTime.now()), 'Today');
    });

    test('returns "Yesterday" for one day ago', () {
      final now = DateTime.now();
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      expect(Algo.dateChipText(yesterday), 'Yesterday');
    });

    test('returns formatted "d MMMM y" for older dates', () {
      final old = DateTime(2024, 1, 15);
      expect(Algo.dateChipText(old), '15 January 2024');
    });
  });
}
