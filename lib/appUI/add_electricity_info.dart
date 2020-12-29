import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:hesab_ketab/utils/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddMainMeter extends StatefulWidget {
  AddMainMeter({Key key}) : super(key: key);

  @override
  _AddMainMeterState createState() => _AddMainMeterState();
}

class _AddMainMeterState extends State<AddMainMeter> {
  final GlobalKey<FormState> _addMainMeterFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _addMainMeterScaffoldStateKey = GlobalKey<ScaffoldState>();
  BuildContext _context;
  final _apiConfig = new API_Config();
  final _consumerNameTextEditController = TextEditingController(); 
  final _consumerIDTextEditController = TextEditingController(); 
  final _meterIDTextEditController = TextEditingController(); 
  final _submeterNoTextEditController = TextEditingController(); 
  // final _dateTextEditController = TextEditingController(); 
  DateTime _mySelectedDate;

  String _apiUrl;
  String _access_token;
  String _userData;
  Map _mainMeterData = new Map(); 
  Map <String, String> _header;

  void addMainMeter() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this._apiUrl = this._apiConfig.apiUrl('addMainMeter');
      // prefs.remove('users');
    String _userData = prefs.getString('user');
    this._mainMeterData ={
      'consumer_name' : _consumerNameTextEditController.text, 
      'subscription_no' : _consumerIDTextEditController.text, 
      'meter_no' : _meterIDTextEditController.text,
      'no_of_submeters' : _submeterNoTextEditController.text,
      'date' : _mySelectedDate.toString(),
      'user' : _userData,
    };
    this._access_token = prefs.getString('access_token');
    this._header = {
                  "Content-Type": "application/x-www-form-urlencoded",
                  "Accept": 'application/json',
                  'Authorization': _access_token,};
    // print(_mainMeterData);
    
    
    try{
      var response = await http.post(
        this._apiUrl,
        body: _mainMeterData, 
        headers: _header,
      );
      if(response.statusCode == 201){
        Map data = json.decode(response.body);
        return createSnackBar(data['message'], _context, _addMainMeterScaffoldStateKey);
      }else if (response.statusCode == 422){
        Map data = json.decode(response.body);
        throw('Message: ${data['errors']} With Status Code:  ${response.statusCode}');
      }else if(response.statusCode == 400) {
        Map data  = json.decode(response.body);
        throw('Message ${data['message']} \n Status Code:  ${response.statusCode}');
      }else if(response.statusCode == 500){
        throw ('Internal server error \n Status Code ${response.statusCode}');
      }else{
        throw('Message: Unkown Error Status Code:  ${response.statusCode}');
      }
    }catch (e){
      return createSnackBar('$e', context, _addMainMeterScaffoldStateKey, color: Colors.red);
    }
  }
  @override
  Widget build(BuildContext context) {
    this._context = context;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _addMainMeterScaffoldStateKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('ثبت میترهای عمومی', style: myTextStyle(fontSize: 20),),
        centerTitle: true,
      ),
      body: Container( 
        alignment: Alignment.center,
        
        height: height,
        padding: EdgeInsets.only(
          left: width * 0.015,right: width * 0.015, top: height * 0.015, 
          bottom: MediaQuery.of(context).viewInsets.bottom + height * 0.015,
        ),
        child: GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),
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
                          style: myTextStyle(color: Color(0xFF212121)),
                          decoration: myInputDecoration(labelText:'اسم مشترک'),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).nextFocus(),
                          // ignore: missing_return
                          validator: (String value){
                            if(value.isEmpty){
                              return 'اسم مشترک را وارد نمایید.';
                            }
                          },
                        )
                      ),
                      SizedBox(height: height * 0.015,),
                      Container(
                        child: TextFormField(
                          controller: _consumerIDTextEditController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).nextFocus(),
                          style: myTextStyle(color: Color(0xFF212121)),
                          decoration: myInputDecoration(labelText:'نمبر اشتراک'),
                          // ignore: missing_return
                          validator: (String value){
                            if(value.isEmpty){
                              return 'نمبر اشتراک را وارد نمایید.';
                            }
                            /**
                             * @TODO 
                             * belo is incorrect
                             */
                            // if(_consumerIDTextEditController.text.runtimeType != int){
                            //   return 'نمبر اشتراک باید شماره باشد.';
                            // }
                          },
                        )
                      ),
                      SizedBox(height: height * 0.015,),
                      Container(
                        child: TextFormField(
                          controller: _meterIDTextEditController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).nextFocus(),
                          style: myTextStyle(color: Color(0xFF212121)),
                          decoration: myInputDecoration(labelText:'نمبر میتر'),
                          // ignore: missing_return
                          validator: (String value){
                            if(value.isEmpty){
                              return 'نمبر میتر را وارد نمایید.';
                            }
                          },
                        )
                      ),
                      SizedBox(height: height * 0.012,),
                      Container(
                        padding: EdgeInsets.only(),
                        child: TextFormField(
                          controller: _submeterNoTextEditController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).nextFocus(),
                          style: myTextStyle(color: Color(0xFF212121)),
                          decoration: myInputDecoration(labelText:'تعداد میترهای فرعی'),
                          // ignore: missing_return
                          validator: (String value){
                            if(value.isEmpty)
                              return 'تعداد میترهای فرعی را وارد نمایید.';
                          },
                        )
                      ),
                      // SizedBox(height: height * 0.012,),
                      // Container(
                      //   padding: EdgeInsets.only(),
                      //   child: TextFormField(
                      //     controller: _dateTextEditController,
                      //     // keyboardType: TextInputType.datetime,
                      //     textInputAction: TextInputAction.none,
                      //     onEditingComplete: () => FocusScope.of(context).nextFocus(),
                      //     style: myTextStyle(color: Color(0xFF212121)),
                      //     decoration: myInputDecoration(labelText: 'تاریخ ثبت'),
                      //     // ignore: missing_return
                      //     validator: (String value){
                      //       if(value.isEmpty)
                      //         return 'تاریخ ثبت را وارد نمایید.';
                      //     },
                      //     onTap: (){
                      //       _selectDate(context);
                      //     },
                      //   )
                      // ),
                      SizedBox(height: height * 0.012,),
                      MyTextFieldDatePicker(
                        
                        labelText: "تاریخ ثبت",
                        prefixIcon: Icon(Icons.date_range),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        lastDate: DateTime.now().add(Duration(days: 366)),
                        firstDate: DateTime.now(),
                        initialDate: DateTime.now().add(Duration(days: 1)),
                        onDateChanged: (selectedDate) {
                          // Do something with the selected date
                          _mySelectedDate = selectedDate;
                        },
                      ),
                      SizedBox(height: height * 0.012,),
                      Container(
                        width: width,
                        padding: EdgeInsets.only(top: height * 0.015),
                        child: RaisedButton(
                          padding: EdgeInsets.all(10.0),
                          color: Color(0xFFFF5722),
                          child: Text('ثبت میتر' , style: myTextStyle(color: Colors.white),),
                          onPressed: () {
                            if(_addMainMeterFormKey.currentState.validate()){
                              _addMainMeterFormKey.currentState.save();
                              addMainMeter();
                            }
                          },
                        )
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