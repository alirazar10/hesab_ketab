import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';

class Addwatermeter extends StatefulWidget {
  Addwatermeter({Key key}) : super(key: key);

  @override
  _AddwatermeterState createState() => _AddwatermeterState();
}

class _AddwatermeterState extends State<Addwatermeter> {
  var height;
  var width;
  final GlobalKey<ScaffoldState> _addWaterScaffoldStateKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _addWaterFromKey = GlobalKey<FormState>();
  TextEditingController _consumerNameController = TextEditingController();
  TextEditingController _subscriptionNoController = TextEditingController();
  TextEditingController _meterDegreeController = TextEditingController();
  TextEditingController _costPermeterController = TextEditingController();
  // var date = DateFormat('y-d-M').format(DateTime.now());
  DateTime _mySelectedDate;
  // DateTime.now()
  BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context = context;
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
          onTap: ()=> FocusScope.of(context).unfocus(),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              left: height * 0.015,
              top: height * 0.015, 
              right: height * 0.015,
              bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Form(  
                key: _addWaterFromKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: TextFormField(
                        controller: _consumerNameController,
                        decoration: myInputDecoration(labelText: 'اسم مشترک', helperText: 'اسم مشترک در بل'),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        style: myTextStyle(color: Color(0xFF212121)),
                        // ignore: missing_return
                        validator: (value){
                          if(value.isEmpty){
                            return 'اسم مشترک را وارد نمایید.';
                          }
                        },
                      )
                    ),
                    SizedBox(height: 15.0,),
                    Container(
                      child: TextFormField(
                        controller: _subscriptionNoController,
                        decoration: myInputDecoration(labelText: 'شماره ثبت بل'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        style: myTextStyle(color: Color(0xFF212121)),
                        // ignore: missing_return
                        validator: (value){
                          if(value.isEmpty){
                            return 'شماره ثبت بل را وارد نمایید.';
                          }
                        },
                      )
                    ),
                    SizedBox(height: 15.0,),
                    Container(
                      child: TextFormField(
                        controller: _meterDegreeController,
                        decoration: myInputDecoration(labelText: 'درجه میتر', helperText: 'اخرین درجه حالیه در بل'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        style: myTextStyle(color: Color(0xFF212121)),
                        // ignore: missing_return
                        validator: (value){
                          if(value.isEmpty){
                            return 'درجه بل را وارد نمایید';
                          }
                        },
                      )
                    ),
                    SizedBox(height: 15.0,),
                    Container(
                      child: TextFormField(
                        controller: _costPermeterController,
                        decoration: myInputDecoration(labelText: 'قیمت فی متر آب'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        style: myTextStyle(color: Color(0xFF212121)),
                        // ignore: missing_return
                        validator: (value){
                          if(value.isEmpty){
                            return 'قیمت فی متر اب را وارد نمایید.';
                          }
                        },
                      )
                    ),
                    SizedBox(height: 15.0,),
                    Container(
                      child: MyTextFieldDatePicker(
                      
                        labelText: "تاریخ",
                        prefixIcon: Icon(Icons.date_range),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        lastDate: DateTime.now().add(Duration(days: 366)),
                        firstDate: DateTime.now().subtract(Duration(days: 366)),
                        initialDate: DateTime.now().add(Duration(days: 1)),
                        onDateChanged: (selectedDate) {
                          // Do something with the selected date
                          _mySelectedDate = selectedDate;
                          print(_mySelectedDate);
                        },
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    Container(
                      child: RaisedButton(
                        color: Color(0xFFFF5722),
                        child: Text('ثبت میتر', style: myTextStyle(color: Colors.white),),
                        onPressed: ()async{
                          if(_addWaterFromKey.currentState.validate()){
                            _addWaterFromKey.currentState.save();
                            Map _dataToSend = {
                              'consumer_name': _consumerNameController.text,
                              'subscription_no': _subscriptionNoController.text,
                              'meter_degree': _meterDegreeController.text,
                              'cost_perdegree' : _costPermeterController.text,
                              'date': _mySelectedDate != null ? _mySelectedDate.toString() : DateFormat('y-M-d').format(DateTime.now()).toString()  
                            };
                            print(_costPermeterController.text);
                            await addWaterMeter(_context, _addWaterScaffoldStateKey, _dataToSend );
                          }
                        }
                      )
                    )
                    
                  ],
                ),
              ),
            ),  
          ),
        ),
      ),
    );
  }
}