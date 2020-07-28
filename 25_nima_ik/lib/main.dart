import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';
import 'aim_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Flutter + Nima IK'),
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
  String _animationName = "run";
  AimController _oldManController = AimController();

  void _pointerMove(PointerMoveEvent details) {
    _oldManController
        .touchScreen(Offset(details.position.dx, details.position.dy));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(title: Text(widget.title)),
        body: Listener(
          onPointerMove: _pointerMove,
          child: Stack(children: <Widget>[
            Positioned.fill(
                child: NimaActor("assets/Old Man.nima",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    controller: _oldManController,
                    animation: _animationName,
                    mixSeconds: 0.5, completed: (String animationName) {
              setState(() {
                // Return to run.
                _animationName = "run";
              });
            })),
            Positioned.fill(
                child: Wrap(
              runAlignment: WrapAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: FlatButton(
                    child: Text("Jump"),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        _animationName = "jump";
                      });
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: FlatButton(
                    child: Text("Shoot"),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        _animationName = "shoot";
                      });
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: FlatButton(
                    child: Text("Run"),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        _animationName = "run";
                      });
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: FlatButton(
                    child: Text("Death"),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        _animationName = "Death";
                      });
                    },
                  ),
                )
              ],
            ))
          ]),
        ));
  }
}
