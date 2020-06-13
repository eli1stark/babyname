import 'package:flutter/material.dart';

class HelperMessage extends StatelessWidget {
  HelperMessage(
      {@required this.onTap,
      @required this.text,
      this.top,
      this.bottom,
      this.left,
      this.right,
      this.topRightCorner,
      this.topLeftCorner});

  final Function onTap;
  final String text;

  /// top and bottom - one of them must be null!
  /// left and right - one of them must be null!
  final double top;
  final double bottom;
  final double left;
  final double right;

  /// Bot corners must be specified (true or false)
  final bool topRightCorner;
  final bool topLeftCorner;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      height: 100.0,
      width: 170.0,
      child: Container(
        padding:
            EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.blue[200],
          borderRadius: BorderRadius.only(
            topLeft: topLeftCorner ? Radius.circular(0) : Radius.circular(40.0),
            topRight:
                topRightCorner ? Radius.circular(0) : Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Acme',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: FittedBox(
                  child: Text(
                    'Got It!',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black38,
                    ),
                  ),
                ),
                color: Colors.white24,
                onPressed: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
