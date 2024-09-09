import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:hesab_ketab/utils/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddElectricityBill extends StatefulWidget {
  AddElectricityBill({Key? key}) : super(key: key);

  @override
  _AddElectricityBillState createState() => _AddElectricityBillState();
}

class _AddElectricityBillState extends State<AddElectricityBill> {
  BuildContext? _context;
  final GlobalKey<ScaffoldState> _billScaffoldStateKey =
      GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _addBillFormKey = GlobalKey<FormState>();
  final TextEditingController _payableBillController = TextEditingController();
  final TextEditingController _readingTurnBillController =
      TextEditingController();
  List _dropdownItems = [];
  String? _dropdownValue;
  DateTime? _mySelectedDateIssue;
  DateTime _mySelectedDateEnd = DateTime.now();
  int? _submeterNo;
  List _submeterInfo = [];
  List<Widget> _children = [];
  Map<String, TextEditingController> _degreeTextFieldController = {};
  late double height;
  late double width;

  Future<void> fetchMainMeters() async {
    final API_Config _apiConfig = API_Config();
    final String _apiURL = _apiConfig.apiUrl('fetchSubmeters');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final Map _userData = jsonDecode(prefs.getString('user') ?? '{}');
    final String _accessToken = prefs.getString('accessToken') ?? '';
    final Map<String, String> _headers = {
      "Accept": 'application/json',
      'Authorization': _accessToken,
    };
    final Map<String, String> data = {
      'user_id': _userData['user_id'].toString()
    };

    try {
      final response =
          await http.post(Uri.parse(_apiURL), body: data, headers: _headers);
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        List res = [];
        for (var i = 0; i < data.length; i++) {
          if (data[i]['status'] == 1) {
            if (data[i]['submeters'].length != 0) {
              res.add(data[i]);
            }
          }
        }
        setState(() {
          _dropdownItems = res;
        });
      } else if (response.statusCode == 404) {
        Map data = json.decode(response.body);
        throw ('${data['message']} \n  ${response.statusCode}');
      } else if (response.statusCode == 500) {
        throw ('Internal server error \n ${response.statusCode}');
      } else {
        throw ('Message: Unknown Error Status Code:  ${response.statusCode}');
      }
    } catch (e) {
      List data = [];
      data.add({'error': true, 'message': e.toString()});
      setState(() {
        _dropdownItems = data;
      });
    }
  }

  void _addSubmeterTextField(int? submeterNo, List submeterInfo) {
    for (int i = 0; i < submeterInfo.length; i++) {
      _degreeTextFieldController[submeterInfo[i]['id'].toString()] =
          TextEditingController();
      _children = List.from(_children)..add(SizedBox(height: height * 0.015));
      _children = List.from(_children)
        ..add(TextFormField(
          controller:
              _degreeTextFieldController[submeterInfo[i]['id'].toString()],
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          decoration: myInputDecoration(
              labelText: 'درجه حالیه: ${submeterInfo[i]['submeter_consumer']}'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${submeterInfo[i]['submeter_consumer']} را وارد نمایید.';
            }
            return null;
          },
        ));

      setState(() => i);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMainMeters();
  }

  @override
  void dispose() {
    _payableBillController.dispose();
    _readingTurnBillController.dispose();
    _degreeTextFieldController.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _billScaffoldStateKey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('ثبت بل برق'),
        centerTitle: true,
      ),
      body: Material(
        child: Container(
          height: height,
          padding: EdgeInsets.only(
            left: width * 0.015,
            right: width * 0.015,
            top: height * 0.015,
            bottom: MediaQuery.of(context).viewInsets.bottom + height * 0.015,
          ),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _addBillFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: _dropdownItems.isEmpty
                      ? [
                          Container(
                              alignment: Alignment.center,
                              height: height - 100,
                              child: CircularProgressIndicator())
                        ]
                      : _dropdownItems[0]['error'] != null &&
                              _dropdownItems[0]['error'] == true
                          ? [
                              showExceptionMsg(
                                  context: _context!,
                                  message: _dropdownItems[0]['message'])
                            ]
                          : [
                              Container(
                                  child: DropdownButtonFormField<String>(
                                decoration: myInputDecoration(
                                    labelText: 'انتخاب میتر عمومی'),
                                style: myTextStyle(
                                    fontSize: 16.0, color: Colors.black),
                                value: _dropdownValue,
                                items: _dropdownItems
                                    .map<DropdownMenuItem<String>>((list) {
                                  return DropdownMenuItem<String>(
                                    child: Text(list['meter_no'] +
                                        ' -- ' +
                                        list['consumer_name']),
                                    value: list['id'].toString(),
                                    onTap: () {
                                      _submeterNo = list['no_of_submeters'];
                                      _submeterInfo = list['submeters'];
                                    },
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    if (_children.isNotEmpty) {
                                      _children.clear();
                                    }
                                    _addSubmeterTextField(
                                        _submeterNo, _submeterInfo);
                                    _dropdownValue = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'میتر عمومی را انتخاب نمایید.';
                                  }
                                  return null;
                                },
                              )),
                              SizedBox(height: height * 0.015),
                              Container(
                                  child: TextFormField(
                                controller: _payableBillController,
                                decoration: myInputDecoration(
                                    labelText: 'مقدار پول پرداختی'),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                                style: myTextStyle(color: Color(0xFF212121)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'مقدار پول پرداختی را وارد نمایید.';
                                  }
                                  return null;
                                },
                              )),
                              SizedBox(height: height * 0.015),
                              Container(
                                  child: TextFormField(
                                controller: _readingTurnBillController,
                                decoration:
                                    myInputDecoration(labelText: 'دوره و سال'),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                                style: myTextStyle(color: Color(0xFF212121)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'دوره و سال را وارد نمایید.';
                                  }
                                  return null;
                                },
                              )),
                              SizedBox(height: height * 0.012),
                              MyTextFieldDatePicker(
                                labelText: "تاریخ صدور",
                                prefixIcon: Icon(Icons.date_range),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                lastDate:
                                    DateTime.now().add(Duration(days: 366)),
                                firstDate: DateTime.now()
                                    .subtract(Duration(days: 366)),
                                initialDate:
                                    DateTime.now().add(Duration(days: 1)),
                                onDateChanged: (selectedDate) {
                                  _mySelectedDateIssue = selectedDate;
                                },
                              ),
                              SizedBox(height: height * 0.012),
                              MyTextFieldDatePicker(
                                labelText: "تاریخ مهلت",
                                prefixIcon: Icon(Icons.date_range),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                lastDate:
                                    DateTime.now().add(Duration(days: 366)),
                                firstDate: DateTime.now()
                                    .subtract(Duration(days: 366)),
                                initialDate:
                                    DateTime.now().add(Duration(days: 1)),
                                onDateChanged: (selectedDate) {
                                  _mySelectedDateEnd = selectedDate;
                                },
                              ),
                              SizedBox(height: height * 0.012),
                            ].followedBy(_children).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_addBillFormKey.currentState!.validate()) {
            if (_mySelectedDateIssue == null) {
              showExceptionMsg(
                  context: context, message: 'تاریخ صدور را انتخاب نمایید.');
              return;
            }
            if (_mySelectedDateEnd.isBefore(_mySelectedDateIssue!)) {
              showExceptionMsg(
                  context: context,
                  message: 'تاریخ مهلت نمی تواند قبل از تاریخ صدور باشد.');
              return;
            }
            if (_children.isEmpty) {
              showExceptionMsg(
                  context: context,
                  message: 'لطفا درجه مصرفی هر میتر را وارد نمایید.');
              return;
            }
            for (var i = 0; i < _degreeTextFieldController.length; i++) {
              if (_degreeTextFieldController[_submeterInfo[i]['id'].toString()]!
                  .text
                  .isEmpty) {
                showExceptionMsg(
                    context: context,
                    message:
                        'لطفا درجه مصرفی میتر ${_submeterInfo[i]['submeter_consumer']} را وارد نمایید.');
                return;
              }
            }
            Map<String, dynamic> billData = {
              'submeter_info': _submeterInfo,
              'payableBill': _payableBillController.text,
              'readingTurnBill': _readingTurnBillController.text,
              'dropdownValue': _dropdownValue,
              'issuedDate': _mySelectedDateIssue.toString(),
              'endDate': _mySelectedDateEnd.toString(),
            };
            _submitBillData(billData);
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }

  void _submitBillData(Map<String, dynamic> billData) async {
    final API_Config _apiConfig = API_Config();
    final String _apiURL = _apiConfig.apiUrl('addElectricityBill');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String _accessToken = prefs.getString('accessToken') ?? '';
    final Map<String, String> _headers = {
      "Accept": 'application/json',
      'Authorization': _accessToken,
    };

    try {
      final response = await http.post(Uri.parse(_apiURL),
          body: json.encode(billData), headers: _headers);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('بیل برق موفقانه ثبت گردید.')));
        Navigator.pop(context);
      } else {
        throw Exception('Failed to submit bill data');
      }
    } catch (e) {
      showExceptionMsg(context: context, message: e.toString());
    }
  }
}
