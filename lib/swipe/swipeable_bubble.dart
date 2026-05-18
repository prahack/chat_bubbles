import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A wrapper widget that adds swipe gesture support to any chat bubble.
///
/// Wrap any bubble widget with [SwipeableBubble] to enable swipe-to-reply
/// (swipe right) and swipe-to-delete (swipe left) gestures.
///
/// [child] is the bubble widget to wrap.
///
/// [onSwipeRight] is called when the user swipes right past [swipeThreshold].
/// Typically used for reply actions.
///
/// [onSwipeLeft] is called when the user swipes left past [swipeThreshold].
/// Typically used for delete actions.
///
/// [swipeThreshold] is the horizontal distance (in logical pixels) the user
/// must drag before the action is triggered. Defaults to 64.0.
///
/// [enableHaptics] enables haptic feedback when the threshold is crossed.
/// Defaults to true.
///
/// [rightActionColor] is the background color revealed on swipe-right.
/// Defaults to [Colors.blue].
///
/// [leftActionColor] is the background color revealed on swipe-left.
/// Defaults to [Colors.red].
///
/// [rightActionIcon] is the icon revealed on swipe-right. Defaults to
/// [Icons.reply].
///
/// [leftActionIcon] is the icon revealed on swipe-left. Defaults to
/// [Icons.delete].
class SwipeableBubble extends StatefulWidget {
  /// The bubble widget to wrap
  final Widget child;

  /// Called when the user swipes right past [swipeThreshold]
  final VoidCallback? onSwipeRight;

  /// Called when the user swipes left past [swipeThreshold]
  final VoidCallback? onSwipeLeft;

  /// Minimum drag distance to trigger the action. Defaults to 64.0
  final double swipeThreshold;

  /// Whether to emit haptic feedback when the threshold is crossed
  final bool enableHaptics;

  /// Background color revealed on swipe-right
  final Color rightActionColor;

  /// Background color revealed on swipe-left
  final Color leftActionColor;

  /// Icon revealed on swipe-right
  final Icon rightActionIcon;

  /// Icon revealed on swipe-left
  final Icon leftActionIcon;

  /// Creates a [SwipeableBubble] widget
  const SwipeableBubble({
    super.key,
    required this.child,
    this.onSwipeRight,
    this.onSwipeLeft,
    this.swipeThreshold = 64.0,
    this.enableHaptics = true,
    this.rightActionColor = Colors.blue,
    this.leftActionColor = Colors.red,
    this.rightActionIcon = const Icon(Icons.reply, color: Colors.white),
    this.leftActionIcon = const Icon(Icons.delete, color: Colors.white),
  });

  @override
  State<SwipeableBubble> createState() => _SwipeableBubbleState();
}

class _SwipeableBubbleState extends State<SwipeableBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double _dragX = 0.0;
  bool _hapticFired = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!mounted) return;

    final double newDragX = (_dragX + details.delta.dx).clamp(
      widget.onSwipeLeft != null ? -widget.swipeThreshold * 1.5 : 0.0,
      widget.onSwipeRight != null ? widget.swipeThreshold * 1.5 : 0.0,
    );

    setState(() {
      _dragX = newDragX;
    });

    final bool thresholdCrossed =
        _dragX.abs() >= widget.swipeThreshold;

    if (thresholdCrossed && !_hapticFired && widget.enableHaptics) {
      HapticFeedback.mediumImpact();
      _hapticFired = true;
    }

    if (!thresholdCrossed) {
      _hapticFired = false;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    final bool thresholdMet = _dragX.abs() >= widget.swipeThreshold;

    if (thresholdMet) {
      if (_dragX > 0) {
        widget.onSwipeRight?.call();
      } else {
        widget.onSwipeLeft?.call();
      }
    }

    _springBack();
  }

  void _springBack() {
    final double startX = _dragX;
    _animation = Tween<double>(begin: startX, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    )..addListener(() {
        if (mounted) {
          setState(() {
            _dragX = _animation.value;
          });
        }
      });

    _controller.forward(from: 0.0);
    _hapticFired = false;
  }

  @override
  Widget build(BuildContext context) {
    final bool showingRight = _dragX > 0;
    final bool showingLeft = _dragX < 0;
    final double revealRatio =
        (_dragX.abs() / widget.swipeThreshold).clamp(0.0, 1.0);

    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Right action background (revealed on swipe-right)
          if (showingRight && widget.onSwipeRight != null)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Opacity(
                    opacity: revealRatio,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.rightActionColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: widget.rightActionIcon),
                    ),
                  ),
                ),
              ),
            ),
          // Left action background (revealed on swipe-left)
          if (showingLeft && widget.onSwipeLeft != null)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Opacity(
                    opacity: revealRatio,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.leftActionColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: widget.leftActionIcon),
                    ),
                  ),
                ),
              ),
            ),
          // The bubble, shifted horizontally
          Transform.translate(
            offset: Offset(_dragX, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
