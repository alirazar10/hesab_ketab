import 'package:flutter/material.dart';
import 'package:hesab_ketab/appUI/email_confirmation.dart';
import 'package:hesab_ketab/appUI/hesab_ketab.dart';
import 'package:hesab_ketab/appUI/login.dart';
import 'package:hesab_ketab/appUI/welcome.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/main.dart';
class GenerateRoute {
  static Route<dynamic> generateRoute(RouteSettings settings){
    final arg = settings.arguments;

    switch (settings.name){
      case '/':
        return MaterialPageRoute(builder: (context)=> SplashScreen());
      case '/welcome':
        return MaterialPageRoute(builder: (context) => Welcome());
      case '/login':
        return MaterialPageRoute(builder: (context)=> Login());
      case '/unAuthUser':
        return MaterialPageRoute(builder: (context)=> UnauthenticatedUser());
      case '/hesabKetab':
        return MaterialPageRoute(builder: (context)=> HesabKetab());
      case '/register': 
        return MaterialPageRoute(builder: (context)=> Register());
      case '/confirmEmail':
        return MaterialPageRoute(builder: (context)=> EmailConfirmation()); 
      default:
        return MaterialPageRoute(builder: (context)=> Login());

    }
  }
}