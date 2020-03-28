import 'package:flutter/material.dart';
import './aticles_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final feedController = TextEditingController();
  List feeds = [ ];

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
                onPressed: () {
                  if(_formKey.currentState.validate()) {
                    setState(() {
                      feeds.add(feedController.text);
                      feedController.text = '';
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}