import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(title: "People counter", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _people = 0;
  String _infoText = "Come in!";

  void _changePeople(int delta) {
    setState(() {
      _people += delta;

      if (_people < 0) {
        _infoText = "Upside down?!";
      } else if (_people <= 10) {
        _infoText = "Come in!";
      } else {
        _infoText = "Hodor!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/restaurant.jpg",
          fit: BoxFit.cover,
          height: 1000.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "People: $_people",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text(
                      "+1",
                      style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      _changePeople(1);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text(
                      "-1",
                      style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      _changePeople(-1);
                    },
                  ),
                ),
              ],
            ),
            Text(
              _infoText,
              style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontSize: 30.0,
                decoration: TextDecoration.none,
              ),
            )
          ],
        )
      ],
    );
  }
}
