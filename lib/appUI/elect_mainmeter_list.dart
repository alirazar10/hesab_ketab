import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:hesab_ketab/utils/api_config.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainMeterList extends StatefulWidget {
  MainMeterList({Key? key}) : super(key: key);

  @override
  _MainMeterListState createState() => _MainMeterListState();
}

class _MainMeterListState extends State<MainMeterList> {
  Future<List<dynamic>>? futureMainmeter;
  final GlobalKey<FormState> _editMainMeterFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _mainMeterListScaffoldStateKey =
      GlobalKey<ScaffoldState>();
  late BuildContext _context;
  final _apiConfig = API_Config();
  final _consumerNameTextEditController = TextEditingController();
  final _consumerIDTextEditController = TextEditingController();
  final _meterIDTextEditController = TextEditingController();
  final _submeterNoTextEditController = TextEditingController();
  DateTime? _mySelectedDate;

  String? _apiUrl;
  String? _accessToken;
  String? _userData;
  Map<String, dynamic> _mainMeterData = {};
  Map<String, String>? _header;

  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
    futureMainmeter = fetchMainMeters();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _mainMeterListScaffoldStateKey,
      appBar: AppBar(
        title: Text('لیست میترهای عمومی'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: height * .01),
        child: FutureBuilder<List<dynamic>>(
          future: futureMainmeter,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return _buildNoDataWidget();
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  var data = snapshot.data![index];
                  if (data['error'] != null && data['error'] == true) {
                    return showExceptionMsg(
                        context: _context, message: data['message']);
                  }
                  var status = data['status'];
                  return _buildListItem(data, status);
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildNoDataWidget() {
    return Container(
      padding: EdgeInsets.all(height * 0.03),
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: boxShadow(),
        color: Color(0xFFE9EAEB),
      ),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.exclamationTriangle, color: Color(0xFFFF5622)),
          SizedBox(width: 10.0),
          Text('میتری ثبت نشده.',
              style: myTextStyle(
                  color: Color(0xff00BCD4),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildListItem(Map<String, dynamic> data, int status) {
    return Material(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(height * 0.012),
            decoration: BoxDecoration(
              color: Color(0xFFF0F0F0),
              boxShadow: boxShadow(),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: width / 1.4,
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Text('${data['consumer_name']}',
                                  style: myTextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 10.0),
                              if (status == 1)
                                Icon(FontAwesomeIcons.check,
                                    color: Color(0xff00BCD4), size: 16),
                            ],
                          ),
                          _buildDetailRow(
                              'نمبر اشتراک:', data['subscription_no']),
                          _buildDetailRow('نمبر میتر:', data['meter_no']),
                          _buildDetailRow('تعداد میتر های فرعی:',
                              '${data['no_of_submeters']}'),
                        ],
                      ),
                    ),
                    Container(
                      height: 100.0,
                      child: VerticalDivider(thickness: 2.0, indent: 30.0),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: height * .02, right: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(FontAwesomeIcons.edit),
                            color: Color(0xff00BCD4),
                            iconSize: 18.0,
                            onPressed: () {
                              myEditAlertBox(
                                context: _context,
                                consumerName: data['consumer_name'],
                                subscNo: data['subscription_no'],
                                meterNo: data['meter_no'],
                                noOfMeter: data['no_of_submeters'],
                                meterID: data['id'],
                                date: data['date'],
                              );
                            },
                          ),
                          IconButton(
                            color: Colors.red,
                            icon: Icon(FontAwesomeIcons.times, size: 18.0),
                            onPressed: () {
                              myDelete(context: _context, meterID: data['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.012),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text('وضعیت میتر: ',
                                style: myTextStyle(
                                    color: Colors.grey[600], fontSize: 12.0)),
                            Text(status == 1 ? 'فعال' : 'غیر فعال',
                                style: myTextStyle(
                                    color: status == 1
                                        ? Color(0x9100BBD4)
                                        : Color(0x91FF5622))),
                          ],
                        ),
                        Text('تاریخ ثبت: ${data['date']}',
                            style: myTextStyle(
                                color: Colors.grey[600], fontSize: 12.0)),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {
                        var st = status == 1 ? 0 : 1;
                        setState(() {
                          changeMainMeterStatus(_context,
                              _mainMeterListScaffoldStateKey, data['id'], st);
                          futureMainmeter = fetchMainMeters();
                        });
                      },
                      child: Text('تغیر وضعیت',
                          style: myTextStyle(
                              color: Color(0xff00BCD4), fontSize: 12.0)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(thickness: 3.0),
          SizedBox(height: height * 0.012),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: myTextStyle(fontSize: 14.0)),
        Text(value),
      ],
    );
  }

