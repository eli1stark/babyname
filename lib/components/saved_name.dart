import 'package:flutter/material.dart';

class SavedName extends StatelessWidget {
  SavedName({@required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(
              color: Colors.deepOrange[100],
              width: 5,
            ),
          ),
          width: double.infinity,
          height: 70,
          child: Center(
            child: FittedBox(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 50.0,
                  fontFamily: 'Acme',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
