import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:hesab_ketab/utils/api_config.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainMeterList extends StatefulWidget {
  MainMeterList({Key key}) : super(key: key);

  @override
  _MainMeterListState createState() => _MainMeterListState();
}

class _MainMeterListState extends State<MainMeterList> {
  Future futureMainmeter;
  final GlobalKey<FormState> _editMainMeterFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _mainMeterListScaffoldStateKey = GlobalKey<ScaffoldState>();
  BuildContext _context;
  final _apiConfig = new API_Config();
  final _consumerNameTextEditController = TextEditingController(); 
  final _consumerIDTextEditController = TextEditingController(); 
  final _meterIDTextEditController = TextEditingController(); 
  final _submeterNoTextEditController = TextEditingController(); 
  DateTime _mySelectedDate;

  String _apiUrl;
  String _access_token;
  String _userData;
  Map _mainMeterData = new Map(); 
  Map <String, String> _header;

  var height;
  var width;
  @override
  void initState() {
    super.initState();
    futureMainmeter = fetchMainMeters();
  }
  @override
  Widget build(BuildContext context) {
    this._context = context;
    this.height = MediaQuery.of(context).size.height;
    this.width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _mainMeterListScaffoldStateKey,
      appBar: AppBar(
        title: Text('لیست میترهای عمومی'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top:height * .01),
        child: FutureBuilder(
          future: futureMainmeter,
          // initialData: InitialData,
          builder: ( context,  snapshot) {
            if (snapshot.hasData) {
            return snapshot.data.length != 0 ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
              var status = snapshot.data[index]['status'];
              return Material(
                // elevation: 10.0,
                child: Column(
                  children: [
                      Container(
                      child: Ink(
                        width: width,
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
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,

                                        children: [
                                          Text('${snapshot.data[index]['consumer_name']}', style: myTextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                                          SizedBox(width: 10.0,),
                                          status == 1 ? Icon(FontAwesomeIcons.check, color: Color(0xff00BCD4), size: 16,) : SizedBox(width: 2.0,),
                                        ],
                                      ),
                                      Row( 
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text( 'نمبر اشتراک: ',
                                          style: myTextStyle(  fontSize: 14.0, ),),
                                          Text( snapshot.data[index]['subscription_no'],
                                          ),
                                        ],
                                      ),
                                    
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text( 'نمبر میتر: ',style: myTextStyle(  fontSize: 14.0, ),),
                                          Text(snapshot.data[index]['meter_no']),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text( 'تعداد میتر های فرعی:', style: myTextStyle(  fontSize: 14.0, ),),
                                          Text('${snapshot.data[index]['no_of_submeters']}'),
                                        ],
                                      ),
                                      // Divider(),
                                      
                                    ],
                                  ),
                                ),
                                Container(
                                  // color: Colors.red,
                                  height: 100.0,
                                  child :VerticalDivider(thickness: 2.0, indent: 30.0,),
                                ),
                                Container(
                                  padding:  EdgeInsets.only(top: height * .02, right: 15.0),
                                  // margin:  EdgeInsets.only(top: height * .028, ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: Icon(FontAwesomeIcons.edit),
                                        color: Color(0xff00BCD4),
                                        iconSize: 18.0,
                                        onPressed: (){
                                          myEditAlertBox(
                                            context: _context,
                                            consumerName: snapshot.data[index]['consumer_name'],
                                            subscNo: snapshot.data[index]['subscription_no'],
                                            meterNo : snapshot.data[index]['meter_no'],
                                            noOfMeter: snapshot.data[index]['no_of_submeters'],
                                            meterID: snapshot.data[index]['id'],
                                            date: snapshot.data[index]['date'],
                                          );
                                        },
                                      ),
                                      
                                      IconButton(
                                        color: Colors.red,
                                        icon: Icon(FontAwesomeIcons.times, size: 18.0,),
                                        onPressed: (){
                                          myDelete(context: _context, meterID: snapshot.data[index]['id']);
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
                                // Text('', style: myTextStyle(color: Colors.grey[600], fontSize: 12.0),),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                      Text('وضعیت میتر: ', style: myTextStyle(color: Colors.grey[600], fontSize: 12.0)),
                                      status == 1 ? 
                                      Text('فعال', style: myTextStyle(color: Color(0x9100BBD4))) : 
                                      Text('غیر فعال', style: myTextStyle(color: Color(0x91FF5622))),
                                    ],),
                                    
                                    Text( 'تاریخ ثبت: ${snapshot.data[index]['date']}', style: myTextStyle(color: Colors.grey[600], fontSize: 12.0)),
                                    
                                  ],
                                ),
                                OutlineButton(
                                  color: Color(0xFFFF5622),
                                  onPressed: (){
                                    var st = status == 1 ? 0 : 1;
                                    
                                    setState(() {
                                      changeMainMeterStatus( _context, _mainMeterListScaffoldStateKey ,snapshot.data[index]['id'], st);
                                      futureMainmeter = fetchMainMeters();
                                    });
                                  },
                                  child: Text('تغیر وضعیت', style: myTextStyle(color: Color(0xff00BCD4), fontSize: 12.0),)
                                ) 
                              ],
                            )
                          ],
                        )
                      ),
                    ),
                    Divider(thickness: 3.0,),
                    SizedBox(height: height * 0.012)
                  ],
                  
                ),
              );
             },
            ) : Container(
              padding: EdgeInsets.all(height * 0.03),
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: boxShadow(),
                color: Color(0xFFE9EAEB),
              ),
              child: Row(
                children: [
                  Icon( FontAwesomeIcons.exclamationTriangle, color: Color(0xFFFF5622),),
                  SizedBox(width: 10.0,),
                  Text(' میتری ثبت نشده. ',
                  style: myTextStyle(color: Color(0xff00BCD4), fontSize: 20.0, fontWeight: FontWeight.bold),),
                ],
              )
                );
              
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }

  editMainMeter(int meterID) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this._apiUrl = this._apiConfig.apiUrl('editMainMeter');
    String _userData = prefs.getString('user');
    this._mainMeterData ={
      'consumer_name' : _consumerNameTextEditController.text, 
      'subscription_no' : _consumerIDTextEditController.text, 
      'meter_no' : _meterIDTextEditController.text,
      'no_of_submeters' : _submeterNoTextEditController.text,
      'user' : _userData,
      'date' : _mySelectedDate.toString(),
      'id' : meterID.toString(),
    };
    print(meterID);
    this._access_token = prefs.getString('access_token');
    this._header = {
                  "Content-Type": "application/x-www-form-urlencoded",
                  "Accept": 'application/json',
                  'Authorization': _access_token,};
    // print(_mainMeterData);
    var response = await http.post(
      this._apiUrl,
      body: _mainMeterData, 
      headers: _header,
    );
    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      print(data);
      
      return createSnackBar(data['message'], _context, _mainMeterListScaffoldStateKey);
    }else{
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], _context, _mainMeterListScaffoldStateKey);

    }
  }
  myEditAlertBox({BuildContext context, String consumerName, String subscNo, String meterNo, int noOfMeter, int meterID, String date} ){
    
    return showDialog(
      // barrierDismissible:false,
      context: context,
      child: AlertDialog(
        title: Text('ویرایش میتر عمومی', style: myTextStyle(fontSize: 16.0),),
        content: SingleChildScrollView(
          child:Column(
            children: [
              Form(
                  key: _editMainMeterFormKey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: height * 0.015),
                        child: TextFormField(
                          controller: _consumerNameTextEditController..text = consumerName,
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
                          controller: _consumerIDTextEditController..text = subscNo,
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
                          controller: _meterIDTextEditController..text = meterNo,
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
                          controller: _submeterNoTextEditController..text = noOfMeter.toString(),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
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
                      SizedBox(height: height * 0.012,),
                    
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
                      SizedBox(height: height * 0.012,),
                      Container(
                        width: width,
                        padding: EdgeInsets.only(top: height * 0.015),
                        child: RaisedButton(
                          padding: EdgeInsets.all(10.0),
                          color: Color(0xFFFF5722),
                          child: Text('ویرایش میتر' , style: myTextStyle(color: Colors.white),),
                          onPressed: () {
                            if(_editMainMeterFormKey.currentState.validate()){
                              _editMainMeterFormKey.currentState.save();
                              setState(() {
                                editMainMeter(meterID);
                                futureMainmeter = fetchMainMeters();
                                Navigator.of(context, rootNavigator: true).pop();
                              });
                            }
                          },
                        )
                      ),
                    ],
                  ),
                ),
            ],
          )
        ),
      )
    );
  }
  deleteMainMeter(int meterID) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this._apiUrl = this._apiConfig.apiUrl('deleteMainMeter');
    String _userData = prefs.getString('user');
    this._mainMeterData ={
      'user' : _userData,
      'id' : meterID.toString(),
    };
    this._access_token = prefs.getString('access_token');
    this._header = {
                  "Content-Type": "application/x-www-form-urlencoded",
                  "Accept": 'application/json',
                  'Authorization': _access_token,};
    // print(_mainMeterData);
    var response = await http.post(
      this._apiUrl,
      body: _mainMeterData, 
      headers: _header,
    );
    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      
      return createSnackBar(data['message'], _context, _mainMeterListScaffoldStateKey);
    }else{
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], _context, _mainMeterListScaffoldStateKey);

    }
  }

  myDelete({BuildContext context, meterID}){
    return showDialog(
      context: context,
      child: AlertDialog(
        actionsPadding: EdgeInsets.all(20) ,
        elevation: 10.0,
        titleTextStyle:  myTextStyle(color: Colors.red, fontSize: 24.0, fontWeight: FontWeight.bold,),
        // title: Text('حذف میتر عمومی!'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Icon(FontAwesomeIcons.exclamationTriangle, size: 70, color: Colors.amberAccent,),
              SizedBox(height: 20.0,),
              Text('میتر عمومی خذف شود؟', style: myTextStyle(color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold,)),
              SizedBox(height: 40.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    color: Colors.red,
                    child: Text('حذف', style: myTextStyle(color: Colors.white, fontSize: 16.0,)),
                    onPressed: (){
                      setState(() {
                        deleteMainMeter(meterID);
                        futureMainmeter = fetchMainMeters();
                        Navigator.of(context, rootNavigator: true).pop();
                      });
                    }
                  ),
                  // SizedBox(width: 25,),
                  RaisedButton(
                    color: Color(0xff00BCD4),
                    child: Text('لغو', style: myTextStyle(color: Colors.white, fontSize: 16.0,)),
                    onPressed: (){
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  )
                ],
              )
            ],
          ),
        ),
        
      )
    );
  }
}







// class Mainmeter{
//   // ignore: non_constant_identifier_names 
//   final String consumer_name;
//   final String subscription_no;
//   final String meter_no;
//   final int no_of_submeters;
//   final int status;
//   final int id;
//   final int user_id;

//   Mainmeter({
//     this.consumer_name,
//     this.subscription_no,
//     this.meter_no,
//     this.no_of_submeters, this.status,
//     this.id,
//     this.user_id,
//     });

//   factory Mainmeter.fromJson(Map <String, dynamic> json){
//     print('${json['id']} : ${json['consumer_name']} : ${json['meter_no']}');
    
//     var data =  Mainmeter(
//       consumer_name: json['consumer_name'],
//       subscription_no: json['subscription_no'],
//       meter_no: json['meter_no'],
//       no_of_submeters: json['no_of_submeters'],
//       status: json['status'],
//       id: json['id'],
//       user_id: json['user_id'],
//     );
//     // print(data);
//     return data; 
//   }
// }
