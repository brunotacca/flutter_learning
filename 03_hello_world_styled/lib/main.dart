import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Hello World",
        home: new HomeApp()
      );
    }
}

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromARGB(255, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Hello Flutter!', 
              textAlign: TextAlign.center, 
              style: TextStyle(
                color: Colors.blueAccent,
                decoration: TextDecoration.none
              )
            ),
            Text('Styled!', 
              textAlign: TextAlign.center, 
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 30, 
                decoration: TextDecoration.none
              )
            )
          ],
      )
    );
  }
}