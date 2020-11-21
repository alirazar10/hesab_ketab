import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hesab_ketab/utils/api_config.dart';
import 'package:http/http.dart' as http;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubmetersList extends StatefulWidget {
  SubmetersList({Key key}) : super(key: key);

  @override
  _SubmetersListState createState() => _SubmetersListState();
}

class _SubmetersListState extends State<SubmetersList> {
  GlobalKey<ScaffoldState> _submeterListScaffoldStateKey  = GlobalKey<ScaffoldState>();
  Future _futureSubmeter;
  final _apiConfig = new API_Config();
  String _apiUrl;
  String _access_token;
  String _userData;
  Map _submeterData; 
  Map <String, String> _header; 
  DateFormat _dateFormat = DateFormat('y-d-M');
  BuildContext _context;

  var height;
  var width;
  
  @override
  void initState() {
    super.initState();
    _futureSubmeter = fetchSubmeter();
  }
  
  @override
  Widget build(BuildContext context) {
    _context = context;
    this.height = MediaQuery.of(context).size.height;
    this.width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _submeterListScaffoldStateKey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('میترهای فرعی'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: height * 0.01),

        child: FutureBuilder(
          future: _futureSubmeter,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // print(snapshot.data);
            
            if(snapshot.hasData){
              var data = snapshot.data;
              return Material(
                child: Container(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if(data[index]['error'] != null && data[index]['error'] == true  ){
                        return  showExceptionMsg(context: this._context, message: data[index]['message']);
                      }

                      if(data[index]['submeters'].length != 0){
                        var submeterLen = data[index]['submeters'].length;
                        List<TableRow> _tableRow = [];
                        
                        _tableRow.add(TableRow(
                          children: [
                            Text('نام میتر', style: myTextStyle( fontWeight: FontWeight.w600),),
                            Text('درجه میتر', style: myTextStyle( fontWeight: FontWeight.w600)),
                            Text('تاریخ ثبت', style: myTextStyle( fontWeight: FontWeight.w600)),
                            Text('', style: myTextStyle( fontWeight: FontWeight.w600)),
                          ]
                        ));
                        for(int i=0; i < submeterLen; i++){
                        var formatedDate = _dateFormat.format(DateTime.parse(data[index]['submeters'][i]['date']));
                          
                          _tableRow.add(TableRow(
                            
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '${data[index]['submeters'][i]['submeter_consumer']}',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '${data[index]['submeters'][i]['meter_degree']}'
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '$formatedDate'
                                ),
                              ),

                              IconButton(
                                icon: Icon(FontAwesomeIcons.times),
                                color: Colors.red,
                                splashRadius: 15.0,
                                visualDensity: VisualDensity(vertical: -4, horizontal: 0),
                                iconSize: 16, padding: EdgeInsets.all(0.0),
                                onPressed: (){
                                  print(data[index]['submeters'][i]['id']);
                                  myDelete( context: _context, meterID: data[index]['submeters'][i]['id']);
                                }),
                              
                            ]
                          ));
                        }
                        return Material(
                          child: Column(
                            children: [
                              Ink(
                                width: width,
                                padding: EdgeInsets.all( height * 0.012),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF0F0F0),
                                  boxShadow: boxShadow(),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'میتر عمومی: ',
                                            style: myTextStyle(fontSize: 16, fontWeight: FontWeight.w700 ),
                                          ),
                                          Text(
                                            '${data[index]['consumer_name']} - ${data[index]['no_of_submeters']}',
                                            style: myTextStyle(fontSize: 16, fontWeight: FontWeight.w500 ),
                                          ),
                                        ],
                                      ),
                                      
                                      Container(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: width,
                                              color: Colors.grey[300],
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('میترهای فرعی',
                                                style: myTextStyle(fontSize: 14, fontWeight: FontWeight.w500 )
                                              ),
                                            ),
                                            Table(
                                              // columnWidths: {1: FlexColumnWidth(3.0) },
                                              children: _tableRow,
                                              
                                            ),
                                          ],
                                        )
                                      ),
                                        
                                    ],
                                  ),
                                )
                              ),
                              Divider(thickness: 3.0,),
                              SizedBox(height: height * 0.012)
                            ],
                          ),
                        );

                      }else{

                        return Material(
                          child: Column(
                            children: [
                              Container(
                                width: width,
                                padding: EdgeInsets.all( height * 0.012),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF0F0F0),
                                  boxShadow: boxShadow(),
                                ),
                                child: 
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${data[index]['consumer_name']} - ${data[index]['meter_no']}',
                                        style: myTextStyle( fontSize: 16.0,fontWeight: FontWeight.w500),
                                      ),
                                      Center(
                                        child: Text(
                                          'میتر فرعی ندارد',
                                          style: myTextStyle( color: Color(0xFFFF5622),fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ),
                              Divider(thickness: 3.0,),
                              SizedBox(height: height * 0.012)
                            ],
                          ),
                        );

                      }
                   },
                  ),
                ),
              );
            }else if(snapshot.hasError){
              return Text('${snapshot.hasError}');
            }
            return Center(child: CircularProgressIndicator(),);

          },
        ),
      ),
    );
  }

  

deleteSubmeter(int meterID) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this._apiUrl = this._apiConfig.apiUrl('deleteSubmeter');
    this._userData = prefs.getString('user');
    this._submeterData ={
      'user' : _userData,
      'id' : meterID.toString(),
    };
    this._access_token = prefs.getString('access_token');
    this._header = {
                  "Content-Type": "application/x-www-form-urlencoded",
                  "Accept": 'application/json',
                  'Authorization': this._access_token,};
    // print(_mainMeterData);
    var response = await http.post(
      this._apiUrl,
      body: _submeterData, 
      headers: _header,
    );
    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      
      return createSnackBar(data['message'], _context, _submeterListScaffoldStateKey);
    }else{
      print(response.body);
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], _context, _submeterListScaffoldStateKey);

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
              Text('میتر فرعی خذف شود؟', style: myTextStyle(color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold,)),
              SizedBox(height: 40.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    color: Colors.red,
                    child: Text('حذف', style: myTextStyle(color: Colors.white, fontSize: 16.0,)),
                    onPressed: (){
                      setState(() {
                        deleteSubmeter(meterID);
                        _futureSubmeter = fetchSubmeter();
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