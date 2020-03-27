import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  int _counterImage = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: Image.asset('images/$_counterImage.png', height: 100.0),
        ),
        Text('Flutter!', 
          textAlign: TextAlign.center, 
          style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.bold)
        ),
        Text('Styled Emoji $_counter!', 
          textAlign: TextAlign.center, 
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 30, 
            decoration: TextDecoration.none
          )
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _counter++;
                      if(_counter<1) _counterImage=1;
                      else if(_counter>6) _counterImage=6;
                      else _counterImage = _counter;
                    });
                  },
                  child: Icon(Icons.exposure_plus_1),
                )
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _counter--;
                      if(_counter<1) _counterImage=1;
                      else if(_counter>6) _counterImage=6;
                      else _counterImage = _counter;
                    });
                  },
                  child: Icon(Icons.exposure_neg_1),
                )
              )
            ],
          )
        ),
      ],
    );
  }
}