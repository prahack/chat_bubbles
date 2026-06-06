import 'package:intl/intl.dart';

///initial formatter to find the date txt
final DateFormat _formatter = DateFormat('yyyy-MM-dd');

///[DateChipText] class included with algorithms which are need to implement [DateChip]
///[date] parameter is required
///
class DateChipText {
  ///[date] parameter is required
  final DateTime date;

  ///[DateChipText] class included with algorithms which are need to implement [DateChip]
  DateChipText(this.date);

  ///generate and return [DateChip] string
  ///
  ///[DateChipText.getText] to get the text which is need to show on the [DateChip]
  String getText() {
    final now = DateTime.now();
    if (_formatter.format(now) == _formatter.format(date)) {
      return 'Today';
    } else if (_formatter.format(DateTime(now.year, now.month, now.day - 1)) ==
        _formatter.format(date)) {
      return 'Yesterday';
    } else {
      return '${DateFormat('d').format(date)} ${DateFormat('MMMM').format(date)} ${DateFormat('y').format(date)}';
    }
  }
}
