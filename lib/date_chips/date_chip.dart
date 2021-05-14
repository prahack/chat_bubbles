import 'package:chat_bubbles/algo/algo.dart';
import 'package:flutter/cupertino.dart';

///[DateChip] use to show the date breakers on the chat view
///
///
class DateChip extends StatelessWidget{
  final DateTime date;
  ///
  ///
  ///
  const DateChip({
    Key? key,
    required this.date,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        Algo.dateChipText(date),
      ),
    );
  }

}