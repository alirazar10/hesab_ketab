import 'package:flutter/material.dart';

class Electricity extends StatefulWidget {
  Electricity({Key key}) : super(key: key);

  @override
  _ElectricityState createState() => _ElectricityState();
}

class _ElectricityState extends State<Electricity> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
       child: Text('Electricity'),
    );
  }
}