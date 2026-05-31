import 'package:flutter/material.dart';

/// Typing indicator widget with animated dots
///
/// Displays an animated typing indicator similar to popular messaging apps
/// like WhatsApp, iMessage, etc.
///
/// The animation can be customized using [animationDuration]
///
/// [bubbleColor] customizes the background color of the bubble
///
/// [dotColor] customizes the color of the animated dots
///
/// [showIndicator] controls the visibility of the typing indicator
///
/// [numberOfDots] controls how many dots to display (default: 3)
class TypingIndicator extends StatefulWidget {
  /// background color of the typing bubble
  final Color bubbleColor;
  
  /// color of the animated dots
  final Color dotColor;
  
  /// whether to show the typing indicator
  final bool showIndicator;
  
  /// duration of the animation cycle
  final Duration animationDuration;
  
  /// number of dots to display
  final int numberOfDots;
  
  /// size of each dot
  final double dotSize;
  
  /// spacing between dots
  final double dotSpacing;
  
  /// padding inside the bubble
  final EdgeInsets padding;
  
  /// border radius of the bubble
  final double borderRadius;

  /// Creates a [TypingIndicator] widget
  const TypingIndicator({
    super.key,
    this.bubbleColor = const Color(0xFFE8E8EE),
    this.dotColor = Colors.black54,
    this.showIndicator = true,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.numberOfDots = 3,
    this.dotSize = 8.0,
    this.dotSpacing = 4.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderRadius = 20.0,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    if (widget.showIndicator) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(TypingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showIndicator != oldWidget.showIndicator) {
      if (widget.showIndicator) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showIndicator) {
      return SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.bubbleColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            widget.numberOfDots,
            (index) => _AnimatedDot(
              animation: _animationController,
              index: index,
              totalDots: widget.numberOfDots,
              color: widget.dotColor,
              size: widget.dotSize,
              spacing: widget.dotSpacing,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedDot extends StatelessWidget {
  final Animation<double> animation;
  final int index;
  final int totalDots;
  final Color color;
  final double size;
  final double spacing;

  const _AnimatedDot({
    required this.animation,
    required this.index,
    required this.totalDots,
    required this.color,
    required this.size,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final delay = index / totalDots;
        final value = (animation.value - delay) % 1.0;
        final scale = _calculateScale(value);
        final opacity = _calculateOpacity(value);

        return Padding(
          padding: EdgeInsets.only(
            right: index < totalDots - 1 ? spacing : 0,
          ),
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _calculateScale(double value) {
    if (value < 0.5) {
      return 1.0 + (value * 0.6);
    } else {
      return 1.3 - ((value - 0.5) * 0.6);
    }
  }

  double _calculateOpacity(double value) {
    if (value < 0.5) {
      return 0.4 + (value * 1.2);
    } else {
      return 1.0 - ((value - 0.5) * 1.2);
    }
  }
}

/// Alternative typing indicator with wave animation style
class TypingIndicatorWave extends StatefulWidget {
  /// background color of the typing bubble
  final Color bubbleColor;
  
  /// color of the animated dots
  final Color dotColor;
  
  /// whether to show the typing indicator
  final bool showIndicator;
  
  /// duration of the animation cycle
  final Duration animationDuration;
  
  /// size of each dot
  final double dotSize;
  
  /// padding inside the bubble
  final EdgeInsets padding;
  
  /// border radius of the bubble
  final double borderRadius;

  /// Creates a [TypingIndicatorWave] widget
  const TypingIndicatorWave({
    super.key,
    this.bubbleColor = const Color(0xFFE8E8EE),
    this.dotColor = Colors.black54,
    this.showIndicator = true,
    this.animationDuration = const Duration(milliseconds: 1200),
    this.dotSize = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderRadius = 20.0,
  });

  @override
  State<TypingIndicatorWave> createState() => _TypingIndicatorWaveState();
}

class _TypingIndicatorWaveState extends State<TypingIndicatorWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    if (widget.showIndicator) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(TypingIndicatorWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showIndicator != oldWidget.showIndicator) {
      if (widget.showIndicator) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showIndicator) {
      return SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.bubbleColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (index) => _WaveDot(
              animation: _animationController,
              index: index,
              color: widget.dotColor,
              size: widget.dotSize,
            ),
          ),
        ),
      ),
    );
  }
}

class _WaveDot extends StatelessWidget {
  final Animation<double> animation;
  final int index;
  final Color color;
  final double size;

  const _WaveDot({
    required this.animation,
    required this.index,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final delay = index * 0.2;
        final value = (animation.value + delay) % 1.0;
        final offsetY = _calculateOffset(value);

        return Padding(
          padding: EdgeInsets.only(right: index < 2 ? 4 : 0),
          child: Transform.translate(
            offset: Offset(0, offsetY),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  double _calculateOffset(double value) {
    return -6 * (0.5 - (value - 0.5).abs()) * 2;
  }
}
