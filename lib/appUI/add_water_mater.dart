import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';

class AddWaterMeter extends StatefulWidget {
  @override
  _AddWaterMeterState createState() => _AddWaterMeterState();
}

class _AddWaterMeterState extends State<AddWaterMeter> {
  late double height;
  late double width;
  final GlobalKey<ScaffoldState> _addWaterScaffoldStateKey =
      GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _addWaterFromKey = GlobalKey<FormState>();

  late TextEditingController _consumerNameController;
  late TextEditingController _subscriptionNoController;
  late TextEditingController _meterDegreeController;
  late TextEditingController _costPermeterController;

  DateTime? _mySelectedDate;

  @override
  void initState() {
    super.initState();
    _consumerNameController = TextEditingController();
    _subscriptionNoController = TextEditingController();
    _meterDegreeController = TextEditingController();
    _costPermeterController = TextEditingController();
  }

  @override
  void dispose() {
    _consumerNameController.dispose();
    _subscriptionNoController.dispose();
    _meterDegreeController.dispose();
    _costPermeterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _addWaterScaffoldStateKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xC2212121),
        title: Text('ثبت میترآب'),
      ),
      body: Material(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              left: height * 0.015,
              top: height * 0.015,
              right: height * 0.015,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _addWaterFromKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      controller: _consumerNameController,
                      labelText: 'اسم مشترک',
                      helperText: 'اسم مشترک در بل',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'اسم مشترک را وارد نمایید.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    _buildTextField(
                      controller: _subscriptionNoController,
                      labelText: 'شماره ثبت بل',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'شماره ثبت بل را وارد نمایید.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    _buildTextField(
                      controller: _meterDegreeController,
                      labelText: 'درجه میتر',
                      helperText: 'اخرین درجه حالیه در بل',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'درجه بل را وارد نمایید';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    _buildTextField(
                      controller: _costPermeterController,
                      labelText: 'قیمت فی متر آب',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'قیمت فی متر آب را وارد نمایید.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    _buildDatePicker(),
                    SizedBox(height: 15.0),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? helperText,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return Container(
      child: TextFormField(
        controller: controller,
        decoration: myInputDecoration(
          labelText: labelText,
          helperText: helperText,
        ),
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        style: myTextStyle(color: Color(0xFF212121)),
        validator: validator,
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      child: MyTextFieldDatePicker(
        labelText: "تاریخ",
        prefixIcon: Icon(Icons.date_range),
        suffixIcon: Icon(Icons.arrow_drop_down),
        lastDate: DateTime.now().add(Duration(days: 366)),
        firstDate: DateTime.now().subtract(Duration(days: 366)),
        initialDate: DateTime.now().add(Duration(days: 1)),
        onDateChanged: (selectedDate) {
          setState(() {
            _mySelectedDate = selectedDate;
          });
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFF5722),
        ),
        child: Text('ثبت میتر', style: myTextStyle(color: Colors.white)),
        onPressed: () async {
          if (_addWaterFromKey.currentState!.validate()) {
            _addWaterFromKey.currentState!.save();
            Map<String, dynamic> _dataToSend = {
              'consumer_name': _consumerNameController.text,
              'subscription_no': _subscriptionNoController.text,
              'meter_degree': _meterDegreeController.text,
              'cost_perdegree': _costPermeterController.text,
              'date': _mySelectedDate != null
                  ? _mySelectedDate!.toString()
                  : DateFormat('y-M-d').format(DateTime.now()).toString(),
            };
            print(_costPermeterController.text);
            await addWaterMeter(
                context, _addWaterScaffoldStateKey, _dataToSend);
          }
        },
      ),
    );
  }
}
