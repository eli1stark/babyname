import 'package:flutter/material.dart';

class SwipeBackground extends StatelessWidget {
  SwipeBackground(
      {@required this.color, @required this.icon, @required this.swipe});

  final Color color;
  final IconData icon;

  /// If swipe is true then design for a swipe is from left to right.
  /// If swipe is false then design for a swipe is from right to left.
  final bool swipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 7,
          child: Container(
            padding: swipe
                ? EdgeInsets.only(left: 10.0)
                : EdgeInsets.only(right: 10.0),
            alignment: swipe ? Alignment.centerLeft : Alignment.centerRight,
            color: color,
            child: Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
