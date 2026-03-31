import 'package:flutter/material.dart';

/// Style configuration for a `MessageBar`.
///
/// Groups commonly used appearance and input properties such as borders,
/// padding, keyboard type, and background color.
class MessageBarStyle {
  /// Border when the input is enabled but not focused.
  final InputBorder enabledBorder;

  /// Border when the input is focused.
  final InputBorder focusedBorder;

  /// Keyboard type for the input field.
  final TextInputType keyboardType;

  /// Text capitalization behavior.
  final TextCapitalization textCapitalization;

  /// Inner padding of the input field.
  final EdgeInsetsGeometry contentPadding;

  /// Background color of the input field.
  final Color fillColor;

  /// Creates a `MessageBarStyle`.
  ///
  /// All parameters are optional and default to the standard `MessageBar` style.
  const MessageBarStyle({
    this.enabledBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(
        color: Colors.white,
        width: 0.2,
      ),
    ),
    this.focusedBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(
        color: Colors.black26,
        width: 0.2,
      ),
    ),
    this.keyboardType = TextInputType.multiline,
    this.textCapitalization = TextCapitalization.sentences,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
    this.fillColor = Colors.white,
  });
}
