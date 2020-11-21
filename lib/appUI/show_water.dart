import 'package:flutter/material.dart';

class Water extends StatefulWidget {
  Water({Key key}) : super(key: key);

  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text('Water'),
    );
  }
}