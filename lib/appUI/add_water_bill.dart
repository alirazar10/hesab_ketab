import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';

class AddWaterBill extends StatefulWidget {
  AddWaterBill({Key? key}) : super(key: key);

  @override
  _AddWaterBillState createState() => _AddWaterBillState();
}

class _AddWaterBillState extends State<AddWaterBill> {
  BuildContext? _context;
  final GlobalKey<ScaffoldState> _waterBillScaffoldKey =
      GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _addWaterBillFormKey = GlobalKey<FormState>();
  double? height;
  double? width;
  double? bottomInset;

  List<Map<String, dynamic>> _dropdownItems = [];
  String? _dropdownValue;
  List<Map<String, dynamic>> _neighborInfo = [];
  List<Widget> _children = [];
  Map<String, TextEditingController> _peopleTextFieldController = {};

  final TextEditingController _billAmountTEController = TextEditingController();
  final TextEditingController _readingTurnTEController =
      TextEditingController();
  final TextEditingController _meterDegreeTEController =
      TextEditingController();
  final TextEditingController _consumedDegreeTEController =
      TextEditingController();
  final TextEditingController _costPerMeterTEController =
      TextEditingController();

  DateTime? _mySelectedIssueDate;
  DateTime? _mySelectedDueDate;
  double? _costPerMeter;

  @override
  void initState() {
    super.initState();
    fetchWaterNeighbor().then((val) {
      setState(() {
        _dropdownItems = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    bottomInset = MediaQuery.of(context).viewInsets.bottom;

    var _padding = EdgeInsets.only(
      left: height! * 0.012,
      top: height! * 0.012,
      right: height! * 0.012,
      bottom: bottomInset!,
    );

    return Scaffold(
      key: _waterBillScaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xC2212121),
        centerTitle: true,
        title: Text('ثبت بل آب'),
      ),
      body: Container(
        height: height,
        padding: _padding,
        child: SingleChildScrollView(
          child: Form(
            key: _addWaterBillFormKey,
            child: Column(
              children: _dropdownItems.isEmpty
                  ? [
                      Container(
                        alignment: Alignment.center,
                        height: height! - 100,
                        child: CircularProgressIndicator(),
                      )
                    ]
                  : _dropdownItems[0]['error'] != null &&
                          _dropdownItems[0]['error'] == true
                      ? [
                          showExceptionMsg(
                              context: _context!,
                              message: _dropdownItems[0]['message']),
                        ]
                      : [
                          DropdownButtonFormField<String>(
                            decoration:
                                myInputDecoration(labelText: 'انتخاب میتر'),
                            style: myTextStyle(color: Color(0xFF212121)),
                            items: _dropdownItems.map((list) {
                              return DropdownMenuItem<String>(
                                child: Text('${list['consumer_name']}'),
                                value: list['id'].toString(),
                                onTap: () {
                                  _neighborInfo =
                                      List<Map<String, dynamic>>.from(
                                          list['waterneighbors']);
                                  _costPerMeter = list['cost_perdegree'] != null
                                      ? double.tryParse(
                                          list['cost_perdegree'].toString())
                                      : null;
                                },
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (_children.isNotEmpty) {
                                _children
                                    .clear(); // to create new textfields clear list items
                              }
                              _createNeighborTextField(_neighborInfo);
                              _dropdownValue = value;
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return ' میتر را انتخاب نمایید.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: height! * 0.012),
                          TextFormField(
                            controller: _readingTurnTEController,
                            decoration: myInputDecoration(labelText: 'دوره'),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                            style: myTextStyle(color: Color(0xFF212121)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'دوره را وارد نمایید.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: height! * 0.012),
                          TextFormField(
                            controller: _meterDegreeTEController,
                            decoration:
                                myInputDecoration(labelText: 'درجه حالیه'),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                            style: myTextStyle(color: Color(0xFF212121)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'درجه حالیه را وارد نمایید.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: height! * 0.012),
                          TextFormField(
                            controller: _consumedDegreeTEController,
                            decoration:
                                myInputDecoration(labelText: 'درجه مصرف شده'),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                            style: myTextStyle(color: Color(0xFF212121)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'درجه مصرف شده را وارد نمایید.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: height! * 0.012),
                          TextFormField(
                            controller: _costPerMeterTEController
                              ..text = _costPerMeter != null
                                  ? _costPerMeter.toString()
                                  : '',
                            decoration:
                                myInputDecoration(labelText: 'قیمت فی متر آب'),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                            style: myTextStyle(color: Color(0xFF212121)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'مبلغ تادیه را وارد نمایید.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: height! * 0.012),
                          MyTextFieldDatePicker(
                            labelText: "تاریخ صدور",
                            prefixIcon: Icon(Icons.date_range),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                            lastDate: DateTime.now().add(Duration(days: 366)),
                            firstDate:
                                DateTime.now().subtract(Duration(days: 366)),
                            initialDate: DateTime.now().add(Duration(days: 1)),
                            onDateChanged: (selectedDate) {
                              _mySelectedIssueDate = selectedDate;
                            },
                          ),
                          SizedBox(height: height! * 0.012),
                          MyTextFieldDatePicker(
                            labelText: "تاریخ مهلت",
                            prefixIcon: Icon(Icons.date_range),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                            lastDate: DateTime.now().add(Duration(days: 366)),
                            firstDate:
                                DateTime.now().subtract(Duration(days: 366)),
                            initialDate: DateTime.now().add(Duration(days: 1)),
                            onDateChanged: (selectedDate) {
                              _mySelectedDueDate = selectedDate;
                            },
                          ),
                          SizedBox(height: height! * 0.012),
                          Column(
                            children: _children,
                          ),
                          SizedBox(height: height! * 0.022),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Color(0xFFFF5722)),
                            ),
                            child: Text('ثبت و محاسبه'),
                            onPressed: () async {
                              if (_addWaterBillFormKey.currentState!
                                  .validate()) {
                                _addWaterBillFormKey.currentState!.save();
                                Map<String, dynamic> dataToSend = {
                                  'water_id': _dropdownValue,
                                  'meter_reading_turn':
                                      _readingTurnTEController.text,
                                  'current_degree':
                                      _meterDegreeTEController.text,
                                  'consumed_degree':
                                      _consumedDegreeTEController.text,
                                  'cost_permeter':
                                      _costPerMeterTEController.text,
                                  'issue_date': _mySelectedIssueDate != null
                                      ? _mySelectedIssueDate!.toString()
                                      : DateFormat('y-M-d')
                                          .format(DateTime.now())
                                          .toString(),
                                  'due_date': _mySelectedDueDate != null
                                      ? _mySelectedDueDate!.toString()
                                      : DateFormat('y-M-d')
                                          .format(DateTime.now())
                                          .toString(),
                                };
                                await addWaterBill(
                                    context,
                                    _waterBillScaffoldKey,
                                    _peopleTextFieldController,
                                    dataToSend);
                              }
                            },
                          )
                        ],
            ),
          ),
        ),
      ),
    );
  }

  void _createNeighborTextField(List<Map<String, dynamic>> neighbor) {
    for (var info in neighbor) {
      _peopleTextFieldController[info['neighbors_name']] =
          TextEditingController();
      _children.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${info['neighbors_name']} (تعداد نفرات)'),
            SizedBox(height: height! * 0.012),
            TextFormField(
              controller: _peopleTextFieldController[info['neighbors_name']],
              decoration: myInputDecoration(labelText: 'تعداد نفرات'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              style: myTextStyle(color: Color(0xFF212121)),
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
            SizedBox(height: height! * 0.012),
          ],
        ),
      );
    }
  }
}
