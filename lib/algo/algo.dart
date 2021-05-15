import 'package:chat_bubbles/date_chips/date_chip.dart';

import './date_chip_text.dart';

///all the algorithms of the plugin
///[dateChipText] to get the text which is need to show on the [DateChip]
abstract class Algo {
  Algo._();

  static String dateChipText(final DateTime date) {
    final dateChipText = new DateChipText(date);
    return dateChipText.getText();
  }
}
