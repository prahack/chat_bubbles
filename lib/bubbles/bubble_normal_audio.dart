import 'package:flutter/material.dart';
import '../utils/bubble_forwarded_header.dart';
import '../utils/bubble_status_row.dart';

///chat bubble default [BorderRadius]
const double defaultBubbleRadiusAudio = 16;

/// Internal CustomPainter that draws a waveform from normalized bar heights.
///
/// Bars to the left of the current playback position are drawn with
/// [activeColor]; bars to the right use [inactiveColor].
class _WaveformPainter extends CustomPainter {
  final List<double> data;
  final double progress; // 0.0 – 1.0
  final Color activeColor;
  final Color inactiveColor;

  const _WaveformPainter({
    required this.data,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const double minBarHeightRatio = 0.15;
    final double barWidth = (size.width / data.length) * 0.6;
    final double gap = (size.width / data.length) * 0.4;
    final int activeCount = (data.length * progress).round();

    for (int i = 0; i < data.length; i++) {
      final double normalizedHeight =
          minBarHeightRatio + (1.0 - minBarHeightRatio) * data[i].clamp(0.0, 1.0);
      final double barHeight = size.height * normalizedHeight;
      final double x = i * (barWidth + gap);
      final double top = (size.height - barHeight) / 2;

      final Paint paint = Paint()
        ..color = i < activeCount ? activeColor : inactiveColor
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, top, barWidth, barHeight),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter old) =>
      old.progress != progress ||
      old.data != data ||
      old.activeColor != activeColor ||
      old.inactiveColor != inactiveColor;
}

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
///chat bubble [BorderRadius] can be customized using [bubbleRadius]
///
///chat bubble color can be customized using [color]
///
///chat bubble tail can be customized using [tail]
///
///message sender can be changed using [isSender]
///
///[sent],[delivered] and [seen] can be used to display the message state
///
///chat bubble [TextStyle] can be customized using [textStyle]
///
/// [waveformData] provides normalized (0.0–1.0) bar heights for waveform
/// visualization. When null the default [Slider] is used.
///
/// [waveformActiveColor] is the color of the played portion of the waveform
///
/// [waveformInactiveColor] is the color of the unplayed portion
///
/// [showPlaybackSpeed] shows a speed toggle button (1x / 1.5x / 2x)
///
/// [playbackSpeed] is the current playback speed displayed on the button
///
/// [onPlaybackSpeedChanged] is called with the new speed when the user taps
/// the speed button
///
/// [timestamp] is an optional string shown at the bottom-right of the bubble
///
/// [isEdited] shows an "Edited" label next to the status area when true
///
/// [isForwarded] shows a "Forwarded" banner at the top of the bubble when true
///
/// [messageId] is an optional identifier for tracking purposes

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
  /// optional timestamp string shown at the bottom-right (e.g. "12:34 PM")
  final String? timestamp;
  /// shows an "Edited" label next to the status area when true
  final bool isEdited;
  /// shows a "Forwarded" banner at the top of the bubble when true
  final bool isForwarded;
  /// optional identifier for tracking the message
  final String? messageId;

  /// Normalized (0.0–1.0) waveform bar heights. When provided, a waveform
  /// visualization replaces the default Slider.
  final List<double>? waveformData;

  /// Color of the played portion of the waveform
  final Color waveformActiveColor;

  /// Color of the unplayed portion of the waveform
  final Color waveformInactiveColor;

  /// Shows a playback speed toggle button (1x / 1.5x / 2x)
  final bool showPlaybackSpeed;

  /// Current playback speed displayed on the speed button
  final double playbackSpeed;

  /// Called with the next speed value when the user taps the speed button.
  /// Cycles: 1.0 → 1.5 → 2.0 → 1.0
  final ValueChanged<double>? onPlaybackSpeedChanged;

  /// Constructor
  const BubbleNormalAudio({
    super.key,
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
    this.timestamp,
    this.isEdited = false,
    this.isForwarded = false,
    this.messageId,
    this.waveformData,
    this.waveformActiveColor = Colors.blue,
    this.waveformInactiveColor = Colors.grey,
    this.showPlaybackSpeed = false,
    this.playbackSpeed = 1.0,
    this.onPlaybackSpeedChanged,
  });

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

