# chat_bubbles plugin

![Pub Version](https://img.shields.io/pub/v/chat_bubbles?color=blue)
![likes](https://badges.bar/chat_bubbles/likes)
![popularity](https://badges.bar/chat_bubbles/popularity)
![pub points](https://badges.bar/sentry/pub%20points)
![GitHub](https://img.shields.io/github/license/prahack/chat_bubbles)
![GitHub forks](https://img.shields.io/github/forks/prahack/chat_bubbles)
![GitHub Repo stars](https://img.shields.io/github/stars/prahack/chat_bubbles)
![GitHub last commit](https://img.shields.io/github/last-commit/prahack/chat_bubbles)

Flutter chat bubble widgets, similar to the Whatsapp and more shapes. Audio chat bubble widgets are also included. Easy to use and implement chat bubbles.

## Getting Started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  chat_bubbles: ^1.1.0
```

## Usage

Then you just have to import the package with

```dart
import 'package:chat_bubbles/chat_bubbles.dart'
```

Now you can use this plugin to implement various types of Chat Bubbles, Audio Chat Bubbles and Date chips.

## Example

### Single bubble example

<img src="https://github.com/prahack/chat_bubbles/blob/master/images/screenshots/single_bubble.png?raw=true"  width="220" height="60" />


```dart
  BubbleSpecialOne(
    text: 'Hi, How are you? ',
    isSender: false,
    color: Colors.purple.shade100,
    textStyle: TextStyle(
      fontSize: 20,
      color: Colors.purple,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
    ),
  ),
```

### Audio chat bubble example

<img src="https://github.com/prahack/chat_bubbles/blob/master/images/screenshots/audio_bubble.png?raw=true"  width="237" height="65" />

```dart
  Duration duration = new Duration();
  Duration position = new Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;

  BubbleNormalAudio(
    color: Color(0xFFE8E8EE),
    duration: duration.inSeconds.toDouble(),
    position: position.inSeconds.toDouble(),
    isPlaying: isPlaying,
    isLoading: isLoading,
    isPause: isPause,
    onSeekChanged: _changeSeek,
    onPlayPauseButtonClick: _playAudio,
    sent: true,
  ),
```

### Date Chip example

<img src="https://github.com/prahack/chat_bubbles/blob/master/images/screenshots/datechip.png?raw=true"  width="237" height="58" />

```dart
  DateChip(
    date: new DateTime(2021, 5, 7),
    color: Color(0x558AD3D5),
  ),
```

### Main example (Chat View)

<img src="https://github.com/prahack/chat_bubbles/blob/master/images/screenshots/screenshot_2.png?raw=true"  width="250" height="450" />

Checkout the plugin example to figure out more.

```dart
  Duration duration = new Duration();
  Duration position = new Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;

  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BubbleNormalAudio(
                color: Color(0xFFE8E8EE),
                duration: duration.inSeconds.toDouble(),
                position: position.inSeconds.toDouble(),
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
                date: new DateTime(now.year, now.month, now.day - 2),
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
                date: new DateTime(now.year, now.month, now.day - 1),
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
            ],
          ),
        ),
      ),
    );
  }
```

## Issues

Please feel free to [let me know any issue](https://github.com/prahack/chat_bubbles/issues) regarding to this plugin.
