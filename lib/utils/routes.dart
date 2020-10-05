import 'dart:js';

import 'package:flutter/material.dart';
import '../appUI/welcome.dart';
import '../appUI/login.dart';
class GenerateRout {
  Route<dynamic> generateRoute(RouteSettings settings){
    final arg = settings.arguments;

    switch (arg){
      case '/':
        return MaterialPageRoute(builder: (context)=> Welcome());
      case 'login':
        return MaterialPageRoute(builder: (context)=> Login());
      default:
        return MaterialPageRoute(builder: (context)=> Login());

    }
  }
}