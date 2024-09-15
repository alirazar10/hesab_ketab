import 'package:flutter/material.dart';
import 'package:hesab_ketab/appUI/Water_bills.dart';
import 'package:hesab_ketab/appUI/email_confirmation.dart';
import 'package:hesab_ketab/appUI/hesab_ketab.dart';
import 'package:hesab_ketab/appUI/login.dart';
import 'package:hesab_ketab/appUI/register.dart';
import 'package:hesab_ketab/appUI/welcome.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:hesab_ketab/main.dart';

class GenerateRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/welcome':
        return MaterialPageRoute(builder: (_) => Welcome());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/unAuthUser':
        return MaterialPageRoute(builder: (_) => UnauthenticatedUser());
      case '/hesabKetab':
        return MaterialPageRoute(
            builder: (_) => HesabKetab(
                  userData: {},
                ));
      case '/register':
        return MaterialPageRoute(builder: (_) => Register());
      case '/confirmEmail':
        return MaterialPageRoute(builder: (_) => EmailConfirmation());
      case '/waterBills':
        return MaterialPageRoute(builder: (_) => WaterBills());
      default:
        return MaterialPageRoute(builder: (_) => Login());
    }
  }
}
