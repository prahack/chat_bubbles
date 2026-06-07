import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Internal widget that paints a chat message with its timestamp,
/// "Edited" label and status icon **inline on the last text line** when
/// they fit, falling back to a new right-aligned row below when they
/// don't.
///
/// This is the WhatsApp / iMessage / Signal layout pattern. It is used
/// internally by every text bubble in the package; consumers don't
/// instantiate it directly.
class TimestampedChatMessage extends LeafRenderObjectWidget {
  /// The message body.
  final String text;

  /// Text style applied to [text].
  final TextStyle textStyle;

  /// Optional timestamp string (e.g. "12:34 PM"). When null, no timestamp
  /// is painted.
  final String? timestamp;

  /// Whether to prepend an italic "Edited" label to the meta block.
  final bool isEdited;

  /// Optional status icon (sent / delivered / seen). When null, no icon
  /// is painted.
  final IconData? statusIcon;

  /// Tint for [statusIcon]. Defaults to the meta text color.
  final Color? statusIconColor;

  /// Pixel size of the status icon. Defaults to ~1.4× the meta text size.
  final double? statusIconSize;

  /// Text style for the meta block (timestamp + Edited label). Defaults
  /// to a 70% alpha variant of [textStyle].
  final TextStyle? metaStyle;

  /// Creates a [TimestampedChatMessage].
  const TimestampedChatMessage({
    super.key,
    required this.text,
    required this.textStyle,
    this.timestamp,
    this.isEdited = false,
    this.statusIcon,
    this.statusIconColor,
    this.statusIconSize,
    this.metaStyle,
  });

  TextStyle _resolvedMetaStyle() {
    if (metaStyle != null) return metaStyle!;
    final base = textStyle;
    return base.copyWith(
      fontSize: 11,
      color: (base.color ?? Colors.black87).withValues(alpha: 0.7),
    );
  }

  TextSpan _buildMetaTextSpan() {
    final resolved = _resolvedMetaStyle();
    final children = <InlineSpan>[];
    if (isEdited) {
      children.add(TextSpan(
        text: 'Edited ',
        style: resolved.copyWith(fontStyle: FontStyle.italic),
      ));
    }
    if (timestamp != null && timestamp!.isNotEmpty) {
      children.add(TextSpan(text: timestamp, style: resolved));
    }
    return TextSpan(children: children, style: resolved);
  }

  bool get _hasMetaText =>
      isEdited || (timestamp != null && timestamp!.isNotEmpty);

  @override
  RenderObject createRenderObject(BuildContext context) {
    final resolved = _resolvedMetaStyle();
    return _TimestampedChatMessageRenderObject(
      messageSpan: TextSpan(text: text, style: textStyle),
      metaTextSpan: _hasMetaText ? _buildMetaTextSpan() : null,
      statusIcon: statusIcon,
      statusIconColor: statusIconColor ?? resolved.color ?? Colors.black54,
      statusIconSize: statusIconSize ?? (resolved.fontSize ?? 11) * 1.15,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final resolved = _resolvedMetaStyle();
    (renderObject as _TimestampedChatMessageRenderObject)
      ..messageSpan = TextSpan(text: text, style: textStyle)
      ..metaTextSpan = _hasMetaText ? _buildMetaTextSpan() : null
      ..statusIcon = statusIcon
      ..statusIconColor = statusIconColor ?? resolved.color ?? Colors.black54
      ..statusIconSize = statusIconSize ?? (resolved.fontSize ?? 11) * 1.15
      ..textDirection = Directionality.of(context);
  }
}

class _TimestampedChatMessageRenderObject extends RenderBox {
  _TimestampedChatMessageRenderObject({
    required TextSpan messageSpan,
    required TextSpan? metaTextSpan,
    required IconData? statusIcon,
    required Color statusIconColor,
    required double statusIconSize,
    required TextDirection textDirection,
  })  : _messageSpan = messageSpan,
        _metaTextSpan = metaTextSpan,
        _statusIcon = statusIcon,
        _statusIconColor = statusIconColor,
        _statusIconSize = statusIconSize,
        _textDirection = textDirection,
        _messagePainter = TextPainter(
          text: messageSpan,
          textDirection: textDirection,
        ),
        _metaTextPainter = TextPainter(
          text: metaTextSpan ?? const TextSpan(text: ''),
          textDirection: textDirection,
          maxLines: 1,
        ),
        _iconPainter = TextPainter(textDirection: textDirection) {
    _rebuildIconPainter();
  }

