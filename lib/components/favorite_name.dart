import 'package:flutter/material.dart';

class FavoriteName extends StatelessWidget {
  FavoriteName({@required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            right: 5.0,
            left: 50.0,
          ),
          decoration: BoxDecoration(
            color: Colors.cyan[300],
            border: Border.all(
              color: Colors.pinkAccent[200],
              width: 5,
            ),
          ),
          width: double.infinity,
          height: 70,
          child: Row(
            children: <Widget>[
              Expanded(
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
              Icon(
                Icons.star,
                size: 45.0,
                color: Colors.yellow[400],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
