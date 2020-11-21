import 'dart:convert';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:hesab_ketab/utils/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddElectricityBill extends StatefulWidget {
  AddElectricityBill({Key key}) : super(key: key);

  @override
  _AddElectricityBillState createState() => _AddElectricityBillState();
}

class _AddElectricityBillState extends State<AddElectricityBill> {
  BuildContext _context;
  final GlobalKey<ScaffoldState> _billScaffoldStateKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _addBillFromKey = GlobalKey<FormState>();
  TextEditingController _payableBillController = TextEditingController();
  List _dropdownItmes = List();
  String _dropdownValue;
  DateTime _mySelectedDateIssue;
  DateTime _mySelectedDateEnd;
  int _submeterNo;
  List _submeterInfo = List();
  List<Widget> _children = [];
  Map < String, TextEditingController> _degreeTextFeildController = Map();
  var height;
  var width;



  fetchMainMeters() async {
    final _apiConfig  = new API_Config();
    final _apiURL =  _apiConfig.apiUrl('fetchSubmeters');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    final Map _userData =jsonDecode(prefs.getString('user')); 
    final String _access_token = prefs.getString('access_token');
    final Map<String, String> _headers = {                    
                      "Accept": 'application/json',
                      'Authorization': _access_token,
                      };
    final Map<String, String> data = {'user_id': _userData['user_id'].toString()};
    
    final response = await http.post(_apiURL, body: (data), headers: _headers);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List data  = json.decode(response.body);
      // print(data);
      List res = new List();

      
      for( var i = 0; i < data.length; i++){
        if(data[i]['status'] == 1){
          if(data[i]['submeters'].length != 0){
            res.add(data[i]);
          }
        }
      }
      setState(() {
        _dropdownItmes = res;
      });
      return res;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print(response.body);
      throw Exception('Failed to load album');
    }
  }
  _addSubmeterTextFeild(submeterNO, submeterInfo){
    for(int i = 0; i < submeterInfo.length; i++){
      _degreeTextFeildController[submeterInfo[i]['id'].toString()] = TextEditingController();
      _children = List.from(_children)
      ..add(SizedBox(height: height * 0.015,));
      _children = List.from(_children)
      ..add(TextFormField(
        controller: _degreeTextFeildController[submeterInfo[i]['id'].toString()],
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: myInputDecoration(labelText: ' درجه حالیه: ${submeterInfo[i]['submeter_consumer']}'),
        // ignore: missing_return
        validator: (value){
          if(value.isEmpty){
            return '${submeterInfo[i]['submeter_consumer']} را وارد نمایید.';
          }
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
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    this._context = context;
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
            left: width * 0.015,right: width * 0.015, top: height * 0.015, 
            bottom: MediaQuery.of(context).viewInsets.bottom + height * 0.015,
          ),
          child: GestureDetector(
            onTap: ()=> FocusScope.of(context).unfocus(),
            child: Form(
              key: _addBillFromKey,
              child: SingleChildScrollView(
                // controller: controller,
                child: Column(
                  children: [
                    Container(
                      child: DropdownButtonFormField(
                          
                        decoration: myInputDecoration(labelText: 'انتخاب میتر عمومی'),
                        // hint: Text('انتخاب میتر عمومی'),
                        style: myTextStyle(fontSize: 16.0, color: Colors.black),
                        value: _dropdownValue,
                        items: _dropdownItmes.map((list){
                          
                          return DropdownMenuItem(
                            child: Text(list['meter_no'] + ' -- ' + list['consumer_name']),
                            value: list['id'].toString(),
                            onTap: (){
                              _submeterNo = list['no_of_submeters'];
                              _submeterInfo =list['submeters'];
                            },
                          );
                        }).toList(),
                        onChanged: (value){
                          setState(() {
                            if(_children.length != 0 ){
                              _children.clear(); // to create new textfields clear list items
                            }
                            _addSubmeterTextFeild(_submeterNo, _submeterInfo);
                            _dropdownValue = value;
                          });
                        },
                        // ignore: missing_return
                        validator: (String value){
                          if(value == null || value.isEmpty){
                            return ' میتر عمومی را انتخاب نمایید.';
                          }
                        },
                      )
                    ),
                    SizedBox(height: height * 0.015,),
                    Container(
                      
                      child: TextFormField(
                        controller: _payableBillController,
                        decoration: myInputDecoration(labelText: 'مقدار پول پرداختی'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        style: myTextStyle(color: Color(0xFF212121)),
                        // ignore: missing_return
                        validator: (value){
                          if (value.isEmpty) {
                            return 'مقدار پول پرداختی را وارد نمایید.';
                          }
                        },
                      )
                    ),
                    
                    SizedBox(height: height * 0.012,),
                    MyTextFieldDatePicker(
                      
                      labelText: "تاریخ صدور",
                      prefixIcon: Icon(Icons.date_range),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      lastDate: DateTime.now().add(Duration(days: 366)),
                      firstDate: DateTime.now().subtract(Duration(days: 366)),
                      initialDate: DateTime.now().add(Duration(days: 1)),
                      onDateChanged: (selectedDate) {
                        // Do something with the selected date
                        _mySelectedDateIssue = selectedDate;
                      },
                    ),
                    SizedBox(height: height * 0.012,),
                    MyTextFieldDatePicker(
                      
                      labelText: "تاریخ مهلت",
                      prefixIcon: Icon(Icons.date_range),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      lastDate: DateTime.now().add(Duration(days: 366)),
                      firstDate: DateTime.now().subtract(Duration(days: 366)),
                      initialDate: DateTime.now().add(Duration(days: 1)),
                      onDateChanged: (selectedDate) {
                        // Do something with the selected date
                        _mySelectedDateEnd = selectedDate;
                      },
                      
                    ),
                    Column(
                      children: _children,
                    ),
                    SizedBox(height: height * 0.012,),
                    Container(
                      width: width,
                      padding: EdgeInsets.only(top: height * 0.015),
                      child: RaisedButton(
                        padding: EdgeInsets.all(10.0),
                        color: Color(0xFFFF5722),
                        child: Text('ثبت و محاسبه بل' , style: myTextStyle(color: Colors.white),),
                        onPressed: () {
                          if(_addBillFromKey.currentState.validate()){
                            _addBillFromKey.currentState.save();
                            var dataToBeSend = {
                              'mainmeter_id' : _dropdownValue,
                              'bill_amount' : _payableBillController.text,
                              'issue_date' : _mySelectedDateIssue.toString(),
                              'due_date' : _mySelectedDateEnd.toString()
                            };
                            addBill(context, _billScaffoldStateKey, _degreeTextFeildController, dataToBeSend);
                          }
                        },
                      )
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}