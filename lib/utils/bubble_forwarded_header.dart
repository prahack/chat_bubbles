import 'package:flutter/material.dart';

/// Internal helper widget that renders a "Forwarded" banner
/// inside the bubble when [isForwarded] is true.
///
/// Displays a reply/forward icon followed by the text "Forwarded"
/// in a subtle italic style, matching WhatsApp's forwarded indicator.
class BubbleForwardedHeader extends StatelessWidget {
  /// Color used for the icon and text
  final Color color;

  /// Creates a [BubbleForwardedHeader] widget
  const BubbleForwardedHeader({
    Key? key,
    this.color = Colors.black54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.reply, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            'Forwarded',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
