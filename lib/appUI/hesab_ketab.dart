import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
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
          backgroundColor: Colors.blueGrey,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.more_vert), onPressed: () { print('clicked'); },), 
            
          ],
          automaticallyImplyLeading: false,
          title: Text('حساب کتاب'),
          centerTitle: true,
          titleSpacing: 10.0,
          bottom: TabBar(
            // isScrollable: true,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home, size: 22.0,), 
                // text: 'خانه',
                child: Text('خانه', style: myTextStyle(fontSize: 14.0),),

              ),
              Tab(
                icon: Icon(FontAwesomeIcons.handHoldingWater, size: 22.0,),
                // text: 'آب',
                child: Text('آب', style: myTextStyle(fontSize: 14.0),),
              ),
              Tab(
                // iconMargin: EdgeInsets.only(bottom: 8.0),
                icon: FaIcon(FontAwesomeIcons.bolt, size: 22.0,),
                // text: 'برق',
                child: Text('برق', style: myTextStyle(fontSize: 14.0),),
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