import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewMessageBubble extends StatelessWidget {
  final bool isMe;
  final String text;
  final String timestamp;
  const ViewMessageBubble(
      {super.key,
      required this.isMe,
      required this.text,
      required this.timestamp});

  @override
  Widget build(BuildContext context) {
    DateFormat timeFormat = DateFormat('HH:mm');
    return ChatBubble(
      margin: const EdgeInsets.symmetric(vertical: 10),
      clipper: ChatBubbleClipper5(
          type: isMe ? BubbleType.sendBubble : BubbleType.receiverBubble),
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      backGroundColor: isMe ? Colors.lightBlue : Colors.blueAccent,
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.5,
            ),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  text,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ))
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                  textAlign: TextAlign.left,
                  timeFormat.format(
                    DateTime.parse(timestamp),
                  ),
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final CustomClipper? clipper;

  /// The `child` property of the `ChatBubble` is used to specify the widget
  /// contained within the bounds.
  final Widget? child;

  /// Empty space to surround [child].
  final EdgeInsetsGeometry? margin;

  /// The z-coordinate relative to the parent at which to place this physical
  /// object.
  ///
  /// The value is non-negative.
  final double? elevation;

  /// The color used for the background.
  final Color? backGroundColor;

  /// Specifies the color to use for the shadow when the `elevation` is non-zero.
  final Color? shadowColor;

  /// Aligns the `child` widget within the bounds of the `Container`.
  final Alignment? alignment;

  /// Empty space to inscribe inside the [child], if any, is placed inside this
  /// padding.
  ///
  /// If padding is not specified, the default space will be calculated based on
  /// the selected clipper type.
  final EdgeInsetsGeometry? padding;

  const ChatBubble(
      {super.key,
      this.clipper,
      this.child,
      this.margin,
      this.elevation,
      this.backGroundColor,
      this.shadowColor,
      this.alignment,
      this.padding});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.topLeft,
      margin: margin ?? const EdgeInsets.all(0),
      child: PhysicalShape(
        clipper: clipper as CustomClipper<Path>,
        elevation: elevation ?? 2,
        color: backGroundColor ?? Colors.blue,
        shadowColor: shadowColor ?? Colors.grey.shade200,
        child: Container(
          padding: padding,
          child: child ?? Container(),
        ),
      ),
    );
  }
}

/// An enumeration of different types of chat bubbles.
enum BubbleType {
  /// Represents a sender's bubble displayed on the left side.
  sendBubble,

  /// Represents a receiver's bubble displayed on the right side.
  receiverBubble
}

class ChatBubbleClipper5 extends CustomClipper<Path> {
  ///The values assigned to the clipper types [BubbleType.sendBubble] and
  ///[BubbleType.receiverBubble] are distinct.
  final BubbleType? type;

  ///The radius, which creates the curved appearance of the chat widget,
  ///has a default value of 15.
  final double radius;

  /// This displays the radius for the bottom corner curve of the widget,
  /// with a default value of 2.
  final double secondRadius;

  ChatBubbleClipper5({this.type, this.radius = 15, this.secondRadius = 2});

  @override
  Path getClip(Size size) {
    var path = Path();

    if (type == BubbleType.sendBubble) {
      path.addRRect(RRect.fromLTRBR(
          0, 0, size.width, size.height, Radius.circular(radius)));
      var path2 = Path();
      path2.addRRect(RRect.fromLTRBAndCorners(0, 0, radius, radius,
          bottomRight: Radius.circular(secondRadius)));
      path.addPath(path2, Offset(size.width - radius, size.height - radius));
    } else {
      path.addRRect(RRect.fromLTRBR(
          0, 0, size.width, size.height, Radius.circular(radius)));
      var path2 = Path();
      path2.addRRect(RRect.fromLTRBAndCorners(0, 0, radius, radius,
          topLeft: Radius.circular(secondRadius)));
      path.addPath(path2, const Offset(0, 0));
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
