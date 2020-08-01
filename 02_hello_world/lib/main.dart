import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    title: "Hello World",
    home: new Container(
      color: Color.fromARGB(255, 255, 255, 255),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Hello Flutter!!!!', textAlign: TextAlign.center),
          Text('Alignment!', textAlign: TextAlign.center)
        ],
      )
    )
  ));
}