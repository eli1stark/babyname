import 'package:flutter/material.dart';

class FolderButton extends StatelessWidget {
  FolderButton({this.icon, this.onTap, this.borderRadius, this.color});

  final IconData icon;
  final Function onTap;
  final BorderRadius borderRadius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      color: Colors.blueGrey[100],
      child: Container(
        child: Icon(
          icon,
          size: 70.0,
          color: color,
        ),
      ),
      onPressed: onTap,
    );
  }
}
