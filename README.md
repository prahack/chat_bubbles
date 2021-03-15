# chat_bubbles plugin

Chat bubble widgets, similar to the Whatsapp and more shapes. Easy to use and implement chat bubbles.

## Getting Started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  chat_bubbles: ^0.8.0
```

## Usage

Then you just have to import the package with

```dart
import 'package:chat_bubbles/chat_bubbles.dart'
```

Now you can use this plugin to implement various types of Chat Bubbles.

## Example

<img src="https://github.com/prahack/chat_bubbles/blob/master/images/screenshots/screenshot_1.png?raw=true"  width="250" height="450" />



```dart
   BubbleNormal(
    text: 'bubble normal with tail',
    isSender: false,
    color: Color(0xAF6AD0F5),
    tail: true,
  ),
  BubbleNormal(
    text: 'bubble normal with tail',
    isSender: true,
    color: Color(0xFFE2FFC7),
    tail: true,
    sent: true,
  ),
  BubbleNormal(
    text: 'bubble normal without tail',
    isSender: false,
    color: Color(0xAF6AD0F5),
    tail: false,
  ),
  BubbleNormal(
    text: 'bubble normal without tail',
    color: Color(0xFFE2FFC7),
    tail: false,
    seen: true,
  ),
  BubbleSpecialOne(
    text: 'bubble special one with tail',
    isSender: false,
    color: Color(0xAF6AD0F5),
  ),
  BubbleSpecialOne(
    text: 'bubble special one with tail',
    color: Color(0xFFE2FFC7),
    seen: true,
  ),
  BubbleSpecialOne(
    text: 'bubble special one without tail',
    isSender: false,
    tail: false,
    color: Color(0xAF6AD0F5),
  ),
  BubbleSpecialOne(
    text: 'bubble special one without tail',
    tail: false,
    color: Color(0xFFE2FFC7),
    sent: true,
  ),
  BubbleSpecialTwo(
    text: 'bubble special tow with tail',
    isSender: false,
    color: Color(0xAF6AD0F5),
  ),
  BubbleSpecialTwo(
    text: 'bubble special tow with tail',
    isSender: true,
    color: Color(0xFFE2FFC7),
    sent: true,
  ),
  BubbleSpecialTwo(
    text: 'bubble special tow without tail',
    isSender: false,
    tail: false,
    color: Color(0xAF6AD0F5),
  ),
  BubbleSpecialTwo(
    text: 'bubble special tow without tail',
    tail: false,
    color: Color(0xFFE2FFC7),
    delivered: true,
  )
```

## Issues

Please feel free to [let me know any issue](https://github.com/prahack/chat_bubbles/issues) regarding to this plugin.
