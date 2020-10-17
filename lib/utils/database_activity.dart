import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';

import 'package:hesab_ketab/utils/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


fetchMainMeters() async {
  final _apiConfig  = new API_Config();
  final _apiURL =  _apiConfig.apiUrl('fetchMainMeters');
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
    return data;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

changeMainMeterStatus( context, _mainMeterListScaffoldStateKey,  meterID, status) async {
  final _apiConfig  = new API_Config();
  final _apiURL =  _apiConfig.apiUrl('changeStatusMainMeters');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final Map _userData =jsonDecode(prefs.getString('user')); 
  final String _access_token = prefs.getString('access_token');
  final Map<String, String> _headers = {                    
                    "Accept": 'application/json',
                    'Authorization': _access_token,
                    };
  final Map<String, String> data = {'user_id': _userData['user_id'].toString(), 'id': meterID.toString() ,'status': status.toString()};
  // print(meterID);
  final response = await http.post(_apiURL, body: (data), headers: _headers);
  if (response.statusCode == 201) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map data  = json.decode(response.body);
    return createSnackBar(data['message'], context, _mainMeterListScaffoldStateKey );
   
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    // print(response.body);
    Map data  = json.decode(response.body);
    return createSnackBar(data['message'], context, _mainMeterListScaffoldStateKey );

    throw Exception('Failed to load data');
  }
}

addSubMeters(BuildContext context, scaffoldStateKey, {meterID, submeterConsumer,meterDegree, mySelectedDate, date}) async {
  final _apiConfig  = new API_Config();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String _apiUrl = _apiConfig.apiUrl('addSubMeters');
  String _userData = prefs.getString('user');
  Map _mainMeterData ={
    'mainmeter_id' : meterID, 
    'submeter_consumer' : submeterConsumer, 
    'meter_degree' : meterDegree,
    'date' : date.toString(),
    'user' : _userData,
  };
  String _access_token = prefs.getString('access_token');
  Map<String, String> _header = {
                "Content-Type": "application/x-www-form-urlencoded",
                "Accept": 'application/json',
                'Authorization': _access_token,};
  var response = await http.post(
    _apiUrl,
    body: _mainMeterData, 
    headers: _header,
  );
  if(response.statusCode == 201){
    Map data = json.decode(response.body);
    return createSnackBar(data['message'], context, scaffoldStateKey);
  }else{
    Map data = json.decode(response.body);
    return createSnackBar(data['message'], context, scaffoldStateKey);

  }
}

fetchSubmeter() async{
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
    return data;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    // List data  = json.decode(response.body);
    // print(response.body);
    throw Exception('Failed to load data');
  }
}

addBill(BuildContext context, scaffoldKey, _degreeTextFeildController ,  Map dataToBeSend) async{
  
  Map<String, String> submeterDegree = Map();
  _degreeTextFeildController.forEach((key, value) { 
    submeterDegree.addAll({key : value.text});
  });
  
  dataToBeSend.addAll(<String, String>{'submeterDegree' : "${json.encode(submeterDegree)}"});

  final _apiConfig  = new API_Config();
  final _apiURL =  _apiConfig.apiUrl('addBillAndSubmeterDegree');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String _access_token = prefs.getString('access_token');
  final Map<String, String> _headers = {                    
                    "Accept": 'application/json',
                    'Authorization': _access_token,
                    };
  dataToBeSend['user'] = prefs.getString('access_token');

  var response = await http.post(
    _apiURL,
    body: dataToBeSend, 
    headers: _headers,
  );
  if(response.statusCode == 201){
    Map data = json.decode(response.body);
    print(response.body);
    return createSnackBar(data['message'], context, scaffoldKey);
  }else{
    // Map data = json.decode(response.body);
    print(response.body.toString());
    return 'success';
    // return createSnackBar(data['message'], context, scaffoldKey);

  }

       
}