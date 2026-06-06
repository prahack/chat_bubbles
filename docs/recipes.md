# chat_bubbles recipes

Copy-paste-ready snippets for common scenarios. Each recipe is a complete, runnable widget. All examples assume:

```dart
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
```

---

## 1. Basic chat list

A scrolling list of text bubbles alternating between sender and receiver, with a date separator at the top.

```dart
class BasicChat extends StatelessWidget {
  const BasicChat({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      reverse: true, // newest at the bottom, like WhatsApp
      children: [
        const BubbleNormal(
          text: 'Hey, are you free?',
          isSender: false,
          color: Color(0xFFE8E8EE),
          tail: true,
        ),
        const BubbleNormal(
          text: 'Yes, what\'s up?',
          isSender: true,
          color: Color(0xFF1B97F3),
          tail: true,
          textStyle: TextStyle(color: Colors.white, fontSize: 16),
          seen: true,
        ),
        DateChip(date: DateTime.now()),
      ],
    );
  }
}
```

Key params: `isSender` flips left/right alignment. `tail` draws the bubble pointer. `sent`/`delivered`/`seen` render status ticks (sender side only).

---

## 2. Reply UI (BubbleReply + MessageBar with reply preview)

A bubble that quotes a previous message, plus a message bar in reply mode.

```dart
class ReplyExample extends StatefulWidget {
  const ReplyExample({super.key});
  @override
  State<ReplyExample> createState() => _ReplyExampleState();
}

class _ReplyExampleState extends State<ReplyExample> {
  String? _replyingTo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              BubbleReply(
                repliedMessage: 'Are we still on for lunch?',
                repliedMessageSender: 'Alex',
                text: 'Yes, 1pm at the usual place.',
                isSender: true,
                color: const Color(0xFF1B97F3),
                textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                onReplyTap: () {
                  // scroll to the original message
                },
              ),
            ],
          ),
        ),
        MessageBar(
          replying: _replyingTo != null,
          replyingTo: _replyingTo ?? '',
          onTapCloseReply: () => setState(() => _replyingTo = null),
          onSend: (text) {
            // send the message, then clear reply state
            setState(() => _replyingTo = null);
          },
        ),
      ],
    );
  }
}
```

---

## 3. Audio bubble with waveform + playback speed (v1.9+)

```dart
class AudioBubbleExample extends StatefulWidget {
  const AudioBubbleExample({super.key});
  @override
  State<AudioBubbleExample> createState() => _AudioBubbleExampleState();
}

class _AudioBubbleExampleState extends State<AudioBubbleExample> {
  bool _playing = false;
  Duration _position = Duration.zero;
  final Duration _duration = const Duration(seconds: 30);
  double _speed = 1.0;

  // Replace with real waveform data from your audio file (values 0.0–1.0).
  final List<double> _waveform =
      List.generate(60, (i) => 0.3 + 0.7 * (i % 5) / 5);

  @override
  Widget build(BuildContext context) {
    return BubbleNormalAudio(
      isSender: true,
      color: const Color(0xFF1B97F3),
      isPlaying: _playing,
      duration: _duration.inMilliseconds.toDouble(),
      position: _position.inMilliseconds.toDouble(),
      isLoading: false,
      onPlayPauseButtonClick: () => setState(() => _playing = !_playing),
      onSeekChanged: (ms) {
        setState(() => _position = Duration(milliseconds: ms.toInt()));
      },
      waveformData: _waveform,
      waveformActiveColor: Colors.white,
      waveformInactiveColor: Colors.white54,
      showPlaybackSpeed: true,
      playbackSpeed: _speed,
      onPlaybackSpeedChanged: (s) => setState(() => _speed = s),
    );
  }
}
```

`waveformData` is optional — omit it and the widget falls back to a standard `Slider`. The package does NOT play audio; wire `onPlayPauseButtonClick`/`onSeekChanged` to your audio engine (e.g., `audioplayers`, `just_audio`).

---

## 4. Image bubble

```dart
BubbleNormalImage(
  id: 'msg-42',
  image: Image.network(
    'https://example.com/photo.jpg',
    fit: BoxFit.cover,
  ),
  isSender: false,
  color: const Color(0xFFE8E8EE),
  tail: true,
  onTap: () {
    // open full-screen viewer
  },
);
```

You supply the `Image` widget — the package doesn't pull in `cached_network_image` or any image library. Use whatever loader you prefer.

---

## 5. Reactions (chip row under a bubble + long-press picker)

