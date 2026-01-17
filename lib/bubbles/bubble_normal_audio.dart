import 'package:flutter/material.dart';

///chat bubble default [BorderRadius]
const double defaultBubbleRadiusAudio = 16;

///basic chat bubble type audio message widget
///
/// [onSeekChanged] double pass function to take actions on seek changes
///
/// [onPlayPauseButtonClick] void function to handle play pause button click
///
/// [isPlaying],[isPause] parameters to handle playing state
///
///[duration] is the duration of the audio message in seconds
///
///[position] is the current position of the audio message playing in seconds
///
///[isLoading] is the loading state of the audio
///
///ex:- fetching from internet or loading from local storage
///
///chat bubble [BorderRadius] can be customized using [bubbleRadius]
///
///chat bubble color can be customized using [color]
///
///chat bubble tail can be customized  using [tail]
///
///message sender can be changed using [isSender]
///
///[sent],[delivered] and [seen] can be used to display the message state
///
///chat bubble [TextStyle] can be customized using [textStyle]

class BubbleNormalAudio extends StatelessWidget {
  /// [onSeekChanged] double pass function to take actions on seek changes
  final void Function(double value) onSeekChanged;
  /// [onPlayPauseButtonClick] void function to handle play pause button click
  final void Function() onPlayPauseButtonClick;
  /// [isPlaying],[isPause] parameters to handle playing state
  final bool isPlaying;
  /// [isPlaying],[isPause] parameters to handle playing state
  final bool isPause;
  ///[duration] is the duration of the audio message in seconds
  final double? duration;
  ///[position] is the current position of the audio message playing in seconds
  final double? position;
  /// Whether the audio is currently loading
  final bool isLoading;
  ///chat bubble [BorderRadius] can be customized using [bubbleRadius]
  final double bubbleRadius;
  /// Determines if the message is from the sender ([true]) or receiver ([false])
  final bool isSender;
  /// The background color of the chat bubble
  final Color color;
  /// Whether to show the tail of the chat bubble
  final bool tail;
  /// Whether the message has been sent (shows one tick)
  final bool sent;
  /// Whether the message has been delivered (shows two ticks)
  final bool delivered;
  /// Whether the message has been seen (shows two blue ticks)
  final bool seen;
  /// Custom text style for the duration and position text
  final TextStyle textStyle;
  /// Constraints for the chat bubble
  final BoxConstraints? constraints;

  /// Constructor
  const BubbleNormalAudio({
    Key? key,
    required this.onSeekChanged,
    required this.onPlayPauseButtonClick,
    this.isPlaying = false,
    this.constraints,
    this.isPause = false,
    this.duration,
    this.position,
    this.isLoading = true,
    this.bubbleRadius = defaultBubbleRadiusAudio,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 12,
    ),
  }) : super(key: key);

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    return Row(
      children: <Widget>[
        isSender
            ? Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : Container(),
        Container(
          color: Colors.transparent,
          constraints: constraints ??
              BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .8,
                  maxHeight: 70),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(bubbleRadius),
                  topRight: Radius.circular(bubbleRadius),
                  bottomLeft: Radius.circular(tail
                      ? isSender
                          ? bubbleRadius
                          : 0
                      : defaultBubbleRadiusAudio),
                  bottomRight: Radius.circular(tail
                      ? isSender
                          ? 0
                          : bubbleRadius
                      : defaultBubbleRadiusAudio),
                ),
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      RawMaterialButton(
                        onPressed: onPlayPauseButtonClick,
                        elevation: 1.0,
                        fillColor: Colors.white,
                        padding: EdgeInsets.all(0.0),
                        shape: CircleBorder(),
                        child: !isPlaying
                            ? Icon(
                                Icons.play_arrow,
                                size: 30.0,
                              )
                            : isLoading
                                ? CircularProgressIndicator()
                                : isPause
                                    ? Icon(
                                        Icons.play_arrow,
                                        size: 30.0,
                                      )
                                    : Icon(
                                        Icons.pause,
                                        size: 30.0,
                                      ),
                      ),
                      Expanded(
                        child: Slider(
                          min: 0.0,
                          max: duration ?? 0.0,
                          value: position ?? 0.0,
                          onChanged: onSeekChanged,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 8,
                    right: 25,
                    child: Text(
                      audioTimer(duration ?? 0.0, position ?? 0.0),
                      style: textStyle,
                    ),
                  ),
                  stateIcon != null && stateTick
                      ? Positioned(
                          bottom: 4,
                          right: 6,
                          child: stateIcon,
                        )
                      : SizedBox(
                          width: 1,
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///[audioTimer] to get the audio duration and position
  String audioTimer(double duration, double position) {
    return '${(duration ~/ 60).toInt()}:${(duration % 60).toInt().toString().padLeft(2, '0')}/${position ~/ 60}:${(position % 60).toInt().toString().padLeft(2, '0')}';
  }
}
