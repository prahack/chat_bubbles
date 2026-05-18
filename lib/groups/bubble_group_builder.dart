import 'package:flutter/material.dart';
import 'message_group_helper.dart';

/// A widget that builds a vertically stacked list of chat bubbles with
/// automatic message grouping.
///
/// Consecutive messages from the same sender (within [groupingThreshold])
/// are grouped together. The last message in each group receives a tail
/// ([GroupInfo.showTail] = true); earlier messages in the same group do not.
///
/// Use [itemBuilder] to construct the appropriate bubble widget. The
/// [GroupInfo] parameter tells you whether to show the tail, an avatar, etc.
///
/// ## Example
///
/// ```dart
/// final messages = ['Hello', 'How are you?', 'Good thanks!'];
/// final senders  = ['alice', 'alice', 'bob'];
///
/// BubbleGroupBuilder(
///   itemCount: messages.length,
///   senderIdOf: (i) => senders[i],
///   itemBuilder: (context, i, info) => BubbleNormal(
///     text: messages[i],
///     isSender: senders[i] == 'bob',
///     tail: info.showTail,
///     color: senders[i] == 'bob'
///         ? const Color(0xFFE8E8EE)
///         : const Color(0xFF1B97F3),
///   ),
/// )
/// ```
class BubbleGroupBuilder extends StatelessWidget {
  /// Total number of messages
  final int itemCount;

  /// Returns the sender identifier for the message at [index]
  final String Function(int index) senderIdOf;

  /// Optional: returns the send timestamp for the message at [index].
  /// Used to break groups when a time gap exceeds [groupingThreshold].
  final DateTime? Function(int index)? timestampOf;

  /// Builds the bubble widget for [index].
  ///
  /// Use [info] to derive:
  /// - `tail: info.showTail`
  /// - Show an avatar only when `info.showAvatar`
  /// - Add extra top margin when `info.isGroupStart`
  final Widget Function(BuildContext context, int index, GroupInfo info)
      itemBuilder;

  /// Maximum time gap between two consecutive messages from the same sender
  /// before they are split into separate groups. Defaults to 1 minute.
  final Duration groupingThreshold;

  /// Vertical spacing between bubbles within the same group
  final double itemSpacing;

  /// Vertical spacing between separate groups
  final double groupSpacing;

  /// Creates a [BubbleGroupBuilder] widget
  const BubbleGroupBuilder({
    super.key,
    required this.itemCount,
    required this.senderIdOf,
    required this.itemBuilder,
    this.timestampOf,
    this.groupingThreshold = const Duration(minutes: 1),
    this.itemSpacing = 2.0,
    this.groupSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();

    final List<String> ids =
        List.generate(itemCount, (i) => senderIdOf(i));

    final List<DateTime>? timestamps = timestampOf != null
        ? List.generate(itemCount, (i) => timestampOf!(i) ?? DateTime(0))
        : null;

    final List<GroupInfo> groups = MessageGroupHelper.compute(
      senderIds: ids,
      timestamps: timestamps,
      threshold: groupingThreshold,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(itemCount, (i) {
        final GroupInfo info = groups[i];
        final double topPadding =
            info.isGroupStart ? groupSpacing : itemSpacing;

        return Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : topPadding),
          child: itemBuilder(context, i, info),
        );
      }),
    );
  }
}
