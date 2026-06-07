import 'package:flutter/material.dart';
import '../utils/bubble_forwarded_header.dart';
import '../utils/timestamped_chat_message.dart';

/// Default border radius for reply bubble
const double defaultBubbleRadiusReply = 16;

/// Reply/Quote bubble widget for displaying quoted messages
///
/// This widget displays a message with a quoted/replied message preview
/// similar to WhatsApp's reply feature.
///
/// The [BorderRadius] can be customized using [bubbleRadius]
///
/// [repliedMessage] is the text of the message being replied to
///
/// [repliedMessageSender] is the name of the sender of the replied message
///
/// [text] is the current message text
///
/// [isSender] determines if the message is from the sender or receiver
///
/// [color] can be customized for the bubble background
///
/// [replyBorderColor] customizes the reply indicator line color
///
/// [tail] boolean is used to add or remove a tail according to the sender type
///
/// [sent], [delivered] and [seen] can be used to display the message state
///
/// [timestamp] is an optional string shown at the bottom-right of the bubble
///
/// [isEdited] shows an "Edited" label next to the status area when true
///
/// [isForwarded] shows a "Forwarded" banner at the top of the bubble when true
///
/// [messageId] is an optional identifier for tracking purposes
class BubbleReply extends StatelessWidget {
  /// the text of the message being replied to
  final String repliedMessage;

  /// the name/identifier of the sender of the replied message
  final String repliedMessageSender;

  /// the current message text
  final String text;

  /// chat bubble [BorderRadius]
  final double bubbleRadius;

  /// message sender
  final bool isSender;

  /// chat bubble color
  final Color color;

  /// reply indicator line color
  final Color replyBorderColor;

  /// background color of the reply section
  final Color? replyBackgroundColor;

  /// chat bubble tail
  final bool tail;

  /// message state - whether the message has been sent
  final bool sent;

  /// message state - whether the message has been delivered
  final bool delivered;

  /// message state - whether the message has been seen
  final bool seen;

  /// text style for the current message
  final TextStyle textStyle;

  /// text style for the replied message
  final TextStyle? repliedMessageTextStyle;

  /// text style for the replied message sender name
  final TextStyle? repliedMessageSenderTextStyle;

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

  /// callback function when the bubble is long pressed
  final VoidCallback? onLongPress;

  /// callback function when the reply section is tapped
  final VoidCallback? onReplyTap;

  /// optional timestamp string shown at the bottom-right (e.g. "12:34 PM")
  final String? timestamp;

  /// shows an "Edited" label next to the status area when true
  final bool isEdited;

  /// shows a "Forwarded" banner at the top of the bubble when true
  final bool isForwarded;

  /// optional identifier for tracking the message
  final String? messageId;

  /// Creates a [BubbleReply] widget
  const BubbleReply({
    super.key,
    required this.repliedMessage,
    required this.repliedMessageSender,
    required this.text,
    this.bubbleRadius = defaultBubbleRadiusReply,
    this.isSender = true,
    this.color = Colors.white70,
    this.replyBorderColor = Colors.blue,
    this.replyBackgroundColor,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    this.repliedMessageTextStyle,
    this.repliedMessageSenderTextStyle,
    this.constraints,
    this.leading,
    this.trailing,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.onTap,
    this.onLongPress,
    this.onReplyTap,
    this.timestamp,
    this.isEdited = false,
    this.isForwarded = false,
    this.messageId,
  });

  @override
  Widget build(BuildContext context) {
    IconData? statusIcon;
    Color statusIconColor = const Color(0xFF97AD8E);
    if (seen) {
      statusIcon = Icons.done_all;
      statusIconColor = const Color(0xFF92DEDA);
    } else if (delivered) {
      statusIcon = Icons.done_all;
    } else if (sent) {
      statusIcon = Icons.done;
    }

    final Color forwardedColor =
        (textStyle.color ?? Colors.black87).withValues(alpha: 0.6);

    final defaultRepliedSenderStyle = TextStyle(
      color: isSender ? Colors.white : replyBorderColor,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    final defaultRepliedMessageStyle = TextStyle(
      color: isSender ? Colors.white70 : Colors.black54,
      fontSize: 13,
    );

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
                      : defaultBubbleRadiusReply),
                  bottomRight: Radius.circular(tail
                      ? isSender
                          ? 0
                          : bubbleRadius
                      : defaultBubbleRadiusReply),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Forwarded banner (shown above the reply section)
                  if (isForwarded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                      child: BubbleForwardedHeader(color: forwardedColor),
                    ),
                  // Reply section
                  GestureDetector(
                    onTap: onReplyTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: replyBackgroundColor ??
                            (isSender
                                ? Colors.black.withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.1)),
                        borderRadius: BorderRadius.only(
                          topLeft:
                              Radius.circular(isForwarded ? 0 : bubbleRadius),
                          topRight:
                              Radius.circular(isForwarded ? 0 : bubbleRadius),
                        ),
                      ),
                      padding: EdgeInsets.all(8),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              decoration: BoxDecoration(
                                color: replyBorderColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    repliedMessageSender,
                                    style: repliedMessageSenderTextStyle ??
                                        defaultRepliedSenderStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    repliedMessage,
                                    style: repliedMessageTextStyle ??
                                        defaultRepliedMessageStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Current message section
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TimestampedChatMessage(
                          text: text,
                          textStyle: textStyle,
                          timestamp: timestamp,
                          isEdited: isEdited,
                          statusIcon: statusIcon,
                          statusIconColor: statusIconColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isSender && trailing != null) SizedBox.shrink(),
      ],
    );
  }
}
