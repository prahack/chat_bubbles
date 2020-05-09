import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double BUBBLE_RADIUS = 16;

class BubbleNormal extends StatelessWidget {
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final String text;
  final bool tail;

  BubbleNormal({
    Key key,
    @required this.text,
    this.bubbleRadius,
    this.isSender = true,
    this.color,
    this.tail = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        isSender
            ? Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : Container(),
        Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: color ?? Colors.white70,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(bubbleRadius ?? BUBBLE_RADIUS),
                      topRight: Radius.circular(bubbleRadius ?? BUBBLE_RADIUS),
                      bottomLeft: Radius.circular(tail
                          ? isSender ? bubbleRadius ?? BUBBLE_RADIUS : 0
                          : BUBBLE_RADIUS),
                      bottomRight: Radius.circular(tail
                          ? isSender ? 0 : bubbleRadius ?? BUBBLE_RADIUS
                          : BUBBLE_RADIUS),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Column(
                      children: <Widget>[
                        Text(
                          text,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
