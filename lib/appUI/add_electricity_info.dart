import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:hesab_ketab/utils/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddMainMeter extends StatefulWidget {
  const AddMainMeter({Key? key}) : super(key: key);

  @override
  _AddMainMeterState createState() => _AddMainMeterState();
}

class _AddMainMeterState extends State<AddMainMeter> {
  final GlobalKey<FormState> _addMainMeterFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _addMainMeterScaffoldStateKey =
      GlobalKey<ScaffoldState>();
  late BuildContext _context;
  final API_Config _apiConfig = API_Config();
  final TextEditingController _consumerNameTextEditController =
      TextEditingController();
  final TextEditingController _consumerIDTextEditController =
      TextEditingController();
  final TextEditingController _meterIDTextEditController =
      TextEditingController();
  final TextEditingController _submeterNoTextEditController =
      TextEditingController();
  DateTime? _mySelectedDate;

  String? _apiUrl;
  String? _accessToken;
  Map<String, dynamic> _mainMeterData = {};
  Map<String, String>? _header;

  Future<void> addMainMeter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _apiUrl = _apiConfig.apiUrl('addMainMeter');
    String? _userData = prefs.getString('user');

    _mainMeterData = {
      'consumer_name': _consumerNameTextEditController.text,
      'subscription_no': _consumerIDTextEditController.text,
      'meter_no': _meterIDTextEditController.text,
      'no_of_submeters': _submeterNoTextEditController.text,
      'date': _mySelectedDate?.toString(),
      'user': _userData,
    };

    _accessToken = prefs.getString('accessToken');
    _header = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": 'application/json',
      'Authorization': _accessToken ?? '',
    };

    try {
      final response = await http.post(
        Uri.parse(_apiUrl!),
        body: _mainMeterData,
        headers: _header,
      );
      if (response.statusCode == 201) {
        Map<String, dynamic> data = json.decode(response.body);
        createSnackBar(
            data['message'], _context, _addMainMeterScaffoldStateKey);
      } else {
        Map<String, dynamic> data = json.decode(response.body);
        throw Exception(
            'Message: ${data['message']} With Status Code: ${response.statusCode}');
      }
    } catch (e) {
      createSnackBar('$e', context, _addMainMeterScaffoldStateKey,
          color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _addMainMeterScaffoldStateKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('ثبت میترهای عمومی', style: myTextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        height: height,
        padding: EdgeInsets.only(
          left: width * 0.015,
          right: width * 0.015,
          top: height * 0.015,
          bottom: MediaQuery.of(context).viewInsets.bottom + height * 0.015,
        ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _addMainMeterFormKey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: height * 0.015),
                        child: TextFormField(
                          controller: _consumerNameTextEditController,
                          style: myTextStyle(color: const Color(0xFF212121)),
                          decoration: myInputDecoration(labelText: 'اسم مشترک'),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'اسم مشترک را وارد نمایید.';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.015),
                      Container(
                        child: TextFormField(
                          controller: _consumerIDTextEditController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          style: myTextStyle(color: const Color(0xFF212121)),
                          decoration:
                              myInputDecoration(labelText: 'نمبر اشتراک'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'نمبر اشتراک را وارد نمایید.';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.015),
                      Container(
                        child: TextFormField(
                          controller: _meterIDTextEditController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          style: myTextStyle(color: const Color(0xFF212121)),
                          decoration: myInputDecoration(labelText: 'نمبر میتر'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'نمبر میتر را وارد نمایید.';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.012),
                      Container(
                        padding: const EdgeInsets.only(),
                        child: TextFormField(
                          controller: _submeterNoTextEditController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          style: myTextStyle(color: const Color(0xFF212121)),
                          decoration: myInputDecoration(
                              labelText: 'تعداد میترهای فرعی'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'تعداد میترهای فرعی را وارد نمایید.';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.012),
                      MyTextFieldDatePicker(
                        labelText: "تاریخ ثبت",
                        prefixIcon: const Icon(Icons.date_range),
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                        lastDate: DateTime.now().add(const Duration(days: 366)),
                        firstDate: DateTime.now(),
                        initialDate:
                            DateTime.now().add(const Duration(days: 1)),
                        onDateChanged: (selectedDate) {
                          _mySelectedDate = selectedDate;
                        },
                      ),
                      SizedBox(height: height * 0.012),
                      Container(
                        width: width,
                        padding: EdgeInsets.only(top: height * 0.015),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color(0xFFFF5722)),
                          ),
                          child: Text('ثبت میتر',
                              style: myTextStyle(color: Colors.white)),
                          onPressed: () {
                            if (_addMainMeterFormKey.currentState!.validate()) {
                              _addMainMeterFormKey.currentState!.save();
                              addMainMeter();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
