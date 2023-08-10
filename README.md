# chat_bubbles plugin

![Pub Version](https://img.shields.io/pub/v/chat_bubbles?color=blue)
![GitHub](https://img.shields.io/github/license/prahack/chat_bubbles)
![GitHub forks](https://img.shields.io/github/forks/prahack/chat_bubbles)
![GitHub Repo stars](https://img.shields.io/github/stars/prahack/chat_bubbles)
![GitHub last commit](https://img.shields.io/github/last-commit/prahack/chat_bubbles)

Flutter chat bubble widgets, similar to the Whatsapp and more shapes. Audio and Image chat bubble widgets are also included. Easy to use and implement chat bubbles.

## Getting Started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  chat_bubbles: ^1.4.1
```

## Usage

Then you just have to import the package with

```dart
import 'package:chat_bubbles/chat_bubbles.dart'
```

Now you can use this plugin to implement various types of Chat Bubbles, Audio Chat Bubbles and Date chips.

## Examples

### iMessage's bubble example

<img src="https://github.com/prahack/chat_bubbles/blob/master/images/screenshots/imsg.png?raw=true"  width="250" height="190" />

```dart
BubbleSpecialThree(
  text: 'Added iMassage shape bubbles',
  color: Color(0xFF1B97F3),
  tail: false,
  textStyle: TextStyle(
      color: Colors.white,
      fontSize: 16
  ),
),
BubbleSpecialThree(
  text: 'Please try and give some feedback on it!',
  color: Color(0xFF1B97F3),
  tail: true,
  textStyle: TextStyle(
    color: Colors.white,
    fontSize: 16
  ),
),
BubbleSpecialThree(
  text: 'Sure',
  color: Color(0xFFE8E8EE),
  tail: false,
  isSender: false,
),
BubbleSpecialThree(
  text: "I tried. It's awesome!!!",
  color: Color(0xFFE8E8EE),
  tail: false,
  isSender: false,
),
BubbleSpecialThree(
  text: "Thanks",
  color: Color(0xFFE8E8EE),
  tail: true,
  isSender: false,
)
```

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

### Image chat bubble example

<img src="https://github.com/prahack/chat_bubbles/blob/master/images/screenshots/image_bubble.jpg?raw=true"  width="206" height="188" />

```dart
  BubbleNormalImage(
    id: 'id001',
    image: _image(),
    color: Colors.purpleAccent,
    tail: true,
    delivered: true,
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

### Massage bar example

<img src="https://github.com/prahack/chat_bubbles/blob/master/images/screenshots/messagebar.jpeg?raw=true"  width="270" height="45" />

```dart
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
```

### Main example (Chat View)
<img src="https://github.com/prahack/chat_bubbles/blob/master/images/screenshots/2022_12_29_main1.jpg?raw=true"  width="235" height="460" /> <img src="https://github.com/prahack/chat_bubbles/blob/master/images/screenshots/2022_12_29_main2.jpg?raw=true"  width="235" height="460" />

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
```

## Issues

Please feel free to [let me know any issue](https://github.com/prahack/chat_bubbles/issues) regarding to this plugin.
