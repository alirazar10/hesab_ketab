import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:intl/intl.dart';

class MyTextFieldDatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateChanged;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateFormat dateFormat;
  final FocusNode focusNode;
  final String labelText;
  final Icon prefixIcon;
  final Icon suffixIcon;
  final DateTime userDate; //fetched from database for updating purpose
  
  MyTextFieldDatePicker({
    Key key,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.dateFormat,
    this.userDate, // this used when user has defauld value may it is fetched from database
    @required this.lastDate,
    @required this.firstDate,
    @required this.initialDate,
    @required this.onDateChanged,
  })  : assert(initialDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(!initialDate.isBefore(firstDate),
            'initialDate must be on or after firstDate'),
        assert(!initialDate.isAfter(lastDate),
            'initialDate must be on or before lastDate'),
        assert(!firstDate.isAfter(lastDate),
            'lastDate must be on or after firstDate'),
        assert(onDateChanged != null, 'onDateChanged must not be null'),
        super(key: key);

  @override
  _MyTextFieldDatePicker createState() => _MyTextFieldDatePicker();
}

class _MyTextFieldDatePicker extends State<MyTextFieldDatePicker> {
  TextEditingController _controllerDate;
  DateFormat _dateFormat;
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.dateFormat != null) {
      _dateFormat = widget.dateFormat;
    } else {
      _dateFormat = DateFormat('y-d-M');
    }
      
    _selectedDate = widget.userDate != null ? widget.userDate : widget.initialDate;

    _controllerDate = TextEditingController();
    _controllerDate.text = _dateFormat.format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      
      focusNode: widget.focusNode,
      controller: _controllerDate,
      decoration : myInputDecoration(),
      onTap: () => _selectDate(context),
      readOnly: true,
    );
  }

  @override
  void dispose() {
    _controllerDate.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectedDate = pickedDate;
      _controllerDate.text = _dateFormat.format(_selectedDate);
      widget.onDateChanged(_selectedDate);
    }

    if (widget.focusNode != null) {
      widget.focusNode.nextFocus();
    }
  }



  myInputDecoration(){
  return InputDecoration(
    
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff00BCD4),width: 1.0),
      borderRadius: BorderRadius.circular(8.0)
    ),
    // disabledBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Color(0x4200BBD4),width: 1.0),
    //   borderRadius: BorderRadius.circular(8.0)
    // ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff00BCD4), width: 2.0),
      borderRadius: BorderRadius.circular(8.0)
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[700], width: 2.0),
      borderRadius: BorderRadius.circular(8.0)
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[700], width: 2.0),
      borderRadius: BorderRadius.circular(8.0)
    ),
    labelStyle: myTextStyle(color: Color(0x77FF5622), fontWeight: FontWeight.w600),
    contentPadding: EdgeInsets.all(8.0),
    prefixIcon: widget.prefixIcon,
    suffixIcon: widget.suffixIcon,
    labelText:  widget.labelText,
    floatingLabelBehavior: FloatingLabelBehavior.always,
  );
}
}