import 'package:chat_bubbles/message_bars/message_bar_style.dart';
import 'package:flutter/material.dart';

///Normal Message bar with more actions
///
/// following attributes can be modified
///
///
/// # BOOLEANS
/// [replying] is the additional reply widget top of the message bar
///
/// # STRINGS
/// [replyingTo] is the string to tag the replying message
/// [messageBarHitText] is the string to show as message bar hint
///
/// # WIDGETS
/// [actions] are the additional leading action buttons like camera
/// and file select
///
/// # COLORS
/// [replyWidgetColor] is the reply widget color
/// [replyIconColor] is the reply icon color on the left side of reply widget
/// [replyCloseColor] is the close icon color on the right side of the reply
/// widget
/// [messageBarColor] is the color of the message bar
/// [sendButtonColor] is the color of the send button
/// [messageBarHintStyle] is the style of the message bar hint
/// [sendButton] provides an optional widget for the send button
///
/// # METHODS
/// [onTextChanged] is the function which triggers after text every text change
/// [onSend] is the send button action
/// [onTapCloseReply] is the close button action of the close button on the
/// reply widget; usually change [replying] attribute to false
/// 
/// # CLASSES
/// [messageBarStyle] contains styling information for the textfield

class MessageBar extends StatelessWidget {
  /// whether the message bar is in reply mode
  final bool replying;
  /// the name or text of the message being replied to
  final String replyingTo;
  /// additional action buttons like camera and file select
  final List<Widget> actions;
  /// text controller for the message input field
  final TextEditingController _textController = TextEditingController();
  /// background color of the reply widget
  final Color replyWidgetColor;
  /// color of the reply icon
  final Color replyIconColor;
  /// color of the close icon in reply widget
  final Color replyCloseColor;
  /// background color of the message bar
  final Color messageBarColor;
  /// hint text for the message input field
  final String messageBarHintText;
  /// text style for the hint text
  final TextStyle messageBarHintStyle;
  /// text style for the input text
  final TextStyle textFieldTextStyle;
  /// color of the send button
  final Color sendButtonColor;
  /// callback function triggered on text change
  final void Function(String)? onTextChanged;
  /// callback function triggered when send button is pressed
  final void Function(String)? onSend;
  /// callback function triggered when close reply button is pressed
  final void Function()? onTapCloseReply;
  /// config to control appearance of the MessageBar textfield
  final MessageBarStyle messageBarStyle;
  /// optional custom widget to use as a send button
  final Widget? sendButton;

  /// [MessageBar] constructor
  ///
  ///
  MessageBar({
    super.key,
    this.replying = false,
    this.replyingTo = "",
    this.actions = const [],
    this.replyWidgetColor = const Color(0xffF4F4F5),
    this.replyIconColor = Colors.blue,
    this.replyCloseColor = Colors.black12,
    this.messageBarColor = const Color(0xffF4F4F5),
    this.sendButtonColor = Colors.blue,
    this.messageBarHintText = "Type your message here",
    this.messageBarHintStyle = const TextStyle(fontSize: 16),
    this.textFieldTextStyle = const TextStyle(color: Colors.black),
    this.onTextChanged,
    this.onSend,
    this.onTapCloseReply,
    this.messageBarStyle = const MessageBarStyle(),
    this.sendButton,
  });

  /// [MessageBar] builder method
  ///
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
            replying
                ? Container(
                    color: replyWidgetColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.reply,
                          color: replyIconColor,
                          size: 24,
                        ),
                        Expanded(
                          child: Text(
                            'Re : $replyingTo',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: onTapCloseReply,
                          child: Icon(
                            Icons.close,
                            color: replyCloseColor,
                            size: 24,
                          ),
                        ),
                      ],
                    ))
                : Container(),
            replying
                ? Container(
                    height: 1,
                    color: Colors.grey.shade300,
                  )
                : Container(),
            Container(
              color: messageBarColor,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Row(
                children: <Widget>[
                  ...actions,
                  Expanded(
                    child: TextField(
                        controller: _textController,
                        keyboardType: messageBarStyle.keyboardType,
                        textCapitalization: messageBarStyle.textCapitalization,
                        minLines: messageBarStyle.minLines,
                        maxLines: messageBarStyle.maxLines,
                        onChanged: onTextChanged,
                        style: textFieldTextStyle,
                        decoration: InputDecoration(
                          hintText: messageBarHintText,
                          hintMaxLines: 1,
                          contentPadding: messageBarStyle.contentPadding,
                          hintStyle: messageBarHintStyle,
                          fillColor: messageBarStyle.fillColor,
                          filled: true,
                          enabledBorder: messageBarStyle.enabledBorder,
                          focusedBorder: messageBarStyle.focusedBorder,
                        ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: InkWell(
                      child: sendButton ?? Icon(
                        Icons.send,
                        color: sendButtonColor,
                        size: 24,
                      ),
                      onTap: () {
                        if (_textController.text.trim() != '') {
                          if (onSend != null) {
                            onSend!(_textController.text.trim());
                          }
                          _textController.text = '';
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
      ),
    );
  }
}
