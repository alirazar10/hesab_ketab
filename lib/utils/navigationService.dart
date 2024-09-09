import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  static final NavigationService instance = NavigationService._internal();

  NavigationService._internal();

  Future<dynamic> navigateToRemoveUntil(String routeName, {dynamic arguments}) {
    return navigationKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigationKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> navigateToRoute(MaterialPageRoute route) {
    return navigationKey.currentState!.push(route);
  }

  void goBack() {
    return navigationKey.currentState!.pop();
  }
}
