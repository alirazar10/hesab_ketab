import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';

class AddWaterNeibors extends StatefulWidget {
  AddWaterNeibors({Key? key}) : super(key: key);

  @override
  _AddWaterNeiborsState createState() => _AddWaterNeiborsState();
}

class _AddWaterNeiborsState extends State<AddWaterNeibors> {
  late double height;
  late double width;
  late double _bottomInset;
  DateTime? _mySelectedDate;
  List _dropdownItems = [];
  String? _dropdownValue;
  late BuildContext _context;
  final GlobalKey<ScaffoldState> _neighnorScaffoldKey =
      GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _neighnorFormKey = GlobalKey<FormState>();
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _peopleTextEditingController =
      TextEditingController();
  final TextEditingController _degreeTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWaterMeter().then((val) {
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
    _bottomInset = MediaQuery.of(context).viewInsets.bottom;
    var _padding = EdgeInsets.only(
      left: height * .012,
      top: height * .012,
      right: height * .012,
      bottom: _bottomInset,
    );

    return Scaffold(
      key: _neighnorScaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xC2212121),
        centerTitle: true,
        title: const Text('اضافه کردن همسایه‌ها'),
      ),
      body: Container(
        padding: _padding,
        child: Form(
          key: _neighnorFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _dropdownItems.isEmpty
                  ? [const Center(child: CircularProgressIndicator())]
                  : _dropdownItems[0]['error'] != null &&
                          _dropdownItems[0]['error'] == true
                      ? [
                          showExceptionMsg(
                              context: _context,
                              message: _dropdownItems[0]['message'])
                        ]
                      : [
                          DropdownButtonFormField<String>(
                            decoration:
                                myInputDecoration(labelText: 'انتخاب میتر'),
                            style: myTextStyle(color: const Color(0xFF212121)),
                            items: _dropdownItems
                                .map<DropdownMenuItem<String>>((list) {
                              return DropdownMenuItem<String>(
                                child: Text('${list['consumer_name']}'),
                                value: list['id'].toString(),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _dropdownValue = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' میتر را انتخاب نمایید.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: height * .012),
                          TextFormField(
                            controller: _nameTextEditingController,
                            decoration:
                                myInputDecoration(labelText: 'نام گذاری'),
                            style: myTextStyle(color: const Color(0xFF212121)),
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' نام را وارد نمایید.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: height * .012),
                          TextFormField(
                            controller: _peopleTextEditingController,
                            decoration:
                                myInputDecoration(labelText: ' تعداد افراد'),
                            style: myTextStyle(color: const Color(0xFF212121)),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' تعداد افراد را وارد نمایید.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: height * .012),
                          TextFormField(
                            controller: _degreeTextEditingController,
                            decoration:
                                myInputDecoration(labelText: ' درجه میتر'),
                            style: myTextStyle(color: const Color(0xFF212121)),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' درجه میتر را وارد نمایید.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: height * .012),
                          Container(
                            child: MyTextFieldDatePicker(
                              labelText: "تاریخ",
                              prefixIcon: const Icon(Icons.date_range),
                              suffixIcon: const Icon(Icons.arrow_drop_down),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 366)),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 366)),
                              initialDate:
                                  DateTime.now().add(const Duration(days: 1)),
                              onDateChanged: (selectedDate) {
                                _mySelectedDate = selectedDate;
                              },
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Container(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF5722),
                              ),
                              child: Text('ثبت',
                                  style: myTextStyle(color: Colors.white)),
                              onPressed: () {
                                if (_neighnorFormKey.currentState!.validate()) {
                                  Map<String, dynamic> dataToSend = {
                                    'water_id': _dropdownValue,
                                    'neighbors_name':
                                        _nameTextEditingController.text,
                                    'people': _peopleTextEditingController.text,
                                    'meter_degree':
                                        _degreeTextEditingController.text,
                                    'date': _mySelectedDate != null
                                        ? _mySelectedDate!.toString()
                                        : DateFormat('y-M-d')
                                            .format(DateTime.now())
                                            .toString(),
                                  };
                                  addWaterNeighbor(_context,
                                      _neighnorScaffoldKey, dataToSend);
                                }
                              },
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
