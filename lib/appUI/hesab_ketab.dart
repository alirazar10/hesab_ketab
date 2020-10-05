import 'package:flutter/material.dart';
import 'home.dart';
import 'show_electricity.dart';
import 'show_water.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class HesabKetab extends StatefulWidget {
  final Map userData;
  HesabKetab({Key key, this.userData}) : super(key: key);

  @override
  _HesabKetabState createState() => _HesabKetabState();
}

class _HesabKetabState extends State<HesabKetab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(icon: Icon(Icons.more_vert), onPressed: () { print('clicked'); },), 
            
          ],
          automaticallyImplyLeading: false,
          title: Text('Hesab Ketab'),
          centerTitle: true,
          titleSpacing: 10.0,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home), 
                text: 'Home',
              ),
              Tab(
                icon: Icon(Icons.ac_unit),
                text: 'Water',
              ),
              Tab(
                icon: FaIcon(FontAwesomeIcons.lightbulb),
                text: 'Electricity',
              ),
              
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Home(),
            Water(),
            Electricity()
          ],
        ),
      ),
      length: 3,
      initialIndex: 0,
    );
  }
}