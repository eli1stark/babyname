import 'package:flutter/material.dart';

class ArrowBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back,
          size: 40.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
