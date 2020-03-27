import 'package:flutter/material.dart';
import 'home_page.dart';

class PagePage extends StatefulWidget {
  @override
  _PagePageState createState() => _PagePageState();
}

class _PagePageState extends State<PagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('??'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Home'),
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => HomePage())
                );
              },
            ),
            RaisedButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        )
      ),
    );
  }
}