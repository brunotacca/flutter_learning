import 'package:flutter/material.dart';
import 'page3_page.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articles List'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Next'),
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => PagePage())
            );
          },
        )
      ),
    );
  }
}