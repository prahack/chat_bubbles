import 'package:flutter/material.dart';
import '../utils/bubble_forwarded_header.dart';
import '../utils/bubble_status_row.dart';

/// Default border radius for link preview bubble
const double defaultBubbleRadiusLinkPreview = 16;

/// Link preview bubble widget for displaying URL previews
///
/// This widget displays a message with a link preview card showing
/// metadata like title, description, and image from the URL.
///
/// The [BorderRadius] can be customized using [bubbleRadius]
///
/// [url] is the URL to preview
///
/// [title] is the title extracted from the URL
///
/// [description] is the description extracted from the URL
///
/// [imageUrl] is the preview image URL
///
/// [text] is the message text (optional)
///
/// [isSender] determines if the message is from the sender or receiver
///
/// [color] can be customized for the bubble background
///
/// [timestamp] is an optional string shown at the bottom-right of the bubble
///
/// [isEdited] shows an "Edited" label next to the status area when true
///
/// [isForwarded] shows a "Forwarded" banner at the top of the bubble when true
///
/// [messageId] is an optional identifier for tracking purposes
class BubbleLinkPreview extends StatelessWidget {
  /// the URL being previewed
  final String url;
  
  /// the title of the link preview
  final String? title;
  
  /// the description of the link preview
  final String? description;
  
  /// the preview image URL
  final String? imageUrl;
  
  /// optional message text accompanying the link
  final String? text;
  
  /// chat bubble [BorderRadius]
  final double bubbleRadius;
  
  /// message sender
  final bool isSender;
  
  /// chat bubble color
  final Color color;
  
  /// link preview card background color
  final Color? previewBackgroundColor;
  
  /// chat bubble tail
  final bool tail;
  
  /// message state - whether the message has been sent
  final bool sent;
  
  /// message state - whether the message has been delivered
  final bool delivered;
  
  /// message state - whether the message has been seen
  final bool seen;
  
  /// text style for the message text
  final TextStyle textStyle;
  
  /// text style for the link preview title
  final TextStyle? titleTextStyle;
  
  /// text style for the link preview description
  final TextStyle? descriptionTextStyle;
  
  /// text style for the URL
  final TextStyle? urlTextStyle;
  
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
  
  /// callback function when the link preview is tapped
  final VoidCallback? onLinkTap;
  
  /// height of the preview image
  final double? imageHeight;
  
  /// whether to show the preview image
  final bool showImage;

  /// optional timestamp string shown at the bottom-right (e.g. "12:34 PM")
  final String? timestamp;

  /// shows an "Edited" label next to the status area when true
  final bool isEdited;

  /// shows a "Forwarded" banner at the top of the bubble when true
  final bool isForwarded;

  /// optional identifier for tracking the message
  final String? messageId;

  /// Creates a [BubbleLinkPreview] widget
  const BubbleLinkPreview({
    super.key,
    required this.url,
    this.title,
    this.description,
    this.imageUrl,
    this.text,
    this.bubbleRadius = defaultBubbleRadiusLinkPreview,
    this.isSender = true,
    this.color = Colors.white70,
    this.previewBackgroundColor,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.urlTextStyle,
    this.constraints,
    this.leading,
    this.trailing,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.onTap,
    this.onLongPress,
    this.onLinkTap,
    this.imageHeight = 150,
    this.showImage = true,
    this.timestamp,
    this.isEdited = false,
    this.isForwarded = false,
    this.messageId,
  });

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
        (textStyle.color ?? Colors.black87).withValues(alpha: 0.6);

    final defaultTitleStyle = TextStyle(
      color: Colors.black87,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );

    final defaultDescriptionStyle = TextStyle(
      color: Colors.black54,
      fontSize: 13,
    );

    final defaultUrlStyle = TextStyle(
      color: Colors.blue,
      fontSize: 12,
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
                      : defaultBubbleRadiusLinkPreview),
                  bottomRight: Radius.circular(tail
                      ? isSender
                          ? 0
                          : bubbleRadius
                      : defaultBubbleRadiusLinkPreview),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Forwarded banner
                  if (isForwarded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: BubbleForwardedHeader(color: forwardedColor),
                    ),
                  // Message text (if provided)
                  if (text != null && text!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: SelectableText(
                        text!,
                        style: textStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  // Link preview card
                  GestureDetector(
                    onTap: onLinkTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: previewBackgroundColor ??
                            Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: (text == null || text!.isEmpty) && !isForwarded
                              ? Radius.circular(bubbleRadius)
                              : Radius.zero,
                          topRight: (text == null || text!.isEmpty) && !isForwarded
                              ? Radius.circular(bubbleRadius)
                              : Radius.zero,
                          bottomLeft: Radius.circular(tail
                              ? isSender
                                  ? bubbleRadius
                                  : 0
                              : defaultBubbleRadiusLinkPreview),
                          bottomRight: Radius.circular(tail
                              ? isSender
                                  ? 0
                                  : bubbleRadius
                              : defaultBubbleRadiusLinkPreview),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Preview image
                          if (showImage && imageUrl != null && imageUrl!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: (text == null || text!.isEmpty) && !isForwarded
                                    ? Radius.circular(bubbleRadius)
                                    : Radius.zero,
                                topRight: (text == null || text!.isEmpty) && !isForwarded
                                    ? Radius.circular(bubbleRadius)
                                    : Radius.zero,
                              ),
                              child: Image.network(
                                imageUrl!,
                                height: imageHeight,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: imageHeight,
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey[600],
                                    ),
                                  );
                                },
                              ),
                            ),
                          // Preview content
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                if (title != null && title!.isNotEmpty)
                                  Text(
                                    title!,
                                    style: titleTextStyle ?? defaultTitleStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                // Description
                                if (description != null && description!.isNotEmpty) ...[
                                  SizedBox(height: 4),
                                  Text(
                                    description!,
                                    style: descriptionTextStyle ?? defaultDescriptionStyle,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                // URL
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.link,
                                      size: 14,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        url,
                                        style: urlTextStyle ?? defaultUrlStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Message status row
                  if (showStatusArea)
                    Padding(
                      padding: const EdgeInsets.only(right: 8, bottom: 6, top: 4),
                      child: Align(
                        alignment: Alignment.centerRight,
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
        if (isSender && trailing != null) SizedBox.shrink(),
      ],
    );
  }
}
