import 'package:flutter/material.dart';
import 'package:user_register_sqlite/utils/connection.dart';

class FormUser extends StatefulWidget {
  final onSaved;
  FormUser({Key key, this.onSaved}): super(key: key);

  @override
  _FormUserState createState() => _FormUserState();
}

class _FormUserState extends State<FormUser> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {'enabled': false};

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Can not be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData['name'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Can not be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData['email'] = value;
                },
              ),
              Switch(
                value: _formData['enabled'],
                onChanged: (value) {
                  _formData['enabled'] = value;
                },
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text(
                  'Create',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _insertData();
                    _formKey.currentState.reset();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _insertData() async {
    var data = [_formData['name'], _formData['email'], _formData['enabled']];

    var database = await SqliteDB.connect();
    database.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO user (name, email, enabled) VALUES (?, ?, ?)',
        data,
      );
      widget.onSaved();
    });
  }
}
