import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/get_name.dart';

void main() {
  runApp(BabyName());
}

class BabyName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: GetName(),
    );
  }
}
