/// Grouping information for a single message within a consecutive sender block.
///
/// Use the values from this class to control how each bubble is rendered:
/// - Pass [showTail] to the bubble's `tail` parameter
/// - Show an avatar widget only when [showAvatar] is true
/// - Add extra top spacing when [isGroupStart] is true
class GroupInfo {
  /// Whether this is the first message in a consecutive block from the same sender
  final bool isGroupStart;

  /// Whether this is the last message in the block (tail should be shown)
  final bool isGroupEnd;

  /// Whether this is the only message from this sender in this block
  final bool isAlone;

  /// Convenience alias for [isGroupEnd] — pass this to the bubble's `tail` param
  final bool showTail;

  /// Whether an avatar should be shown beside this bubble.
  /// True when [isGroupEnd] or [isAlone].
  final bool showAvatar;

  /// Creates a [GroupInfo] instance
  const GroupInfo({
    required this.isGroupStart,
    required this.isGroupEnd,
    required this.isAlone,
    required this.showTail,
    required this.showAvatar,
  });

  @override
  String toString() =>
      'GroupInfo(start=$isGroupStart, end=$isGroupEnd, alone=$isAlone)';
}

/// Utility class that computes [GroupInfo] for a flat list of messages.
///
/// Two consecutive messages belong to the same group when:
/// - They have the same [senderId], AND
/// - Either no timestamps are provided, OR the time gap between them is less
///   than [threshold].
///
/// ## Example
///
/// ```dart
/// final ids = ['alice', 'alice', 'bob', 'alice'];
/// final infos = MessageGroupHelper.compute(senderIds: ids);
/// // infos[0]: isGroupStart=true,  isGroupEnd=false, showTail=false
/// // infos[1]: isGroupStart=false, isGroupEnd=true,  showTail=true
/// // infos[2]: isGroupStart=true,  isGroupEnd=true,  showTail=true, isAlone=true
/// // infos[3]: isGroupStart=true,  isGroupEnd=true,  showTail=true, isAlone=true
/// ```
class MessageGroupHelper {
  MessageGroupHelper._();

  /// Computes grouping information for each message in the list.
  ///
  /// [senderIds] — ordered list of sender identifiers (one per message).
  ///
  /// [timestamps] — optional list of message timestamps (same length as
  /// [senderIds]). When provided, messages separated by more than [threshold]
  /// are placed in separate groups even if they share a sender.
  ///
  /// [threshold] — maximum time gap within the same group.
  /// Defaults to 1 minute.
  ///
  /// Returns a [List<GroupInfo>] of the same length as [senderIds].
  static List<GroupInfo> compute({
    required List<String> senderIds,
    List<DateTime>? timestamps,
    Duration threshold = const Duration(minutes: 1),
  }) {
    assert(
      timestamps == null || timestamps.length == senderIds.length,
      'timestamps must have the same length as senderIds',
    );

    final int count = senderIds.length;
    if (count == 0) return const [];

    final List<GroupInfo> result = List.filled(
      count,
      const GroupInfo(
        isGroupStart: true,
        isGroupEnd: true,
        isAlone: true,
        showTail: true,
        showAvatar: true,
      ),
    );

    for (int i = 0; i < count; i++) {
      final bool hasPrev = i > 0;
      final bool hasNext = i < count - 1;

      final bool sameAsPrev = hasPrev &&
          senderIds[i] == senderIds[i - 1] &&
          _withinThreshold(timestamps, i - 1, i, threshold);

      final bool sameAsNext = hasNext &&
          senderIds[i] == senderIds[i + 1] &&
          _withinThreshold(timestamps, i, i + 1, threshold);

      final bool isGroupStart = !sameAsPrev;
      final bool isGroupEnd = !sameAsNext;
      final bool isAlone = isGroupStart && isGroupEnd;

      result[i] = GroupInfo(
        isGroupStart: isGroupStart,
        isGroupEnd: isGroupEnd,
        isAlone: isAlone,
        showTail: isGroupEnd,
        showAvatar: isGroupEnd,
      );
    }

    return result;
  }

  static bool _withinThreshold(
    List<DateTime>? timestamps,
    int indexA,
    int indexB,
    Duration threshold,
  ) {
    if (timestamps == null) return true;
    final Duration gap =
        timestamps[indexB].difference(timestamps[indexA]).abs();
    return gap <= threshold;
  }
}
