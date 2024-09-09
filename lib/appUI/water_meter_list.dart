import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';

class Watermeterlist extends StatefulWidget {
  Watermeterlist({Key? key}) : super(key: key);

  @override
  _WatermeterlistState createState() => _WatermeterlistState();
}

class _WatermeterlistState extends State<Watermeterlist> {
  BuildContext? _context;
  final GlobalKey<ScaffoldState> _waterMeterListScaffoldKey =
      GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _editWaterFromKey = GlobalKey<FormState>();
  late Future _futureWaterMeter;
  final TextEditingController _consumerNameController = TextEditingController();
  final TextEditingController _subscriptionNoController =
      TextEditingController();
  final TextEditingController _meterDegreeController = TextEditingController();
  final TextEditingController _costPermeterController = TextEditingController();
  DateTime? _mySelectedDate;

  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
    _futureWaterMeter = fetchWaterMeter();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _waterMeterListScaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xC2212121),
        title: const Text('لیست میترهای آب'),
        centerTitle: true,
      ),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.only(
            top: height * 0.012,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: FutureBuilder(
          future: _futureWaterMeter,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  if (data[index]['error'] != null &&
                      data[index]['error'] == true) {
                    return showExceptionMsg(
                        context: _context!, message: data[index]['message']);
                  }

                  var status = snapshot.data[index]['status'];

                  return Material(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            boxShadow: boxShadow(),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data[index]['consumer_name']} ',
                                style: myTextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          width: width * 0.7,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('شماره ثبت'),
                                                  Text(
                                                      '${data[index]['subscription_no']}'),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('درجه میتر'),
                                                  Text(
                                                      '${data[index]['meter_degree']}'),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('قیمت فی متر آب'),
                                                  Text(
                                                      '${data[index]['cost_perdegree']}'),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 70,
                                          child: const VerticalDivider(
                                              thickness: 2.0),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          width: width - width * 0.82,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                color: const Color(0xff00BCD4),
                                                icon: const Icon(
                                                    FontAwesomeIcons.edit),
                                                onPressed: () {
                                                  Map<String, dynamic>
                                                      dataToEdit = {
                                                    'id': data[index]['id'],
                                                    'user_id': data[index]
                                                        ['user_id'],
                                                    'consumer_name': data[index]
                                                        ['consumer_name'],
                                                    'subscription_no':
                                                        data[index]
                                                            ['subscription_no'],
                                                    'meter_degree': data[index]
                                                        ['meter_degree'],
                                                    'cost_perdegree':
                                                        data[index]
                                                            ['cost_perdegree'],
                                                    'date': DateFormat('y-M-d')
                                                        .format(DateTime.parse(
                                                            data[index]
                                                                ['date']))
                                                  };
                                                  editWaterInfo(
                                                      _context!,
                                                      _waterMeterListScaffoldKey,
                                                      dataToEdit);
                                                  print(data[index]['user_id']);
                                                },
                                              ),
                                              IconButton(
                                                color: Colors.red,
                                                icon: const Icon(
                                                    FontAwesomeIcons.times),
                                                onPressed: () {
                                                  myDelete(
                                                      context: _context!,
                                                      scaffoldKey:
                                                          _waterMeterListScaffoldKey,
                                                      meterID: data[index]
                                                          ['id']);
                                                  print('pressed');
                                                },
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text('وضعیت میتر: ',
                                                    style: myTextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12.0)),
                                                status == 1
                                                    ? Text('فعال',
                                                        style: myTextStyle(
                                                            color: Color(
                                                                0x9100BBD4)))
                                                    : Text('غیر فعال',
                                                        style: myTextStyle(
                                                            color: Color(
                                                                0x91FF5622))),
                                              ],
                                            ),
                                            Text(
                                                'تاریخ ثبت: ${DateFormat('y-M-d').format(DateTime.parse(data[index]['date']))}',
                                                style: myTextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12.0)),
                                          ],
                                        ),
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFFF5722),
                                          ),
                                          onPressed: () {
                                            var st = status == 1 ? 0 : 1;
                                            setState(() {
                                              changeWaterMeterStatus(
                                                  _context!,
                                                  _waterMeterListScaffoldKey,
                                                  data[index]['id'],
                                                  st);
                                              _futureWaterMeter =
                                                  fetchWaterMeter();
                                            });
                                          },
                                          child: Text('تغیر وضعیت',
                                              style: myTextStyle(
                                                  color: Color(0xff00BCD4),
                                                  fontSize: 12.0)),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const Divider(thickness: 2.0),
                        SizedBox(height: height * 0.012)
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  editWaterInfo(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
      Map<String, dynamic> dataToEdit) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 10.0,
          titleTextStyle: myTextStyle(
              color: Colors.grey, fontSize: 18.0, fontWeight: FontWeight.bold),
          title: const Text('ویرایش میتر اب'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _editWaterFromKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _consumerNameController
                          ..text = dataToEdit['consumer_name'],
                        decoration: myInputDecoration(
                            labelText: 'اسم مشترک',
                            helperText: 'اسم مشترک در بل'),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        style: myTextStyle(color: const Color(0xFF212121)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'اسم مشترک را وارد نمایید.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        controller: _subscriptionNoController
                          ..text = dataToEdit['subscription_no'].toString(),
                        decoration:
                            myInputDecoration(labelText: 'شماره ثبت بل'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        style: myTextStyle(color: const Color(0xFF212121)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'شماره ثبت بل را وارد نمایید.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        controller: _meterDegreeController
                          ..text = dataToEdit['meter_degree'].toString(),
                        decoration: myInputDecoration(labelText: 'درجه میتر'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        style: myTextStyle(color: const Color(0xFF212121)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'درجه میتر را وارد نمایید.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        controller: _costPermeterController
                          ..text = dataToEdit['cost_perdegree'].toString(),
                        decoration: myInputDecoration(labelText: 'قیمت فی متر'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        style: myTextStyle(color: const Color(0xFF212121)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'قیمت فی متر را وارد نمایید.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      MyTextFieldDatePicker(
                        labelText: "تاریخ",
                        prefixIcon: Icon(Icons.date_range),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        lastDate: DateTime.now().add(Duration(days: 366)),
                        firstDate: DateTime.now().subtract(Duration(days: 366)),
                        initialDate: DateTime.now().add(Duration(days: 1)),
                        userDate: DateTime.parse(dataToEdit['date']),
                        onDateChanged: (selectedDate) {
                          // Do something with the selected date
                          _mySelectedDate = selectedDate;
                          print(_mySelectedDate);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: Text('لغو', style: myTextStyle(color: Color(0xFFFF5622))),
              onPressed: () => Navigator.of(context).pop(),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                // primary: Colors.white,
                backgroundColor: const Color(0xFF00BCD4),
              ),
              child: Text('تایید', style: myTextStyle(color: Colors.white)),
              onPressed: () {
                if (_editWaterFromKey.currentState?.validate() == true) {
                  editWaterMeter(
                      _context!,
                      scaffoldKey,
                      // dataToEdit['id'],
                      // _consumerNameController.text,
                      // _subscriptionNoController.text,
                      // _meterDegreeController.text,
                      // _costPermeterController.text,
                      // DateFormat('y-M-d').format(
                      //     _mySelectedDate ?? DateTime.parse(dataToEdit['date'])),
                      dataToEdit);
                  Navigator.of(context).pop();
                  setState(() {
                    _futureWaterMeter = fetchWaterMeter();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> myDelete(
      {required BuildContext context,
      required GlobalKey<ScaffoldState> scaffoldKey,
      required int meterID}) async {
    bool? response = await deleteWaterMeter(context, scaffoldKey, meterID);
    if (response == true) {
      setState(() {
        _futureWaterMeter = fetchWaterMeter();
      });
    }
  }
}
