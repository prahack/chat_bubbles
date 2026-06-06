import 'package:flutter/material.dart';
import '../utils/bubble_forwarded_header.dart';
import '../utils/bubble_status_row.dart';

///chat bubble default [BorderRadius]
const double defaultBubbleRadiusImage = 16;

/// Basic image bubble
///
/// Image bubble should have [id] to work with Hero animations
/// [id] must be a unique value and is also required
///
/// The [BorderRadius] can be customized using [bubbleRadius]
///
/// [margin] and [padding] can be used to add space around or within
/// the bubble respectively
///
/// Color can be customized using [color]
///
/// [tail] boolean is used to add or remove a tail accoring to the sender type
///
/// Display image can be changed using [image]
///
/// [image] is a required parameter
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
/// [onTap], [onLongPress] are callbacks used to register tap gestures
///
/// [timestamp] is an optional string overlaid at the bottom-right of the image
///
/// [isForwarded] shows a "Forwarded" banner overlaid at the top of the image
///
/// [messageId] is an optional identifier for tracking purposes

class BubbleNormalImage extends StatelessWidget {
  /// basic loading widget
  static const loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  /// widget id for Hero animation
  final String id;

  /// image widget
  final Widget image;

  /// chat bubble [BorderRadius]
  final double bubbleRadius;

  /// message sender
  final bool isSender;

  /// chat bubble color
  final Color color;

  /// chat bubble tail
  final bool tail;

  /// message state - whether the message has been sent
  final bool sent;

  /// message state - whether the message has been delivered
  final bool delivered;

  /// message state - whether the message has been seen
  final bool seen;

  /// callback function when the bubble is tapped
  final VoidCallback? onTap;

  /// callback function when the bubble is long pressed
  final VoidCallback? onLongPress;

  /// widget displayed before the bubble for non-senders
  final Widget? leading;

  /// widget displayed after the bubble for senders
  final Widget? trailing;

  /// outer margin of the bubble
  final EdgeInsets? margin;

  /// inner padding of the bubble
  final EdgeInsets? padding;

  /// optional timestamp string overlaid at the bottom-right of the image
  final String? timestamp;

  /// shows a "Forwarded" banner overlaid at the top of the image when true
  final bool isForwarded;

  /// optional identifier for tracking the message
  final String? messageId;

  /// Creates a [BubbleNormalImage] widget
  const BubbleNormalImage({
    super.key,
    required this.id,
    required this.image,
    this.bubbleRadius = defaultBubbleRadiusImage,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 8),
    this.leading,
    this.trailing,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.onTap,
    this.onLongPress,
    this.timestamp,
    this.isForwarded = false,
    this.messageId,
  });

  /// image bubble builder method
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

    final bool showStatusArea = stateTick || timestamp != null;

    return Row(
      children: <Widget>[
        isSender
            ? const Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : leading ?? Container(),
        Container(
          padding: padding,
          margin: margin,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * .5,
            maxHeight: MediaQuery.of(context).size.width * .5,
          ),
          child: GestureDetector(
            onLongPress: onLongPress,
            onTap: onTap ??
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return _DetailScreen(
                      tag: id,
                      image: image,
                    );
                  }));
                },
            child: Hero(
              tag: id,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(bubbleRadius),
                        topRight: Radius.circular(bubbleRadius),
                        bottomLeft: Radius.circular(tail
                            ? isSender
                                ? bubbleRadius
                                : 0
                            : defaultBubbleRadiusImage),
                        bottomRight: Radius.circular(tail
                            ? isSender
                                ? 0
                                : bubbleRadius
                            : defaultBubbleRadiusImage),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(bubbleRadius),
                        child: image,
                      ),
                    ),
                  ),
                  if (isForwarded)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const BubbleForwardedHeader(color: Colors.white),
                      ),
                    ),
                  if (showStatusArea)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: BubbleStatusRow(
                          stateIcon: stateTick ? stateIcon : null,
                          timestamp: timestamp,
                          textColor: Colors.white,
                        ),
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

/// detail screen of the image, display when tap on the image bubble
class _DetailScreen extends StatefulWidget {
  final String tag;
  final Widget image;

  const _DetailScreen({required this.tag, required this.image});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

/// created using the Hero Widget
class _DetailScreenState extends State<_DetailScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Center(
          child: Hero(
            tag: widget.tag,
            child: widget.image,
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
