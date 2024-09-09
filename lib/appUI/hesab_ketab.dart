import 'package:flutter/material.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'home.dart';
import 'show_electricity.dart';
import 'show_water.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HesabKetab extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HesabKetab({Key? key, required this.userData}) : super(key: key);

  @override
  _HesabKetabState createState() => _HesabKetabState();
}

class _HesabKetabState extends State<HesabKetab> {
  final GlobalKey<ScaffoldState> _hesabKetabScaffoldGlobalKey =
      GlobalKey<ScaffoldState>();

  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        key: _hesabKetabScaffoldGlobalKey,
        appBar: AppBar(
          elevation: 10.0,
          backgroundColor: Color(0xFF212121),
          actions: <Widget>[
            PopupMenuButton<String>(
              elevation: 20.0,
              onSelected: choiceAction,
              iconColor: Colors.white,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((choice) {
                  return PopupMenuItem<String>(
                    value: choice['value'] as String,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Icon(choice['icon'] as IconData,
                                color: Colors.grey),
                            const SizedBox(width: 10.0),
                            Text(choice['value'] as String),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ],
          automaticallyImplyLeading: false,
          title: const Text(
            'حساب کتاب',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          titleSpacing: 10.0,
          bottom: TabBar(
            indicatorWeight: 5.0,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Color(0xFFFF5722), // Change bottom border color
            labelColor: Color(0xFFFF5722), // Active tab text color
            unselectedLabelColor: Colors.white, // Inactive tab text color
            tabs: <Widget>[
              Tab(
                height: 55.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.home, size: 22.0),
                    const SizedBox(height: 5.0),
                    Text('خانه',
                        style:
                            myTextStyle(fontSize: 14.0, color: Colors.white)),
                  ],
                ),
              ),
              Tab(
                height: 55.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(FontAwesomeIcons.handHoldingDroplet, size: 22.0),
                    const SizedBox(height: 5.0),
                    Text('آب',
                        style:
                            myTextStyle(fontSize: 14.0, color: Colors.white)),
                  ],
                ),
              ),
              Tab(
                height: 55.0,
                child: Column(
                  children: [
                    const FaIcon(FontAwesomeIcons.bolt, size: 21.0),
                    const SizedBox(height: 5.0),
                    Text('برق',
                        style:
                            myTextStyle(fontSize: 14.0, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Home(),
            Water(),
            Electricity(),
          ],
        ),
      ),
    );
  }

  void choiceAction(String choice) {
    switch (choice) {
      case Constants.settings:
        print('Settings');
        break;
      case Constants.help:
        print('Help');
        break;
      case Constants.signOut:
        _showLogoutConfirmationDialog();
        break;
      default:
        print('Unknown action');
        break;
    }
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Log Out'),
              onPressed: () {
                Navigator.of(context).pop();
                logout(_context, _hesabKetabScaffoldGlobalKey);
              },
            ),
          ],
        );
      },
    );
  }
}

class Constants {
  static const String profile = 'Profile';
  static const String help = 'Help';
  static const String settings = 'Settings';
  static const String signOut = 'Log out';

  static const List<Map<String, dynamic>> choices = <Map<String, dynamic>>[
    {'value': profile, 'icon': Icons.account_circle},
    {'value': settings, 'icon': Icons.settings},
    {'value': help, 'icon': Icons.help},
    {'value': signOut, 'icon': Icons.logout},
  ];
}

// Define myTextStyle for consistency
TextStyle myTextStyle({double fontSize = 14.0, Color color = Colors.black}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
  );
}
