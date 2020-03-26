import 'package:flutter/material.dart';

class SchoolPage extends StatefulWidget {
  @override
  _SchoolPageState createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Check this one:', 
          textAlign: TextAlign.center, 
          style: TextStyle(
            color: Colors.purple,
            fontSize: 30, 
            decoration: TextDecoration.none
          )
        ),
        RaisedButton(
          child: Text('Flutter.io', textAlign: TextAlign.center)
        )
      ],
    );
  }
}