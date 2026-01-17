import 'package:chat_bubbles/date_chips/date_chip.dart';

import './date_chip_text.dart';

///all the algorithms of the plugin
///[Algo] class included with algorithms
///[Algo.dateChipText] to get the text which is need to show on the [DateChip]
abstract class Algo {
  Algo._();

  ///[dateChipText] to get the text which is need to show on the [DateChip]
  static String dateChipText(final DateTime date) {
    final dateChipText = DateChipText(date);
    return dateChipText.getText();
  }
}
