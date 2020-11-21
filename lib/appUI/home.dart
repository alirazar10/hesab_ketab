import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  // final Map userData;
  // Home({Key key, this.userData}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
          children: <Widget>[
            // Text(widget.userData['user']['username'])
            Text('Home')
          ],
        )
    );
  }
}