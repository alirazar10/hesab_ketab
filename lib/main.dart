import 'package:flutter/material.dart';
import 'package:hesab_ketab/appUI/hesab_ketab.dart';
import 'package:hesab_ketab/appUI/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appUI/welcome.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('user');
  // prefs.remove('user');
  // prefs.remove('toLogin');
  var firstTimeSeen = prefs.getBool('toLogin');
  // print(firstTimeSeen);

  
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      supportedLocales: [
        const Locale('en', ''), // American English
        const Locale('fa', ''), // Persian 
        // ...
      ],
      locale: Locale("fa", "IR"),

      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Color(0xFFFF5722),
        dividerColor : Colors.grey[300],
        // Define the default font family.
        fontFamily: 'myFont',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      title: 'الکتروخانه',
      // onGenerateRoute: ,
      home: email == null ? (firstTimeSeen == null ? Welcome() : Login()) : HesabKetab() ,
    ),
  );
}