  TextSpan _messageSpan;
  TextSpan? _metaTextSpan;
  IconData? _statusIcon;
  Color _statusIconColor;
  double _statusIconSize;
  TextDirection _textDirection;

  final TextPainter _messagePainter;
  final TextPainter _metaTextPainter;
  final TextPainter _iconPainter;

  // Spacing between the message's last word and the meta block, and
  // between the meta text and the status icon.
  static const double _metaGap = 6;
  static const double _iconGap = 3;

  // Cached values populated by [_layout] and consumed by [paint].
  bool _metaFitsOnLastLine = false;
  int _numLines = 0;
  // Distance from the top of the message paragraph to the baseline of its
  // last line. Used to align the smaller meta text/icon onto the same
  // baseline as the message text.
  double _lastLineBaseline = 0;
  double _metaTotalWidth = 0;
  double _longestLineWidth = 0;

  set messageSpan(TextSpan value) {
    if (value == _messageSpan) return;
    _messageSpan = value;
    _messagePainter.text = value;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  set metaTextSpan(TextSpan? value) {
    if (value == _metaTextSpan) return;
    _metaTextSpan = value;
    _metaTextPainter.text = value ?? const TextSpan(text: '');
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  set statusIcon(IconData? value) {
    if (value == _statusIcon) return;
    _statusIcon = value;
    _rebuildIconPainter();
    markNeedsLayout();
  }

  set statusIconColor(Color value) {
    if (value == _statusIconColor) return;
    _statusIconColor = value;
    _rebuildIconPainter();
    markNeedsPaint();
  }

  set statusIconSize(double value) {
    if (value == _statusIconSize) return;
    _statusIconSize = value;
    _rebuildIconPainter();
    markNeedsLayout();
  }

  set textDirection(TextDirection value) {
    if (value == _textDirection) return;
    _textDirection = value;
    _messagePainter.textDirection = value;
    _metaTextPainter.textDirection = value;
    _iconPainter.textDirection = value;
    markNeedsLayout();
  }

  void _rebuildIconPainter() {
    final icon = _statusIcon;
    if (icon == null) {
      _iconPainter.text = const TextSpan(text: '');
      return;
    }
    _iconPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        fontSize: _statusIconSize,
        color: _statusIconColor,
        height: 1,
      ),
    );
  }