```dart
class ReactionExample extends StatefulWidget {
  const ReactionExample({super.key});
  @override
  State<ReactionExample> createState() => _ReactionExampleState();
}

class _ReactionExampleState extends State<ReactionExample> {
  final List<Reaction> _reactions = [
    Reaction(emoji: '❤️', count: 3, reactedByCurrentUser: true),
    Reaction(emoji: '😂', count: 1),
  ];

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ReactionPicker(
        onReactionSelected: (emoji) {
          Navigator.pop(context);
          setState(() {
            _reactions.add(Reaction(emoji: emoji, count: 1, reactedByCurrentUser: true));
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BubbleNormal(
          text: 'Great news everyone!',
          isSender: false,
          color: const Color(0xFFE8E8EE),
          onLongPress: () => _showPicker(context),
        ),
        BubbleReaction(
          reactions: _reactions,
          onAddReactionTap: () => _showPicker(context),
        ),
      ],
    );
  }
}
```

---

## 6. Swipe to reply / delete

Wrap any bubble in `SwipeableBubble`. Swipe right reveals the reply action, swipe left reveals delete.

```dart
SwipeableBubble(
  onSwipeRight: () {
    // enter reply mode for this message
  },
  onSwipeLeft: () {
    // delete this message
  },
  rightActionIcon: const Icon(Icons.reply, color: Colors.white),
  leftActionIcon: const Icon(Icons.delete, color: Colors.white),
  swipeThreshold: 80,
  child: const BubbleNormal(
    text: 'Try swiping me left or right',
    isSender: false,
    color: Color(0xFFE8E8EE),
  ),
);
```

`enableHaptics: true` (default) fires haptic feedback when the threshold is crossed.

---

## 7. Message grouping (consecutive same-sender clustering)

`BubbleGroupBuilder` is a `ListView` replacement that automatically tightens spacing between consecutive messages from the same sender, hides the tail on all but the last bubble in a group, and inserts larger spacing between groups.

```dart
class Message {
  final String text, senderId;
  final DateTime time;
  Message(this.text, this.senderId, this.time);
}

final messages = [
  Message('Hey', 'alex', DateTime.now().subtract(const Duration(minutes: 5))),
  Message('You there?', 'alex', DateTime.now().subtract(const Duration(minutes: 5))),
  Message('Yes!', 'me', DateTime.now()),
  Message('Just got back', 'me', DateTime.now()),
];

BubbleGroupBuilder(
  itemCount: messages.length,
  senderIdOf: (i) => messages[i].senderId,
  timestampOf: (i) => messages[i].time,
  groupingThreshold: const Duration(minutes: 2),
  itemSpacing: 2,
  groupSpacing: 12,
  itemBuilder: (context, i, info) {
    final m = messages[i];
    return BubbleNormal(
      text: m.text,
      isSender: m.senderId == 'me',
      tail: info.showTail, // only on the last bubble in a group
      color: m.senderId == 'me' ? const Color(0xFF1B97F3) : const Color(0xFFE8E8EE),
    );
  },
);
```

The `GroupInfo` passed to `itemBuilder` exposes `showTail`, `showAvatar`, `isGroupStart`, `isGroupEnd`, `isAlone` — use them to decide what to render.

---

## 8. Custom message bar (v1.10: MessageBarStyle + sendButton)

```dart
MessageBar(
  messageBarColor: Colors.grey.shade100,
  messageBarHintText: 'Message',
  messageBarStyle: const MessageBarStyle(
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(24)),
      borderSide: BorderSide(color: Colors.black12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(24)),
      borderSide: BorderSide(color: Colors.blue),
    ),
    minLines: 1,
    maxLines: 5,
    keyboardType: TextInputType.multiline,
  ),
  sendButton: Container(
    padding: const EdgeInsets.all(8),
    decoration: const BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
  ),
  onSend: (text) {
    // dispatch to your message store
  },
);
```

`MessageBarStyle` defaults match the pre-v1.10 hardcoded appearance, so adding it is non-breaking. `sendButton` replaces the default `Icons.send` with any widget — wrap it in a `GestureDetector` if you need custom tap handling beyond `onSend`.

---

## See also

- [Full API reference on pub.dev](https://pub.dev/documentation/chat_bubbles/latest/) — every public class and parameter
- [example/lib/main.dart](../example/lib/main.dart) — single-file runnable app demonstrating every widget
- [llms.txt](../llms.txt) — AI-agent-friendly entry point
