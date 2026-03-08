import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:audioplayers/audioplayers.dart';
import "package:cached_network_image/cached_network_image.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat bubble example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'chat bubble example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// Demo waveform data — 40 bars of normalized amplitudes
const List<double> _demoWaveform = [
  0.2, 0.5, 0.8, 0.4, 0.9, 0.6, 0.3, 0.7, 0.5, 0.8,
  0.6, 0.4, 0.9, 0.7, 0.5, 0.3, 0.8, 0.6, 0.4, 0.7,
  0.5, 0.9, 0.6, 0.3, 0.7, 0.5, 0.8, 0.4, 0.6, 0.9,
  0.7, 0.5, 0.3, 0.8, 0.6, 0.4, 0.7, 0.5, 0.9, 0.6,
];

// Demo messages for BubbleGroupBuilder
const List<String> _groupMessages = [
  'Hey there!',
  'How are you doing?',
  'Hope all is well',
  'Doing great, thanks!',
  'Let me know if you need anything',
  'Will do, thanks!',
  'Catch you later',
];

const List<String> _groupSenders = [
  'alice', 'alice', 'alice',
  'bob',
  'alice',
  'bob', 'bob',
];

class _MyHomePageState extends State<MyHomePage> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration? duration = Duration();
  Duration? position = Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;

  // Waveform audio demo state
  double _wavePlaybackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
        isLoading = false;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      if (isPlaying) {
        setState(() {
          position = p;
        });
      }
    });
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        duration = Duration();
        position = Duration();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                BubbleNormalImage(
                  id: 'id001',
                  image: _image(),
                  color: Colors.purpleAccent,
                  tail: true,
                  delivered: true,
                ),
                BubbleNormalAudio(
                  color: Color(0xFFE8E8EE),
                  duration:
                      duration == null ? 0.0 : duration!.inSeconds.toDouble(),
                  position:
                      position == null ? 0.0 : position!.inSeconds.toDouble(),
                  isPlaying: isPlaying,
                  isLoading: isLoading,
                  isPause: isPause,
                  onSeekChanged: _changeSeek,
                  onPlayPauseButtonClick: _playAudio,
                  sent: true,
                ),
                BubbleNormal(
                  text: 'bubble normal with tail',
                  isSender: false,
                  color: Color(0xFF1B97F3),
                  tail: true,
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                BubbleNormal(
                  text: 'bubble normal with tail',
                  isSender: true,
                  color: Color(0xFFE8E8EE),
                  tail: true,
                  sent: true,
                ),
                DateChip(
                  date: DateTime(now.year, now.month, now.day - 2),
                ),
                BubbleNormal(
                  text: 'bubble normal without tail',
                  isSender: false,
                  color: Color(0xFF1B97F3),
                  tail: false,
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                BubbleNormal(
                  text: 'bubble normal without tail',
                  color: Color(0xFFE8E8EE),
                  tail: false,
                  sent: true,
                  seen: true,
                  delivered: true,
                ),
                BubbleSpecialOne(
                  text: 'bubble special one with tail',
                  isSender: false,
                  color: Color(0xFF1B97F3),
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                DateChip(
                  date: DateTime(now.year, now.month, now.day - 1),
                ),
                BubbleSpecialOne(
                  text: 'bubble special one with tail',
                  color: Color(0xFFE8E8EE),
                  seen: true,
                ),
                BubbleSpecialOne(
                  text: 'bubble special one without tail',
                  isSender: false,
                  tail: false,
                  color: Color(0xFF1B97F3),
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                BubbleSpecialOne(
                  text: 'bubble special one without tail',
                  tail: false,
                  color: Color(0xFFE8E8EE),
                  sent: true,
                ),
                BubbleSpecialTwo(
                  text: 'bubble special tow with tail',
                  isSender: false,
                  color: Color(0xFF1B97F3),
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                DateChip(
                  date: now,
                ),
                BubbleSpecialTwo(
                  text: 'bubble special tow with tail',
                  isSender: true,
                  color: Color(0xFFE8E8EE),
                  sent: true,
                ),
                BubbleSpecialTwo(
                  text: 'bubble special tow without tail',
                  isSender: false,
                  tail: false,
                  color: Color(0xFF1B97F3),
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                BubbleSpecialTwo(
                  text: 'bubble special tow without tail',
                  tail: false,
                  color: Color(0xFFE8E8EE),
                  delivered: true,
                ),
                BubbleSpecialThree(
                  text: 'bubble special three without tail',
                  color: Color(0xFF1B97F3),
                  tail: false,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16),
                ),
                BubbleSpecialThree(
                  text: 'bubble special three with tail',
                  color: Color(0xFF1B97F3),
                  tail: true,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16),
                ),
                BubbleSpecialThree(
                  text: "bubble special three without tail",
                  color: Color(0xFFE8E8EE),
                  tail: false,
                  isSender: false,
                ),
                BubbleSpecialThree(
                  text: "bubble special three with tail",
                  color: Color(0xFFE8E8EE),
                  tail: true,
                  isSender: false,
                ),
                DateChip(
                  date: now,
                ),
                // New v1.8.0 Features
                BubbleReply(
                  repliedMessage: 'This is the original message being replied to',
                  repliedMessageSender: 'John Doe',
                  text: 'This is my reply to your message!',
                  isSender: false,
                  color: Color(0xFF1B97F3),
                  replyBorderColor: Colors.white,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16),
                  sent: true,
                ),
                BubbleReply(
                  repliedMessage: 'Thanks for the info',
                  repliedMessageSender: 'Me',
                  text: 'You\'re welcome! Happy to help.',
                  isSender: true,
                  color: Color(0xFFE8E8EE),
                  replyBorderColor: Color(0xFF1B97F3),
                  delivered: true,
                ),
                TypingIndicator(
                  showIndicator: true,
                  bubbleColor: Color(0xFFE8E8EE),
                  dotColor: Colors.black54,
                ),
                BubbleLinkPreview(
                  url: 'https://flutter.dev',
                  title: 'Flutter - Build apps for any screen',
                  description: 'Flutter transforms the app development process. Build, test, and deploy beautiful mobile, web, desktop, and embedded apps from a single codebase.',
                  imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
                  text: 'Check out this awesome framework!',
                  isSender: false,
                  color: Color(0xFF1B97F3),
                  textStyle: TextStyle(color: Colors.white, fontSize: 16),
                ),
                BubbleLinkPreview(
                  url: 'https://pub.dev/packages/chat_bubbles',
                  title: 'chat_bubbles | Flutter Package',
                  description: 'Flutter chat bubble widgets, similar to Whatsapp and more shapes. Easy to use and implement chat bubbles.',
                  text: 'Our package on pub.dev!',
                  isSender: true,
                  color: Color(0xFFE8E8EE),
                  showImage: false,
                  sent: true,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BubbleNormal(
                      text: 'Great work on this project! 🎉',
                      isSender: false,
                      color: Color(0xFF1B97F3),
                      textStyle: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    BubbleReaction(
                      reactions: [
                        Reaction(emoji: '👍', count: 3, isUserReacted: true),
                        Reaction(emoji: '❤️', count: 2),
                        Reaction(emoji: '🎉', count: 1),
                      ],
                      onReactionTap: (reaction) {
                        print('Tapped on ${reaction.emoji}');
                      },
                      onAddReactionTap: () {
                        print('Add reaction tapped');
                      },
                      alignRight: false,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BubbleNormal(
                      text: 'Thanks everyone! 😊',
                      isSender: true,
                      color: Color(0xFFE8E8EE),
                      delivered: true,
                    ),
                    BubbleReaction(
                      reactions: [
                        Reaction(emoji: '❤️', count: 5, isUserReacted: false),
                      ],
                      onReactionTap: (reaction) {
                        print('Tapped on ${reaction.emoji}');
                      },
                      alignRight: true,
                    ),
                  ],
                ),
                // v1.9.0 - Message Status Enhancements
                DateChip(date: now),
                BubbleNormal(
                  text: 'Message with timestamp',
                  isSender: true,
                  color: Color(0xFFE8E8EE),
                  tail: true,
                  sent: true,
                  timestamp: '10:42 AM',
                ),
                BubbleNormal(
                  text: 'Message with timestamp',
                  isSender: false,
                  color: Color(0xFF1B97F3),
                  tail: true,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16),
                  timestamp: '10:43 AM',
                ),
                BubbleNormal(
                  text: 'This message was edited after sending',
                  isSender: true,
                  color: Color(0xFFE8E8EE),
                  tail: true,
                  seen: true,
                  isEdited: true,
                  timestamp: '11:05 AM',
                ),
                BubbleNormal(
                  text: 'Forwarded message from another chat',
                  isSender: false,
                  color: Color(0xFF1B97F3),
                  tail: true,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16),
                  isForwarded: true,
                  timestamp: '11:10 AM',
                ),
                BubbleNormal(
                  text: 'Forwarded and edited message',
                  isSender: true,
                  color: Color(0xFFE8E8EE),
                  tail: true,
                  delivered: true,
                  isForwarded: true,
                  isEdited: true,
                  timestamp: '11:15 AM',
                  messageId: 'msg_001',
                ),
                BubbleSpecialOne(
                  text: 'Special bubble with timestamp',
                  isSender: true,
                  color: Color(0xFFE8E8EE),
                  sent: true,
                  timestamp: '11:20 AM',
                ),
                BubbleSpecialTwo(
                  text: 'Forwarded via special bubble',
                  isSender: false,
                  color: Color(0xFF1B97F3),
                  textStyle: TextStyle(color: Colors.white, fontSize: 16),
                  isForwarded: true,
                  timestamp: '11:21 AM',
                ),
                BubbleReply(
                  repliedMessage: 'Meet at 3pm?',
                  repliedMessageSender: 'Alice',
                  text: 'Sure, see you then!',
                  isSender: true,
                  color: Color(0xFFE8E8EE),
                  replyBorderColor: Color(0xFF1B97F3),
                  seen: true,
                  isEdited: true,
                  timestamp: '11:25 AM',
                ),
                BubbleReply(
                  repliedMessage: 'Check out this article',
                  repliedMessageSender: 'Bob',
                  text: 'Forwarded this to the team!',
                  isSender: false,
                  color: Color(0xFF1B97F3),
                  replyBorderColor: Colors.white,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16),
                  isForwarded: true,
                  timestamp: '11:30 AM',
                ),
                // ── v1.9.0: Voice Message Waveform ──────────────────────
                DateChip(date: now),
                BubbleNormalAudio(
                  color: Color(0xFFE8E8EE),
                  duration: duration == null
                      ? 0.0
                      : duration!.inSeconds.toDouble(),
                  position: position == null
                      ? 0.0
                      : position!.inSeconds.toDouble(),
                  isPlaying: isPlaying,
                  isLoading: isLoading,
                  isPause: isPause,
                  onSeekChanged: _changeSeek,
                  onPlayPauseButtonClick: _playAudio,
                  sent: true,
                  timestamp: '11:45 AM',
                  waveformData: _demoWaveform,
                  waveformActiveColor: Color(0xFF1B97F3),
                  waveformInactiveColor: Colors.grey,
                  showPlaybackSpeed: true,
                  playbackSpeed: _wavePlaybackSpeed,
                  onPlaybackSpeedChanged: (speed) {
                    setState(() => _wavePlaybackSpeed = speed);
                  },
                ),
                BubbleNormalAudio(
                  color: Color(0xFF1B97F3),
                  duration: 30.0,
                  position: 12.0,
                  isPlaying: false,
                  isLoading: false,
                  isPause: false,
                  isSender: false,
                  onSeekChanged: (_) {},
                  onPlayPauseButtonClick: () {},
                  textStyle: TextStyle(color: Colors.white70, fontSize: 12),
                  waveformData: _demoWaveform,
                  waveformActiveColor: Colors.white,
                  waveformInactiveColor: Colors.white30,
                  showPlaybackSpeed: true,
                  playbackSpeed: 1.5,
                  onPlaybackSpeedChanged: (_) {},
                ),

                // ── v1.9.0: Swipe Actions ────────────────────────────────
                DateChip(date: now),
                SwipeableBubble(
                  onSwipeRight: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reply triggered!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: BubbleNormal(
                    text: 'Swipe me right to reply ➜',
                    isSender: false,
                    color: Color(0xFF1B97F3),
                    tail: true,
                    textStyle: TextStyle(color: Colors.white, fontSize: 16),
                    timestamp: '11:50 AM',
                  ),
                ),
                SwipeableBubble(
                  onSwipeRight: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reply triggered!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  onSwipeLeft: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Delete triggered!'),
                        duration: Duration(seconds: 1),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  child: BubbleNormal(
                    text: 'Swipe right → reply  |  Swipe left → delete',
                    isSender: true,
                    color: Color(0xFFE8E8EE),
                    tail: true,
                    sent: true,
                    timestamp: '11:51 AM',
                  ),
                ),
                SwipeableBubble(
                  swipeThreshold: 80.0,
                  rightActionColor: Colors.green,
                  rightActionIcon: Icon(Icons.star, color: Colors.white),
                  onSwipeRight: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Starred!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: BubbleSpecialOne(
                    text: 'Custom swipe icon and color',
                    isSender: false,
                    color: Color(0xFF1B97F3),
                    textStyle: TextStyle(color: Colors.white, fontSize: 16),
                    timestamp: '11:52 AM',
                  ),
                ),

                // ── v1.9.0: Message Groups / Clustering ──────────────────
                DateChip(date: now),
                BubbleGroupBuilder(
                  itemCount: _groupMessages.length,
                  senderIdOf: (i) => _groupSenders[i],
                  itemBuilder: (context, i, info) {
                    final bool isSelf = _groupSenders[i] == 'bob';
                    return BubbleNormal(
                      text: _groupMessages[i],
                      isSender: isSelf,
                      color: isSelf
                          ? Color(0xFFE8E8EE)
                          : Color(0xFF1B97F3),
                      textStyle: isSelf
                          ? TextStyle(fontSize: 16, color: Colors.black87)
                          : TextStyle(fontSize: 16, color: Colors.white),
                      tail: info.showTail,
                      seen: isSelf && info.isGroupEnd,
                    );
                  },
                ),

                TypingIndicatorWave(
                  showIndicator: true,
                  bubbleColor: Color(0xFFE8E8EE),
                  dotColor: Colors.black54,
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
          MessageBar(
            onSend: (_) => print(_),
            actions: [
              InkWell(
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 24,
                ),
                onTap: () {},
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.green,
                    size: 24,
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _image() {
    return Container(
      constraints: BoxConstraints(
        minHeight: 20.0,
        minWidth: 20.0,
      ),
      child: CachedNetworkImage(
        imageUrl: 'https://i.ibb.co/JCyT1kT/Asset-1.png',
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  void _changeSeek(double value) {
    setState(() {
      audioPlayer.seek(Duration(seconds: value.toInt()));
    });
  }

  void _playAudio() async {
    final url = 'https://download.samplelib.com/mp3/sample-15s.mp3';
    if (isPause) {
      await audioPlayer.resume();
      setState(() {
        isPlaying = true;
        isPause = false;
      });
    } else if (isPlaying) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
        isPause = true;
      });
    } else {
      log('play: loading');
      setState(() {
        isLoading = true;
      });
      await audioPlayer.play(UrlSource(url));
      log('play: loaded');
      setState(() {
        audioPlayer.getDuration().then(
              (value) => setState(() {
                log('init duration: $value');
                duration = value;
                isLoading = false;
              }),
            );
        audioPlayer.getCurrentPosition().then(
              (value) => setState(() {
                log('init position: $value');
                position = value;
              }),
            );
        isPlaying = true;
      });
    }
  }
}