    final bool showStatusArea = stateTick || timestamp != null || isEdited;
    final Color forwardedColor =
        (textStyle.color ?? Colors.black87).withValues(alpha: 0.6);

    final double dur = duration ?? 0.0;
    final double pos = position ?? 0.0;
    final double waveProgress = dur > 0 ? (pos / dur).clamp(0.0, 1.0) : 0.0;

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
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isForwarded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                      child: BubbleForwardedHeader(color: forwardedColor),
                    ),
                  // Player row: play/pause button + waveform or slider
                  Row(
                    children: [
                      // Playback speed button (shown before play button when enabled)
                      if (showPlaybackSpeed)
                        GestureDetector(
                          onTap: onPlaybackSpeedChanged != null
                              ? () {
                                  final double next =
                                      playbackSpeed >= 2.0
                                          ? 1.0
                                          : playbackSpeed >= 1.5
                                              ? 2.0
                                              : 1.5;
                                  onPlaybackSpeedChanged!(next);
                                }
                              : null,
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: textStyle.color ?? Colors.black54,
                                  width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _speedLabel(playbackSpeed),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: textStyle.color ?? Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      RawMaterialButton(
                        onPressed: onPlayPauseButtonClick,
                        elevation: 1.0,
                        fillColor: Colors.white,
                        padding: EdgeInsets.all(0.0),
                        shape: CircleBorder(),
                        child: !isPlaying
                            ? Icon(Icons.play_arrow, size: 30.0)
                            : isLoading
                                ? CircularProgressIndicator()
                                : isPause
                                    ? Icon(Icons.play_arrow, size: 30.0)
                                    : Icon(Icons.pause, size: 30.0),
                      ),
                      Expanded(
                        child: waveformData != null && waveformData!.isNotEmpty
                            ? _buildWaveform(waveformData!, waveProgress, dur)
                            : Slider(
                                min: 0.0,
                                max: dur,
                                value: pos,
                                onChanged: onSeekChanged,
                              ),
                      ),
                    ],
                  ),
                  // Bottom row: audio timer + status
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          audioTimer(dur, pos),
                          style: textStyle,
                        ),
                        if (showStatusArea)
                          BubbleStatusRow(
                            stateIcon: stateTick ? stateIcon : null,
                            isEdited: isEdited,
                            timestamp: timestamp,
                            textColor: textStyle.color ?? Colors.black87,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWaveform(
      List<double> data, double progress, double totalDuration) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Scrubbing: convert drag position to seek value
      },
      onTapDown: (TapDownDetails details) {
        // Will be handled by LayoutBuilder below
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTapDown: (TapDownDetails details) {
              if (totalDuration > 0) {
                final double ratio =
                    (details.localPosition.dx / constraints.maxWidth)
                        .clamp(0.0, 1.0);
                onSeekChanged(ratio * totalDuration);
              }
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              if (totalDuration > 0) {
                final double ratio =
                    (details.localPosition.dx / constraints.maxWidth)
                        .clamp(0.0, 1.0);
                onSeekChanged(ratio * totalDuration);
              }
            },
            child: SizedBox(
              height: 36,
              child: CustomPaint(
                painter: _WaveformPainter(
                  data: data,
                  progress: progress,
                  activeColor: waveformActiveColor,
                  inactiveColor: waveformInactiveColor,
                ),
                size: Size(constraints.maxWidth, 36),
              ),
            ),
          );
        },
      ),
    );
  }

  String _speedLabel(double speed) {
    if (speed == 1.5) return '1.5x';
    if (speed == 2.0) return '2x';
    return '1x';
  }

  ///[audioTimer] to get the audio duration and position
  String audioTimer(double duration, double position) {
    return '${(duration ~/ 60).toInt()}:${(duration % 60).toInt().toString().padLeft(2, '0')}/${position ~/ 60}:${(position % 60).toInt().toString().padLeft(2, '0')}';
  }
}
