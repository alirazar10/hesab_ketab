import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:hesab_ketab/utils/database_activity.dart';

class AddSubmeters extends StatefulWidget {
  AddSubmeters({Key? key}) : super(key: key);

  @override
  _AddSubmetersState createState() => _AddSubmetersState();
}

class _AddSubmetersState extends State<AddSubmeters> {
  late BuildContext _context;
  late Future<List<Map<String, dynamic>>> futureSubmeter;
  final GlobalKey<FormState> _submetersFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _submetersScaffoldKey =
      GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> _dropdownItems = [];
  String? _dropdownValue;
  DateTime? _mySelectedDate;

  final _submeterNameController = TextEditingController();
  final _degreeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMainMeters().then((val) {
      setState(() {
        _dropdownItems = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final _inputPadding = EdgeInsets.only(top: height * 0.015);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _submetersScaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('ثبت میترهای فرعی', style: myTextStyle(fontSize: 20)),
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
              children: _dropdownItems.isEmpty
                  ? [Center(child: CircularProgressIndicator())]
                  : _dropdownItems[0]['error'] != null &&
                          _dropdownItems[0]['error'] == true
                      ? [
                          showExceptionMsg(
                              context: _context,
                              message: _dropdownItems[0]['message'])
                        ]
                      : [
                          Form(
                            key: _submetersFormKey,
                            child: Column(
                              children: [
                                Container(
                                  child: DropdownButtonFormField<String>(
                                    decoration: myInputDecoration(
                                        labelText: 'انتخاب میتر عمومی'),
                                    style: myTextStyle(
                                        fontSize: 16.0, color: Colors.black),
                                    value: _dropdownValue,
                                    items: _dropdownItems.map((list) {
                                      return DropdownMenuItem<String>(
                                        child: Text(
                                            '${list['meter_no']} -- ${list['consumer_name']}'),
                                        value: list['id'].toString(),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _dropdownValue = value;
                                      });
                                    },
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return ' میتر عمومی را انتخاب نمایید.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: _inputPadding,
                                  child: TextFormField(
                                    controller: _submeterNameController,
                                    decoration: myInputDecoration(
                                        labelText: 'نام گذاری میتر'),
                                    style:
                                        myTextStyle(color: Color(0xFF212121)),
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () =>
                                        FocusScope.of(context).nextFocus(),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'نام میتر را وارد نمایید.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: _inputPadding,
                                  child: TextFormField(
                                    controller: _degreeController,
                                    decoration: myInputDecoration(
                                        labelText: 'درجه میتر'),
                                    style:
                                        myTextStyle(color: Color(0xFF212121)),
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () =>
                                        FocusScope.of(context).nextFocus(),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'درجه میتر را وارد نمایید.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: height * 0.012),
                                MyTextFieldDatePicker(
                                  labelText: "تاریخ ثبت",
                                  prefixIcon: Icon(Icons.date_range),
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 366)),
                                  firstDate: DateTime.now(),
                                  initialDate:
                                      DateTime.now().add(Duration(days: 1)),
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
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Color(0xFFFF5722)),
                                    ),
                                    child: Text('ثبت میتر فرعی',
                                        style:
                                            myTextStyle(color: Colors.white)),
                                    onPressed: () {
                                      if (_submetersFormKey.currentState!
                                          .validate()) {
                                        _submetersFormKey.currentState!.save();
                                        addSubMeters(
                                          context,
                                          _submetersScaffoldKey,
                                          meterID: _dropdownValue,
                                          submeterConsumer:
                                              _submeterNameController.text,
                                          meterDegree: _degreeController.text,
                                          date: _mySelectedDate!,
                                        );
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
