import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  ImageButton({this.color, this.imagePath, this.onTap});

  final Color color;
  final String imagePath;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          child: Image.asset(imagePath),
        ),
        color: color,
        onPressed: onTap,
      ),
    );
  }
}
