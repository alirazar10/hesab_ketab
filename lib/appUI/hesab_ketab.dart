import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
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
  final _hesabKetabScaffoldGlobalKey = GlobalKey<ScaffoldState>();

BuildContext _context;
  
  @override
  Widget build(BuildContext context) {
    _context = context;
    return DefaultTabController(
      child: Scaffold(
        key: _hesabKetabScaffoldGlobalKey,
        appBar: AppBar(
          elevation: 10.0,
          backgroundColor: Color(0xC2212121),
          actions: <Widget>[
            // IconButton(icon: Icon(Icons.more_vert), onPressed: () { print('clicked'); },), 
            PopupMenuButton<String>(
              elevation: 20.0,
              onSelected: choiceAction,
              itemBuilder: (BuildContext context){
                  return Constants.choices.map((choice){
                      return PopupMenuItem<String>(
                          value: choice['value'],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Icon(choice['icon'], color: Colors.grey,),
                                  SizedBox(width: 10.0,),
                                  Text(choice['value']),
                                ],
                              ),
                              Divider()
                            ],
                          ),
                      );
                  }).toList();
              },
            ) 
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
  void choiceAction(String choice){
    if(choice == Constants.settings){
        print('Settings');
    }
    else if(choice == Constants.help){
        print('Subscribe');
    }
    else if(choice == Constants.signOut){
        logout(_context, _hesabKetabScaffoldGlobalKey);
    }
  }
}

class Constants{
  static const String profile = 'Profile';
  static const String help = 'Help';
  static const String settings = 'Settings';
  static const String signOut = 'Log out';

  static const List<Map> choices = <Map>[
    {'value':profile, 'icon': Icons.account_circle},
    {'value':settings, 'icon': Icons.settings},
    {'value':help, 'icon': Icons.help},
    {'value':signOut,'icon': Icons.logout}
  ];
}


// appBar: AppBar(
//         title: Text('Homepage'),
//         actions: <Widget>[
//           PopupMenuButton<String>(
//             onSelected: handleClick,
//             itemBuilder: (BuildContext context) {
//               return {'Logout', 'Settings'}.map((String choice) {
//                 return PopupMenuItem<String>(
//                   value: choice,
//                   child: Text(choice),
//                 );
//               }).toList();
//             },
//           ),
//         ],
//       ),


// void handleClick(String value) {
//     switch (value) {
//       case 'Logout':
//         break;
//       case 'Settings':
//         break;
//     }
// }