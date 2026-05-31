import 'package:flutter/material.dart';

/// Internal helper widget that renders the message status row.
///
/// Displays: [Edited label] [timestamp] [state icon]
///
/// Used internally by all bubble widgets to show delivery status,
/// optional timestamp, and optional "Edited" label in a consistent row.
class BubbleStatusRow extends StatelessWidget {
  /// The delivery state icon (sent/delivered/seen), or null
  final Icon? stateIcon;

  /// Whether to show the "Edited" label
  final bool isEdited;

  /// Optional timestamp string to display (e.g. "12:34 PM")
  final String? timestamp;

  /// Color used for the text elements (timestamp and edited label)
  final Color textColor;

  /// Creates a [BubbleStatusRow] widget
  const BubbleStatusRow({
    super.key,
    this.stateIcon,
    this.isEdited = false,
    this.timestamp,
    this.textColor = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasContent =
        isEdited || timestamp != null || stateIcon != null;
    if (!hasContent) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isEdited) ...[
          Text(
            'Edited',
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 4),
        ],
        if (timestamp != null) ...[
          Text(
            timestamp!,
            style: TextStyle(
              fontSize: 11,
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
          if (stateIcon != null) const SizedBox(width: 3),
        ],
        if (stateIcon != null) stateIcon!,
      ],
    );
  }
}
