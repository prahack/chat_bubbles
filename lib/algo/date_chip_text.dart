import 'package:intl/intl.dart';

///initial formatter to find the date txt
final DateFormat _formatter = DateFormat('yyyy-MM-dd');

///[DateChipText] class included with algorithms which are need to implement [DateChip]
///[date] parameter is required
///
class DateChipText {
  final DateTime date;

  DateChipText(this.date);

  ///generate and return [DateChip] string
  ///
  ///
  String getText() {
    final now = new DateTime.now();
    if (_formatter.format(now) == _formatter.format(date)) {
      return 'Today';
    } else if (_formatter
            .format(new DateTime(now.year, now.month, now.day - 1)) ==
        _formatter.format(date)) {
      return 'Yesterday';
    } else {
      return '${DateFormat('d').format(date)} ${DateFormat('MMMM').format(date)} ${DateFormat('y').format(date)}';
    }
  }
}
