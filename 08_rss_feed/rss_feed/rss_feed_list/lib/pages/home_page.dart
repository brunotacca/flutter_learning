import 'package:flutter/material.dart';
import './aticles_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My RSS Feeds'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Next'),
          onPressed: (){
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => ArticlePage())
            );
          },
        )
      ),
    );
  }
}