  bool get _hasMetaText => _metaTextSpan != null;
  bool get _hasIcon => _statusIcon != null;
  bool get _hasMeta => _hasMetaText || _hasIcon;

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isSemanticBoundary = true;
    final base = _messageSpan.toPlainText();
    final meta = _metaTextSpan?.toPlainText() ?? '';
    config.label = meta.isEmpty ? base : '$base, $meta';
    config.textDirection = _textDirection;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    _layout(double.infinity);
    return _longestLineWidth;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    _layout(double.infinity);
    return _longestLineWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) =>
      computeMaxIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) => _layout(width).height;

  @override
  void performLayout() {
    final s = _layout(constraints.maxWidth);
    size = constraints.constrain(s);
  }

  Size _layout(double maxWidth) {
    assert(maxWidth > 0,
        'TimestampedChatMessage needs a positive maxWidth (got $maxWidth)');

    _messagePainter.layout(maxWidth: maxWidth);
    final lines = _messagePainter.computeLineMetrics();

    _longestLineWidth = 0;
    for (final line in lines) {
      _longestLineWidth = max(_longestLineWidth, line.width);
    }
    final double lastLineWidth = lines.isNotEmpty ? lines.last.width : 0;
    _numLines = lines.length;
    _lastLineBaseline = lines.isNotEmpty
        ? lines.last.baseline
        : _messagePainter
            .computeDistanceToActualBaseline(TextBaseline.alphabetic);

    if (!_hasMeta) {
      return Size(_longestLineWidth, _messagePainter.height);
    }

    // Lay out the meta painters and compute the combined meta block width.
    double metaTextWidth = 0;
    if (_hasMetaText) {
      _metaTextPainter.layout(maxWidth: maxWidth);
      metaTextWidth = _metaTextPainter.width;
    }
    double iconWidth = 0;
    if (_hasIcon) {
      _iconPainter.layout();
      iconWidth = _iconPainter.width;
    }
    _metaTotalWidth =
        metaTextWidth + (_hasMetaText && _hasIcon ? _iconGap : 0) + iconWidth;
    _longestLineWidth = max(_longestLineWidth, _metaTotalWidth);

    final double lastLinePlusMeta = lastLineWidth + _metaGap + _metaTotalWidth;

    if (_numLines <= 1) {
      _metaFitsOnLastLine = lastLinePlusMeta <= maxWidth;
    } else {
      _metaFitsOnLastLine =
          lastLinePlusMeta <= min(_longestLineWidth, maxWidth);
    }

    // Compute the meta block's vertical extent, measured as distances
    // above and below the (target) baseline.
    //   above = max(metaAscent, iconSize)   — icon may extend above text top
    //   below = metaDescent (icon bottom sits ON the baseline)
    double aboveBaseline = 0;
    double belowBaseline = 0;
    if (_hasMetaText) {
      final metaAscent = _metaTextPainter
          .computeDistanceToActualBaseline(TextBaseline.alphabetic);
      aboveBaseline = metaAscent;
      belowBaseline = _metaTextPainter.height - metaAscent;
    }
    if (_hasIcon) {
      aboveBaseline = max(aboveBaseline, _statusIconSize);
    }

    if (_metaFitsOnLastLine) {
      final width = _numLines <= 1 ? lastLinePlusMeta : _longestLineWidth;
      // Meta is baseline-aligned with the message's last line. The widget
      // height needs to cover whichever extends further:
      //   - the message paragraph itself (offset 0 → _messagePainter.height)
      //   - the meta block (offset (lastLineBaseline - aboveBaseline)
      //                       → lastLineBaseline + belowBaseline)
      final double metaTopAbsolute = _lastLineBaseline - aboveBaseline;
      final double metaBottomAbsolute = _lastLineBaseline + belowBaseline;
      // metaTopAbsolute can be negative (icon sticking above message top).
      // Shift origin so nothing has negative coords by adding |metaTopAbsolute|
      // to the overall height when needed; the paint() routine already
      // clamps to offset.dy so the simplest correct fix is to add the
      // overflow to the height.
      final double topOverflow = max(0, -metaTopAbsolute);
      final double bottomEdge = max(_messagePainter.height, metaBottomAbsolute);
      return Size(width, bottomEdge + topOverflow);
    }
    // Meta drops to a new line below the message.
    final double metaBlockHeight = aboveBaseline + belowBaseline;
    return Size(_longestLineWidth, _messagePainter.height + metaBlockHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _messagePainter.paint(context.canvas, offset);
    if (!_hasMeta) return;

    // The meta block (text + icon) is right-aligned. Compute its left edge.
    final double metaLeft = offset.dx + size.width - _metaTotalWidth;

    // Anchor target: the alphabetic baseline of the message's last line.
    // The message text and the (smaller) meta block share this baseline
    // when meta fits inline — so "Hello" and "11:24 AM ✓✓" sit on the
    // same line visually, instead of the smaller meta floating at the top
    // of the line box.
    final double messageBaselineY = _metaFitsOnLastLine
        ? offset.dy + _lastLineBaseline
        : offset.dy + _messagePainter.height; // wraps-below: no anchor

    // Paint the meta text with its baseline on messageBaselineY.
    if (_hasMetaText) {
      final metaAscent = _metaTextPainter
          .computeDistanceToActualBaseline(TextBaseline.alphabetic);
      final metaTextY = _metaFitsOnLastLine
          ? messageBaselineY - metaAscent
          : messageBaselineY; // top-align when wrapped below
      _metaTextPainter.paint(context.canvas, Offset(metaLeft, metaTextY));
    }

    // Icon bottom on the same baseline.
    if (_hasIcon) {
      final double iconX =
          metaLeft + (_hasMetaText ? _metaTextPainter.width + _iconGap : 0);
      final double iconY;
      if (_metaFitsOnLastLine) {
        iconY = messageBaselineY - _statusIconSize;
      } else if (_hasMetaText) {
        final metaAscent = _metaTextPainter
            .computeDistanceToActualBaseline(TextBaseline.alphabetic);
        iconY = messageBaselineY + metaAscent - _statusIconSize;
      } else {
        iconY = messageBaselineY;
      }
      _iconPainter.paint(context.canvas, Offset(iconX, iconY));
    }
  }

  @override
  void dispose() {
    _messagePainter.dispose();
    _metaTextPainter.dispose();
    _iconPainter.dispose();
    super.dispose();
  }
}
