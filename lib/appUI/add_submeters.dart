import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:http/http.dart' as http;
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/utils/api_config.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddSubmeters extends StatefulWidget {
  AddSubmeters({Key key}) : super(key: key);

  @override
  _AddSubmetersState createState() => _AddSubmetersState();
}

class _AddSubmetersState extends State<AddSubmeters> {
  BuildContext _context;
  Future futureSubmeter;
  final GlobalKey<FormState> _submetersFormKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _submetersScaffoldKey = new GlobalKey<ScaffoldState>();
  List _dropdownItmes = List();
  String _dropdownValue;
  DateTime _mySelectedDate;

  final _submeterNameController = TextEditingController();
  final _degreeController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchMainMeters().then((val){
        setState(() {
          this._dropdownItmes = val;
        });
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    this._context = context;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
                     
    final _inputPadding = EdgeInsets.only(top: height * 0.015);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _submetersScaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('ثبت میترهای فرعی', style: myTextStyle(fontSize: 20),),
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
              children: _dropdownItmes.isEmpty ? [ //checks if it has data if yes display loading
                Center(child: CircularProgressIndicator())
                ] : _dropdownItmes[0]['error'] != null && _dropdownItmes[0]['error'] == true ? [ //check if it hass error if yes show error
                  showExceptionMsg(context: this._context, message: _dropdownItmes[0]['message']),
                  
                ]: [
                Form(
                  key: _submetersFormKey,
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
                            );
                          }).toList(),
                          onChanged: (value){
                            setState(() {
                              _dropdownValue = value;
                            });
                          },
                          // ignore: missing_return
                          validator: (String value){
                          //  value = '';
                            if(value == null || value.isEmpty){
                              return ' میتر عمومی را انتخاب نمایید.';
                            }
                          },
                        )
                      ),
                      Container(
                        padding: _inputPadding,
                        child: TextFormField(
                          controller: _submeterNameController,
                          decoration: myInputDecoration(labelText: 'نام گذاری میتر'),
                          style: myTextStyle(color: Color(0xFF212121)),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).nextFocus(),
                          // ignore: missing_return
                          validator: (String value){
                            if(value.isEmpty){
                              return 'نام میتر را وارد نمایید.';
                            }
                          },
                        )
                      ),
                      Container(
                        padding: _inputPadding,
                        child: TextFormField(
                          controller: _degreeController,
                          decoration: myInputDecoration(labelText: 'درجه میتر'),
                          style: myTextStyle(color: Color(0xFF212121)),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).nextFocus(),
                          // ignore: missing_return
                          validator: (String value){
                            if(value.isEmpty){
                              return 'نام میتر را وارد نمایید.';
                            }
                          },
                        )
                      ),
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
                        child: Text('ثبت میتر فرعی' , style: myTextStyle(color: Colors.white),),
                        onPressed: () {
                          if(_submetersFormKey.currentState.validate()){
                            _submetersFormKey.currentState.save();
                            addSubMeters(
                              context, _submetersScaffoldKey,
                              meterID: _dropdownValue,
                              submeterConsumer: _submeterNameController.text,
                              meterDegree: _degreeController.text,
                              date: _mySelectedDate,
                            );
                          }
                        },
                      )
                    ),
                    ],
                  ) 
                ),
              ],
            ),
          ),
         ),
      ),
    );
  }
}
