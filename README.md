# chat_bubbles plugin

Flutter widgets for messaging apps as chat bubbles.

## Getting Started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  chat_bubbles: ^0.7.0
```

## Usage

Then you just have to import the package with

```dart
import 'package:chat_bubbles/chat_bubbles.dart'
```

Now you can use this plugin to implement various types of Chat Bubbles.

## Example

![](https://github.com/prahack/chat_bubbles/blob/master/images/screenshots/screenshot_1.png?raw=true)



```dart
BubbleNormal(
    text: 'bubble normal with tail',
    isSender: false,
    color: Color(0xAF52FF8C),
    tail: true,
),
BubbleNormal(
    text: 'bubble normal with tail',
    isSender: true,
    color: Color(0xAF6AD0F5),
    tail: true,
),
BubbleNormal(
    text: 'bubble normal without tail',
    isSender: false,
    color: Color(0xAF52FF8C),
    tail: false,
),
BubbleNormal(
    text: 'bubble normal without tail',
    color: Color(0xAF6AD0F5),
    tail: false,
),
BubbleSpecialOne(
    text: 'bubble special one with tail',
    isSender: false,
    color: Color(0xAF52FF8C),
),
BubbleSpecialOne(
    text: 'bubble special one without tail',
    color: Color(0xAF6AD0F5),
),
BubbleSpecialOne(
    text: 'bubble special one with tail',
    isSender: false,
    tail: false,
    color: Color(0xAF52FF8C),
),
BubbleSpecialOne(
    text: 'bubble special one without tail',
    tail: false,
    color: Color(0xAF6AD0F5),
),
BubbleSpecialTwo(
    text: 'bubble special tow with tail',
    isSender: false,
    color: Color(0xAF52FF8C),
),
BubbleSpecialTwo(
    text: 'bubble special tow with tail',
    isSender: true,
    color: Color(0xAF6AD0F5),
),
BubbleSpecialTwo(
    text: 'bubble special tow without tail',
    isSender: false,
    tail: false,
    color: Color(0xAF52FF8C),
),
BubbleSpecialTwo(
    text: 'bubble special tow without tail',
    tail: false,
    color: Color(0xAF6AD0F5),
)
```

## Issues

Please feel free to [let me know any issue](https://github.com/prahack/chat_bubbles/issues) regarding to this plugin.
