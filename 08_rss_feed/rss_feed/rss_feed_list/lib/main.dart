import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'data/local_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter RSS Feed',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(storage: LocalStorage()),
    );
  }
}