  Future<void> editMainMeter(int meterID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _apiUrl = _apiConfig.apiUrl('editMainMeter');
    String? userData = prefs.getString('user');
    _mainMeterData = {
      'consumer_name': _consumerNameTextEditController.text,
      'subscription_no': _consumerIDTextEditController.text,
      'meter_no': _meterIDTextEditController.text,
      'no_of_submeters': _submeterNoTextEditController.text,
      'date': _mySelectedDate?.toIso8601String(),
    };
    _accessToken = userData != null ? json.decode(userData)['accessToken'] : '';

    _header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };

    var response = await http.put(
      Uri.parse("$_apiUrl/$meterID"),
      headers: _header,
      body: jsonEncode(_mainMeterData),
    );

    if (response.statusCode == 200) {
      if (json.decode(response.body)['success'] == true) {
        Navigator.pop(_context);
        showSnackBar(
            context: _context,
            message: 'موفقانه تغییر کرد',
            color: Colors.green);
        setState(() {
          futureMainmeter = fetchMainMeters();
        });
      } else {
        showSnackBar(
            context: _context, message: 'خطا در ویرایش', color: Colors.red);
      }
    } else {
      showSnackBar(
          context: _context, message: 'خطا در ویرایش', color: Colors.red);
    }
  }

  Future<void> deleteMainMeter(int meterID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _apiUrl = _apiConfig.apiUrl('deleteMainMeter');
    String? userData = prefs.getString('user');
    _accessToken = userData != null ? json.decode(userData)['accessToken'] : '';

    _header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };

    var response = await http.delete(
      Uri.parse("$_apiUrl/$meterID"),
      headers: _header,
    );

    if (response.statusCode == 200) {
      if (json.decode(response.body)['success'] == true) {
        showSnackBar(
            context: _context, message: 'موفقانه حذف شد', color: Colors.green);
        setState(() {
          futureMainmeter = fetchMainMeters();
        });
      } else {
        showSnackBar(
            context: _context, message: 'خطا در حذف', color: Colors.red);
      }
    } else {
      showSnackBar(context: _context, message: 'خطا در حذف', color: Colors.red);
    }
  }

  Future<List<dynamic>> fetchMainMeters() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _apiUrl = _apiConfig.apiUrl('fetchMainMeters');
    String? userData = prefs.getString('user');
    _accessToken = userData != null ? json.decode(userData)['accessToken'] : '';

    _header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };

    var response = await http.get(
      Uri.parse(_apiUrl!),
      headers: _header,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load main meters');
    }
  }

  Future<void> myEditAlertBox({
    required BuildContext context,
    required String consumerName,
    required String subscNo,
    required String meterNo,
    required String noOfMeter,
    required int meterID,
    required String date,
  }) {
    _consumerNameTextEditController.text = consumerName;
    _consumerIDTextEditController.text = subscNo;
    _meterIDTextEditController.text = meterNo;
    _submeterNoTextEditController.text = noOfMeter;
    _mySelectedDate = DateTime.parse(date);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ویرایش میتر عمومی'),
          content: SingleChildScrollView(
            child: Form(
              key: _editMainMeterFormKey,
              child: Column(
                children: [
                  _buildTextField(
                      'نام مصرف کننده', _consumerNameTextEditController),
                  _buildTextField('نمبر اشتراک', _consumerIDTextEditController),
                  _buildTextField('نمبر میتر', _meterIDTextEditController),
                  _buildTextField(
                      'تعداد میتر های فرعی', _submeterNoTextEditController),
                  MyTextFieldDatePicker(
                    labelText: "تاریخ ثبت",
                    prefixIcon: Icon(Icons.date_range),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    lastDate: DateTime.now().add(Duration(days: 366)),
                    firstDate: DateTime.now().subtract(Duration(days: 366)),
                    initialDate: DateTime.now().add(Duration(days: 1)),
                    userDate: DateTime.parse(date),
                    onDateChanged: (selectedDate) {
                      // Do something with the selected date
                      _mySelectedDate = selectedDate;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('بستن'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_editMainMeterFormKey.currentState?.validate() ?? false) {
                  editMainMeter(meterID);
                }
              },
              child: Text('ذخیره'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'لطفا این فیلد را پر کنید';
          }
          return null;
        },
      ),
    );
  }

  Future<void> myDelete({required BuildContext context, required int meterID}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('حذف میتر'),
          content: Text('آیا مطمئن هستید که می‌خواهید این میتر را حذف کنید؟'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('بستن'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteMainMeter(meterID);
                Navigator.of(context).pop();
              },
              child: Text('حذف'),
            ),
          ],
        );
      },
    );
  }

  void showSnackBar(
      {required BuildContext context,
      required String message,
      required Color color}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
