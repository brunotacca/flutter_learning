import 'package:flutter/material.dart';
import 'package:user_register_sqlite/utils/connection.dart';
import 'package:user_register_sqlite/form_user.dart';
import 'package:user_register_sqlite/list_users.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Database _database;
  List _users = [];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FormUser(
            onSaved: () {
              getUsers();
            },
          ),
          ListUsers(
            users: _users,
            onChange: () {
              getUsers();
            }
          ),
        ],
      ),
    );
  }

  getUsers() async {
    _database = await SqliteDB.connect();
    dynamic queryData = await _database.rawQuery('select * from user').then((data) {
      return data;
    });

    if (queryData != null) {
      setState(() {
        _users = queryData;
      });
    }
  }
}
