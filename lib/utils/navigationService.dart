import 'package:flutter/material.dart';

class NavigationService{

  GlobalKey<NavigatorState> navigationKey;

  static NavigationService instance = NavigationService();

  NavigationService(){
    navigationKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToRemoveUntil(String _rn, {dynamic arguments}){
    return navigationKey.currentState.pushNamedAndRemoveUntil(_rn, (Route<dynamic> route) => false, arguments: arguments);
  }

  Future<dynamic> navigateTo(String _rn, {dynamic arguments}){
    return navigationKey.currentState.pushNamed(_rn, arguments: arguments);
  }

  Future<dynamic> navigateToRoute(MaterialPageRoute _rn){
    return navigationKey.currentState.push(_rn);
  }

  goback(){
    return navigationKey.currentState.pop();
  }

}