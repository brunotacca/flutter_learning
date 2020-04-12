import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        ),
      ),
    ),
  );
}

const request = "https://api.hgbrasil.com/finance";
Future<Map> getData() async {
  http.Response response = await http.get(request);
  return (json.decode(response.body));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final bitcoinController = TextEditingController();

  double dolarPrice;
  double euroPrice;
  double bitcoinPrice;

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolarPrice).toStringAsFixed(2);
    euroController.text = (real / euroPrice).toStringAsFixed(2);
    bitcoinController.text = (real / bitcoinPrice).toStringAsFixed(6);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * dolarPrice).toStringAsFixed(2);
    euroController.text = (dolar * dolarPrice / euroPrice).toStringAsFixed(2);
    bitcoinController.text = (dolar * dolarPrice / bitcoinPrice).toStringAsFixed(6);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * euroPrice).toStringAsFixed(2);
    dolarController.text = (euro * euroPrice / dolarPrice).toStringAsFixed(2);
    bitcoinController.text = (euro * euroPrice / bitcoinPrice).toStringAsFixed(6);
  }

  void _bitcoinChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double bitcoin = double.parse(text);
    realController.text = (bitcoin * bitcoinPrice).toStringAsFixed(2);
    dolarController.text = (bitcoin * bitcoinPrice / dolarPrice).toStringAsFixed(2);
    euroController.text = (bitcoin * bitcoinPrice / euroPrice).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Converter \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error while loading data :(",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolarPrice = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euroPrice = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                bitcoinPrice = snapshot.data["results"]["currencies"]["BTC"]["buy"];
                //print("d: "+dolarPrice.toString()+" e:"+euroPrice.toString()+" b:"+bitcoinPrice.toString());

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                      buildTextField("BRL", "R\$", realController, _realChanged),
                      Divider(),
                      buildTextField("USD", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField("EUR", "€", euroController, _euroChanged),
                      Divider(),
                      buildTextField("BTC", "฿", bitcoinController, _bitcoinChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.amber,
        backgroundColor: Colors.transparent,
      ),
      border: OutlineInputBorder(),
      prefixText: prefix+" ",
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0, backgroundColor: Colors.transparent),
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
