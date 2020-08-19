import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final Map userData;
  Home({Key key, this.userData}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('This is the Drawer'),
            RaisedButton(
              onPressed: _closeDrawer,
              child: const Text('Close Drawer'),
            ),
          ],
        ),
      ),
    ),
    // Disable opening the drawer with a swipe gesture.
    drawerEnableOpenDragGesture: false,
      appBar:AppBar(
        title: Text('Home'),
        // centerTitle: true,
        actions: <Widget>[
          
        ],
        backgroundColor: Color(0xff00BCD4),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Text(widget.userData['user']['username'])
          ],
        )
      ),
    );
  }
}