import 'package:flutter/material.dart';

/// Reaction data model
class Reaction {
  /// the emoji or reaction icon
  final String emoji;
  
  /// count of users who reacted with this emoji
  final int count;
  
  /// whether the current user has reacted with this emoji
  final bool isUserReacted;

  /// Creates a [Reaction]
  const Reaction({
    required this.emoji,
    this.count = 1,
    this.isUserReacted = false,
  });
}

/// Bubble reaction widget for displaying emoji reactions
///
/// This widget displays emoji reactions on chat bubbles similar to
/// Facebook Messenger, Slack, or Discord.
///
/// [reactions] is the list of reactions to display
///
/// [onReactionTap] is called when a reaction is tapped
///
/// [onAddReactionTap] is called when the add reaction button is tapped
class BubbleReaction extends StatelessWidget {
  /// list of reactions to display
  final List<Reaction> reactions;
  
  /// callback when a reaction is tapped
  final Function(Reaction)? onReactionTap;
  
  /// callback when add reaction button is tapped
  final VoidCallback? onAddReactionTap;
  
  /// whether to show the add reaction button
  final bool showAddButton;
  
  /// background color of reaction chips
  final Color backgroundColor;
  
  /// background color of user's own reactions
  final Color userReactionColor;
  
  /// text color for reaction count
  final Color textColor;
  
  /// border color for reaction chips
  final Color? borderColor;
  
  /// size of the emoji
  final double emojiSize;
  
  /// padding inside each reaction chip
  final EdgeInsets chipPadding;
  
  /// spacing between reaction chips
  final double spacing;
  
  /// border radius of reaction chips
  final double borderRadius;
  
  /// whether reactions are aligned to the right (for sender messages)
  final bool alignRight;

  /// Creates a [BubbleReaction] widget
  const BubbleReaction({
    super.key,
    required this.reactions,
    this.onReactionTap,
    this.onAddReactionTap,
    this.showAddButton = true,
    this.backgroundColor = const Color(0xFFF0F0F0),
    this.userReactionColor = const Color(0xFFE3F2FD),
    this.textColor = Colors.black87,
    this.borderColor,
    this.emojiSize = 16,
    this.chipPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.spacing = 4,
    this.borderRadius = 12,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    if (reactions.isEmpty && !showAddButton) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(
        top: 4,
        left: alignRight ? 0 : 8,
        right: alignRight ? 8 : 0,
      ),
      child: Align(
        alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: alignRight ? WrapAlignment.end : WrapAlignment.start,
          children: [
            ...reactions.map((reaction) => _ReactionChip(
                  reaction: reaction,
                  onTap: onReactionTap != null
                      ? () => onReactionTap!(reaction)
                      : null,
                  backgroundColor: reaction.isUserReacted
                      ? userReactionColor
                      : backgroundColor,
                  textColor: textColor,
                  borderColor: borderColor,
                  emojiSize: emojiSize,
                  padding: chipPadding,
                  borderRadius: borderRadius,
                )),
            if (showAddButton && onAddReactionTap != null)
              _AddReactionButton(
                onTap: onAddReactionTap!,
                backgroundColor: backgroundColor,
                borderColor: borderColor,
                padding: chipPadding,
                borderRadius: borderRadius,
              ),
          ],
        ),
      ),
    );
  }
}

class _ReactionChip extends StatelessWidget {
  final Reaction reaction;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double emojiSize;
  final EdgeInsets padding;
  final double borderRadius;

  const _ReactionChip({
    required this.reaction,
    this.onTap,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    required this.emojiSize,
    required this.padding,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              reaction.emoji,
              style: TextStyle(fontSize: emojiSize),
            ),
            if (reaction.count > 1) ...[
              SizedBox(width: 4),
              Text(
                '${reaction.count}',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddReactionButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color? borderColor;
  final EdgeInsets padding;
  final double borderRadius;

  const _AddReactionButton({
    required this.onTap,
    required this.backgroundColor,
    this.borderColor,
    required this.padding,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1)
              : Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Icon(
          Icons.add,
          size: 16,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}

/// Reaction picker widget for selecting reactions
///
/// This widget displays a horizontal list of emoji reactions
/// that users can select from.
class ReactionPicker extends StatelessWidget {
  /// list of available emoji reactions
  final List<String> reactions;
  
  /// callback when a reaction is selected
  final Function(String)? onReactionSelected;
  
  /// background color of the picker
  final Color backgroundColor;
  
  /// size of each emoji
  final double emojiSize;
  
  /// padding around the picker
  final EdgeInsets padding;
  
  /// border radius of the picker
  final double borderRadius;
  
  /// spacing between emojis
  final double spacing;

  /// Creates a [ReactionPicker] widget
  const ReactionPicker({
    super.key,
    this.reactions = const ['❤️', '👍', '😂', '😮', '😢', '🙏'],
    this.onReactionSelected,
    this.backgroundColor = Colors.white,
    this.emojiSize = 28,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.borderRadius = 24,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: reactions.map((emoji) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing / 2),
            child: GestureDetector(
              onTap: () {
                if (onReactionSelected != null) {
                  onReactionSelected!(emoji);
                }
              },
              child: Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: emojiSize),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Reaction overlay widget that can be shown above a message
///
/// This widget wraps a message bubble and shows a reaction picker
/// when long-pressed.
class ReactionOverlay extends StatefulWidget {
  /// the child widget (typically a chat bubble)
  final Widget child;
  
  /// list of available reactions
  final List<String> reactions;
  
  /// callback when a reaction is selected
  final Function(String)? onReactionSelected;
  
  /// whether to enable the reaction overlay
  final bool enabled;

  /// Creates a [ReactionOverlay] widget
  const ReactionOverlay({
    super.key,
    required this.child,
    this.reactions = const ['❤️', '👍', '😂', '😮', '😢', '🙏'],
    this.onReactionSelected,
    this.enabled = true,
  });

  @override
  State<ReactionOverlay> createState() => _ReactionOverlayState();
}

class _ReactionOverlayState extends State<ReactionOverlay> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _key = GlobalKey();

  void _showReactionPicker() {
    if (!widget.enabled) return;

    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _hideReactionPicker,
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy - 60,
            child: ReactionPicker(
              reactions: widget.reactions,
              onReactionSelected: (emoji) {
                _hideReactionPicker();
                if (widget.onReactionSelected != null) {
                  widget.onReactionSelected!(emoji);
                }
              },
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideReactionPicker() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideReactionPicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onLongPress: _showReactionPicker,
      child: widget.child,
    );
  }
}
