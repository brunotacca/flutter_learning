import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rss_feed_list/pages/articles_page.dart';
import '../data/local_storage.dart';

class HomePage extends StatefulWidget {
  final LocalStorage storage;

  HomePage({Key key, @required this.storage}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final feedController = TextEditingController();
  List feeds = [ ];

  @override
  void initState() {
    super.initState();
    widget.storage.readFileFeeds().then((data) {
      setState(() {
        feeds = data;
      });
    });
  }

  Future<File> _addFeed() {

    if(_formKey.currentState.validate()) {
      setState(() {
        feeds.add(feedController.text);
        feedController.text = '';
      });
    }

    // Write the variable as a string to the file.
    return widget.storage.writeFeeds(feeds);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('My RSS Feeds'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: feeds.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(feeds[index]),
                      leading: Icon(Icons.rss_feed),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticlePage(feed: feeds[index])
                          )
                        );
                      },
                    );
                  }
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.url,
                controller: feedController,
                decoration: InputDecoration(
                  labelText: "Link do RSS"
                ),
                validator: (value) {
                  if(value.isEmpty) {
                    return "Can not be empty";
                  }
                  return null;
                },
              ),
              RaisedButton(
                child: Text('Add'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: _addFeed,
              )
            ],
          ),
        ),
      ),
    );
  }
}