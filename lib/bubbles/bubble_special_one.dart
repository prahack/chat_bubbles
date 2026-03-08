import 'package:flutter/material.dart';
import '../utils/bubble_forwarded_header.dart';
import '../utils/bubble_status_row.dart';

///WhatsApp's chat bubble type
///
///chat bubble color can be customized using [color]
///chat bubble tail can be customized  using [tail]
///chat bubble display message can be changed using [text]
///[text] is the only required parameter
///message sender can be changed using [isSender]
///chat bubble [TextStyle] can be customized using [textStyle]
///
/// [timestamp] is an optional string shown at the bottom-right of the bubble
///
/// [isEdited] shows an "Edited" label next to the status area when true
///
/// [isForwarded] shows a "Forwarded" banner at the top of the bubble when true
///
/// [messageId] is an optional identifier for tracking purposes

class BubbleSpecialOne extends StatelessWidget {
  /// message sender
  final bool isSender;
  /// message text
  final String text;
  /// chat bubble tail
  final bool tail;
  /// chat bubble color
  final Color color;
  /// message state - whether the message has been sent
  final bool sent;
  /// message state - whether the message has been delivered
  final bool delivered;
  /// message state - whether the message has been seen
  final bool seen;
  /// text style for the message
  final TextStyle textStyle;
  /// constraints for the chat bubble
  final BoxConstraints? constraints;
  /// optional timestamp string shown at the bottom-right (e.g. "12:34 PM")
  final String? timestamp;
  /// shows an "Edited" label next to the status area when true
  final bool isEdited;
  /// shows a "Forwarded" banner at the top of the bubble when true
  final bool isForwarded;
  /// optional identifier for tracking the message
  final String? messageId;

  /// Creates a [BubbleSpecialOne] widget
  const BubbleSpecialOne({
    Key? key,
    this.isSender = true,
    this.constraints,
    required this.text,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    this.timestamp,
    this.isEdited = false,
    this.isForwarded = false,
    this.messageId,
  }) : super(key: key);

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    final bool showStatusArea = stateTick || timestamp != null || isEdited;
    final Color forwardedColor =
        (textStyle.color ?? Colors.black87).withOpacity(0.6);

    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: CustomPaint(
          painter: _SpecialChatBubbleOne(
              color: color,
              alignment: isSender ? Alignment.topRight : Alignment.topLeft,
              tail: tail),
          child: Container(
            constraints: constraints ??
                BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .7,
                ),
            margin: isSender
                ? const EdgeInsets.fromLTRB(7, 7, 14, 7)
                : const EdgeInsets.fromLTRB(17, 7, 7, 7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isForwarded) BubbleForwardedHeader(color: forwardedColor),
                Text(
                  text,
                  style: textStyle,
                  textAlign: TextAlign.left,
                ),
                if (showStatusArea)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: BubbleStatusRow(
                        stateIcon: stateTick ? stateIcon : null,
                        isEdited: isEdited,
                        timestamp: timestamp,
                        textColor: textStyle.color ?? Colors.black87,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///custom painter use to create the shape of the chat bubble
///
/// [color],[alignment] and [tail] can be changed

class _SpecialChatBubbleOne extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool tail;

  _SpecialChatBubbleOne({
    required this.color,
    required this.alignment,
    required this.tail,
  });

  final double _radius = 10.0;
  final double _x = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (alignment == Alignment.topRight) {
      if (tail) {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              0,
              0,
              size.width - _x,
              size.height,
              bottomLeft: Radius.circular(_radius),
              bottomRight: Radius.circular(_radius),
              topLeft: Radius.circular(_radius),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
        var path = Path();
        path.moveTo(size.width - _x, 0);
        path.lineTo(size.width - _x, 10);
        path.lineTo(size.width, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              size.width - _x,
              0.0,
              size.width,
              size.height,
              topRight: Radius.circular(3),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              0,
              0,
              size.width - _x,
              size.height,
              bottomLeft: Radius.circular(_radius),
              bottomRight: Radius.circular(_radius),
              topLeft: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    } else {
      if (tail) {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              _x,
              0,
              size.width,
              size.height,
              bottomRight: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
              bottomLeft: Radius.circular(_radius),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
        var path = Path();
        path.moveTo(_x, 0);
        path.lineTo(_x, 10);
        path.lineTo(0, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              0,
              0.0,
              _x,
              size.height,
              topLeft: Radius.circular(3),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              _x,
              0,
              size.width,
              size.height,
              bottomRight: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
              bottomLeft: Radius.circular(_radius),
              topLeft: Radius.circular(_radius),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
