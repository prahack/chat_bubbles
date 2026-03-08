import 'package:flutter/material.dart';
import '../utils/bubble_forwarded_header.dart';
import '../utils/bubble_status_row.dart';

/// chat bubble default [BorderRadius]
const double defaultBubbleRadius = 16;

/// Basic chat bubble
///
/// The [BorderRadius] can be customized using [bubbleRadius]
///
/// [margin] and [padding] can be used to add space around or within
/// the bubble respectively.
///
/// Default [margin] value is [EdgeInsets.zero] and
/// default padding value is [EdgeInsets.symmetric(horizontal: 16, vertical: 2)]
///
/// Color can be customized using [color]
///
/// [tail] boolean is used to add or remove a tail according to the sender type
///
/// Display message can be changed using [text]
///
/// [text] is the only required parameter
///
/// [text] is now selectable
///
/// Message sender can be changed using [isSender]
///
/// [sent], [delivered] and [seen] can be used to display the message state
///
/// The [TextStyle] can be customized using [textStyle]
///
/// [leading] is the widget that's infront of the bubble when [isSender]
/// is false.
///
/// [trailing] is the widget that's at the end of the bubble when [isSender]
/// is true.
///
/// [onTap], [onDoubleTap], [onLongPress] are callbacks used to register tap gestures
///
/// [timestamp] is an optional string shown at the bottom-right of the bubble
///
/// [isEdited] shows an "Edited" label next to the timestamp when true
///
/// [isForwarded] shows a "Forwarded" banner at the top of the bubble when true
///
/// [messageId] is an optional identifier for tracking purposes

class BubbleNormal extends StatelessWidget {
  /// chat bubble [BorderRadius]
  final double bubbleRadius;
  /// message sender
  final bool isSender;
  /// chat bubble color
  final Color color;
  /// message text
  final String text;
  /// chat bubble tail
  final bool tail;
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
  /// widget displayed before the bubble for non-senders
  final Widget? leading;
  /// widget displayed after the bubble for senders
  final Widget? trailing;
  /// outer margin of the bubble
  final EdgeInsets margin;
  /// inner padding of the bubble
  final EdgeInsets padding;
  /// callback function when the bubble is tapped
  final VoidCallback? onTap;
  /// callback function when the bubble is double tapped
  final VoidCallback? onDoubleTap;
  /// callback function when the bubble is long pressed
  final VoidCallback? onLongPress;
  /// optional timestamp string shown at the bottom-right (e.g. "12:34 PM")
  final String? timestamp;
  /// shows an "Edited" label next to the status area when true
  final bool isEdited;
  /// shows a "Forwarded" banner at the top of the bubble when true
  final bool isForwarded;
  /// optional identifier for tracking the message
  final String? messageId;

  /// Creates a [BubbleNormal] widget
  const BubbleNormal({
    Key? key,
    required this.text,
    this.constraints,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    this.bubbleRadius = defaultBubbleRadius,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.leading,
    this.trailing,
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

    return Row(
      children: <Widget>[
        isSender
            ? Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : leading ?? Container(),
        Container(
          color: Colors.transparent,
          constraints: constraints ??
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
          margin: margin,
          padding: padding,
          child: GestureDetector(
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            onLongPress: onLongPress,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(bubbleRadius),
                  topRight: Radius.circular(bubbleRadius),
                  bottomLeft: Radius.circular(tail
                      ? isSender
                          ? bubbleRadius
                          : 0
                      : defaultBubbleRadius),
                  bottomRight: Radius.circular(tail
                      ? isSender
                          ? 0
                          : bubbleRadius
                      : defaultBubbleRadius),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isForwarded)
                      BubbleForwardedHeader(color: forwardedColor),
                    SelectableText(
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
        ),
        if (isSender && trailing != null) SizedBox.shrink(),
      ],
    );
  }
}
