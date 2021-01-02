import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import '../appUI/welcome.dart';
import '../appUI/login.dart';
import 'package:hesab_ketab/main.dart';
class GenerateRoute {
  static Route<dynamic> generateRoute(RouteSettings settings){
    final arg = settings.arguments;

    switch (settings.name){
      case '/':
        return MaterialPageRoute(builder: (context)=> SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (context)=> Login());
      case '/unAuthUser':
        return MaterialPageRoute(builder: (context)=> UnauthenticatedUser());
      default:
        return MaterialPageRoute(builder: (context)=> Login());

    }
  }
}