import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'utils/routes.dart';
import 'utils/navigationService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('user');
  var firstTimeSeen = prefs.getBool('toLogin');

  runApp(
    MyApp(email: email, firstTimeSeen: firstTimeSeen),
  );
}

class MyApp extends StatelessWidget {
  final String? email;
  final bool? firstTimeSeen;

  MyApp({required this.email, required this.firstTimeSeen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // American English
        Locale('fa', ''), // Persian
      ],
      locale: const Locale("fa", "IR"),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xFFFF5722)),
        dividerColor: Colors.grey[300],
        fontFamily: 'myFont',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 72.0,
              fontWeight: FontWeight.bold), // Replaces headline1
          headlineMedium: TextStyle(
              fontSize: 36.0,
              fontStyle: FontStyle.italic), // Replaces headline6
          bodyMedium: TextStyle(
              fontSize: 14.0, fontFamily: 'Hind'), // Replaces bodyText2
        ),
      ),
      title: 'الکتروخانه',
      navigatorKey: NavigationService.instance.navigationKey,
      initialRoute: email == null
          ? (firstTimeSeen == null ? '/welcome' : '/login')
          : '/hesabKetab',
      onGenerateRoute: GenerateRoute.generateRoute,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('user');
    var firstTimeSeen = prefs.getBool('toLogin');

    Future.delayed(const Duration(seconds: 3), () {
      if (email == null) {
        if (firstTimeSeen == null) {
          NavigationService.instance.navigateToRemoveUntil('/welcome');
        } else {
          NavigationService.instance.navigateToRemoveUntil('/login');
        }
      } else {
        NavigationService.instance.navigateToRemoveUntil('/hesabKetab');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: const Text(' '),
            ),
            SizedBox(
              width: 250.0,
              child: TextLiquidFill(
                loadDuration: const Duration(seconds: 3),
                waveDuration: const Duration(seconds: 5),
                text: 'حساب کتاب',
                waveColor: const Color(0xff00BCD4),
                boxBackgroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
                boxHeight: 100.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo/imor_black.png',
                    width: 50, height: 50),
                const SizedBox(width: 10.0),
                const Text('Powered by'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
