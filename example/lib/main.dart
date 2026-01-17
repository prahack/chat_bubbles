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

class _MyHomePageState extends State<MyHomePage> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration? duration = Duration();
  Duration? position = Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;

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
