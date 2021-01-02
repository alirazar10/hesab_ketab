import 'package:flutter/material.dart';
import 'package:hesab_ketab/appUI/hesab_ketab.dart';
import 'package:hesab_ketab/appUI/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appUI/welcome.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'utils/routes.dart';
import 'utils/navigationService.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // var email = prefs.getString('user');
  // // prefs.remove('user');
  // // prefs.remove('toLogin');
  // var firstTimeSeen = prefs.getBool('toLogin');
  // // print(firstTimeSeen);

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
      navigatorKey: NavigationService.instance.navigationKey,
      // onGenerateRoute: ,
      // home: email == null ? (firstTimeSeen == null ? Welcome() : Login()) : HesabKetab() ,
      initialRoute: '/',
      onGenerateRoute: GenerateRoute.generateRoute,
    ),
  );
}


class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  var email;
  var firstTimeSeen;
  
  duration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('user');
    // prefs.remove('user');
    // prefs.remove('toLogin');
    var firstTimeSeen = prefs.getBool('toLogin');
    Future.delayed(Duration(seconds: 3),(){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => email == null ? (firstTimeSeen == null ? Welcome() : Login()) : HesabKetab(),
        ),
        (Route<dynamic> route) => false
      );
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    duration();
  }

  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(' '),
              // child: Image.asset('assets/images/logo/logo_no_txt.png',width: 300,height: 300),
            ),
            // CircularProgressIndicator(),
            SizedBox(
              width: 250.0,
              child: TextLiquidFill(
                    loadDuration: Duration(seconds: 3),
                    waveDuration: Duration(seconds: 5),
                    text: 'حساب کتاب',
                    waveColor: Color(0xff00BCD4),
                    boxBackgroundColor: Colors.white,
                    textStyle: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                    boxHeight: 100.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo/imor_black.png',width: 50,height: 50),
                SizedBox(width: 10.0,),
                Text('Powered by'),
              ],
            ),
          ],
        )
      ) 
    );
  }
}