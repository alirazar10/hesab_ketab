import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:intl/intl.dart';

class MyTextFieldDatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateChanged;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateFormat? dateFormat;
  final FocusNode? focusNode;
  final String? labelText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final DateTime? userDate;

  MyTextFieldDatePicker({
    Key? key,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.dateFormat,
    this.userDate,
    required this.lastDate,
    required this.firstDate,
    required this.initialDate,
    required this.onDateChanged,
  })  : assert(!initialDate.isBefore(firstDate),
            'initialDate must be on or after firstDate'),
        assert(!initialDate.isAfter(lastDate),
            'initialDate must be on or before lastDate'),
        assert(!firstDate.isAfter(lastDate),
            'lastDate must be on or after firstDate'),
        super(key: key);

  @override
  _MyTextFieldDatePicker createState() => _MyTextFieldDatePicker();
}

class _MyTextFieldDatePicker extends State<MyTextFieldDatePicker> {
  late TextEditingController _controllerDate;
  late DateFormat _dateFormat;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _dateFormat = widget.dateFormat ?? DateFormat('y-M-d');
    _selectedDate = widget.userDate ?? widget.initialDate;

    _controllerDate = TextEditingController();
    _controllerDate.text = _dateFormat.format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      controller: _controllerDate,
      decoration: myInputDecoration(),
      onTap: () => _selectDate(context),
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'تاریخ را انتخاب نمایید.';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _controllerDate.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _controllerDate.text = _dateFormat.format(_selectedDate);
        widget.onDateChanged(_selectedDate);
      });
    }

    widget.focusNode?.nextFocus();
  }

  InputDecoration myInputDecoration() {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff00BCD4), width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff00BCD4), width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red[700]!, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red[700]!, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      labelStyle:
          myTextStyle(color: Color(0x77FF5622), fontWeight: FontWeight.w600),
      contentPadding: EdgeInsets.all(8.0),
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
      labelText: widget.labelText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }
}
