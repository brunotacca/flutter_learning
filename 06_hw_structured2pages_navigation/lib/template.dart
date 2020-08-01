import 'package:flutter/material.dart';
import 'pages/homePage.dart';
import 'pages/schoolPage.dart';

class Template extends StatefulWidget {
  @override
  _TemplateState createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  var homePage = new HomePage();
  var schoolPage = new SchoolPage();
  var _selectedPage = 1; // Change this and reload to change the page. 0 or 1.
  var _pages;

  @override
  Widget build(BuildContext context) {
    _pages = [homePage, schoolPage];

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello World App'),
        backgroundColor: Colors.indigo,
      ),
      body: _body(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('School')
          )
        ],
        fixedColor: Colors.indigo,
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
    );
  }

  _body() {
    return Container(
      constraints: BoxConstraints.expand(),
      child: _pages[_selectedPage]
    );
  }
}