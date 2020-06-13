import 'package:flutter/material.dart';

SnackBar buildSnackBar(String text) {
  return SnackBar(
    duration: Duration(
      seconds: 2,
    ),
    content: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Acme',
        letterSpacing: 1.0,
      ),
    ),
    backgroundColor: Colors.blueGrey[700],
  );
}
