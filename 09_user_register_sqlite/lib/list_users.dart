import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:user_register_sqlite/utils/connection.dart';
import 'package:user_register_sqlite/form_edit_user.dart';

class ListUsers extends StatefulWidget {
  final List users;
  final onChange;

  ListUsers({Key key, this.users, this.onChange}) : super(key: key);

  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  @override
  Widget build(BuildContext context) {
    List _users = widget.users;
    return Expanded(
      child: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: SlidableBehindActionPane(),
            child: Container(
              color: Colors.white,
              child: ListTile(
                title: Text(_users[index]['name']),
                subtitle: Text(_users[index]['email']),
              ),
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Edit',
                color: Colors.blue,
                icon: Icons.edit,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Edit'),
                        content: FormEditUser(
                          initialData: _users[index],
                          onChange: (){
                            widget.onChange();
                          }
                        ),
                      );
                    },
                  );
                },
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  SqliteDB.connect().then((database) {
                    return database.rawDelete(
                      'DELETE FROM user WHERE id = ?',
                      [_users[index]['id']],
                    );
                  }).then((data) {
                    widget.onChange();
                  });
                },
              )
            ],
          );
        },
      ),
    );
  }
}
