import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hesab_ketab/appUI/login.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';

import 'package:hesab_ketab/utils/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'navigationService.dart';

logout(context, scaffoldKey) async {
  final _apiConfig  = new API_Config();
  final _apiURL =  _apiConfig.apiUrl('logout');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = prefs.getString('user');
  final Map _userData =jsonDecode(prefs.getString('user')); 
  final String _access_token = prefs.getString('access_token');
  final Map<String, String> _headers = {                    
                    "Accept": 'application/json',
                    'Authorization': _access_token,
                    };
  // prefs.remove('user');
  // prefs.remove('access_token');
  
  try{
    var response = await http.post(_apiURL, body: {'user_id': _userData['user_id'].toString()}, headers: _headers);

    if(response.statusCode == 201){
      prefs.remove('user');
      prefs.remove('access_token');
      // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(
          builder: (context) => Login()
        ),
        (Route<dynamic> route) => false
        // ModalRoute.withName("/HesabKetab") 
      );
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if(response.statusCode == 500){
      throw ('Internal server error \n ${response.body} \n Status Code ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status ${response.body} Code:  ${response.statusCode}');
    }
  } catch (e){
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}
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
 
  try {
    final response = await http.post(_apiURL, body: (data), headers: _headers);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List data  = json.decode(response.body);
      return data;
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if(response.statusCode == 404){
      Map data  = json.decode(response.body);
      throw ('Message: ${data['message']} \n Status Code:  ${response.statusCode}');
    } else if(response.statusCode == 500){
      throw ('Internal server error \n Status Code ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch (e) {
    List data = List();
    data.add({'error': true, 'message': '${e.toString()}'});
    return data; 
  }
}

changeMainMeterStatus( context, scaffoldKey,  meterID, status) async {
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
  try{
    final response = await http.post(_apiURL, body: (data), headers: _headers);
    if (response.statusCode == 201) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map data  = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey );
   
    } else if(response.statusCode == 400) {
      Map data  = json.decode(response.body);
      throw('Message ${data['message']} \n Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if(response.statusCode == 500){
      throw ('Internal server error \n Status Code ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch(e){
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

addSubMeters(BuildContext context, scaffoldKey, {meterID, submeterConsumer,meterDegree, mySelectedDate, date}) async {
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
  try{
    var response = await http.post(
      _apiUrl,
      body: _mainMeterData, 
      headers: _header,
    );
    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey);
    }else if (response.statusCode == 422){
      Map data = json.decode(response.body);
      throw('Message: ${data['errors']} With Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 400) {
      Map data  = json.decode(response.body);
      throw('Message ${data['message']} \n Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if(response.statusCode == 500){
      throw ('Internal server error \n Status Code ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  }catch (e){
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
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
  try {
    final response = await http.post(_apiURL, body: (data), headers: _headers);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List data  = json.decode(response.body);
      return data;
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if(response.statusCode == 404){
      Map data  = json.decode(response.body);
      throw ('Message ${data['message']} \n Status Code:  ${response.statusCode}');
    } else if(response.statusCode == 500){
      
      throw ('Internal server error \n Status Code ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch (e) {
    List data = List();
    data.add({'error': true, 'message': '${e.toString()}'});
    return data; 
  }
}

addBill(BuildContext context, scaffoldKey, _degreeTextFeildController ,  Map dataToSend) async{
  
  Map<String, String> submeterDegree = Map();
  _degreeTextFeildController.forEach((key, value) { 
    submeterDegree.addAll({key : value.text});
  });
  
  dataToSend.addAll(<String, String>{'submeterDegree' : "${json.encode(submeterDegree)}"});

  final _apiConfig  = new API_Config();
  final _apiURL =  _apiConfig.apiUrl('addBillAndSubmeterDegree');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String _access_token = prefs.getString('access_token');
  final Map<String, String> _headers = {                    
                    "Accept": 'application/json',
                    'Authorization': _access_token,
                    };
  dataToSend['user'] = prefs.getString('access_token');

  try {
    var response = await http.post(
      _apiURL,
      body: dataToSend, 
      headers: _headers,
    );
    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey, color: Colors.cyan);
    }else if (response.statusCode == 422){
      Map data = json.decode(response.body);
      throw('Message: ${data['errors']} With Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 400) {
      Map data  = json.decode(response.body);
      throw('Message ${data['message']} \n Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if(response.statusCode == 500){
      Map data = json.decode(response.body);
      throw('Message: Server Internal Error With Status Code:  ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }

       
}

fetchBills() async{ 
  final _apiConfig  = new API_Config();
  final _apiURL =  _apiConfig.apiUrl('fetchBills');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  
  final Map _userData =jsonDecode(prefs.getString('user')); 
  final String _access_token = prefs.getString('access_token');
  final Map<String, String> _headers = {                    
                    "Accept": 'application/json',
                    'Authorization': _access_token,
                    };
  final Map<String, String> data = {'user_id': _userData['user_id'].toString()};
  
  // final response = await http.post(_apiURL, body: (data), headers: _headers);
  
  try {
    final response = await http.post(_apiURL, body: (data), headers: _headers);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List data  = json.decode(response.body);
      return data;
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
      // handleUnauthorizedUser(response, context: null, scaffoldKey: null);
    }else if(response.statusCode == 404){
      Map data  = json.decode(response.body);
      throw ('Message: ${data['message']} \n Status Code:  ${response.statusCode}');
    } else if(response.statusCode == 500){
      
      throw ('Internal server error \n Status Code ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch (e) {
    List data = List();
    data.add({'error': true, 'message': '${e.toString()}'});
    print(e);
    return data; 
  }
  
}



addWaterMeter(BuildContext context, scaffoldKey ,  Map dataToBeSend) async{
  
    final _apiConfig  = new API_Config();
    final _apiURL =  _apiConfig.apiUrl('addWaterMeter');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String _accessToken = prefs.getString('access_token');
    final Map<String, String> _headers = {                    
                      "Accept": 'application/json',
                      'Authorization': _accessToken,
                      };
    dataToBeSend['user'] = prefs.getString('user');
    
  try {
    var response = await http.post(
      _apiURL,
      body: dataToBeSend, 
      headers: _headers,
    );
    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey, color: Colors.cyan);
    }else if(response.statusCode == 400) {
      Map data  = json.decode(response.body);
      throw('Message ${data['message']} \n Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if (response.statusCode == 422){
      Map data = json.decode(response.body);
      throw('Message: ${data['errors']} With Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 500){

      Map data = json.decode(response.body);
      throw('Message: Server Internal Error With Status Code:  ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch (e) {
    return createSnackBar('${e}', context, scaffoldKey, color: Colors.red);
  }
       
}

fetchWaterMeter() async{
  final _apiConfig  = new API_Config();
  final _apiURL =  _apiConfig.apiUrl('fetchWaterMeter');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  
  final Map _userData =jsonDecode(prefs.getString('user')); 
  final String _access_token = prefs.getString('access_token');
  final Map<String, String> _headers = {                    
                    "Accept": 'application/json',
                    'Authorization': _access_token,
                    };
  final Map<String, String> data = {'user_id': _userData['user_id'].toString()};
  
  try {
    final response = await http.post(_apiURL, body: (data), headers: _headers);
    print(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List data  = json.decode(response.body);
      return data;
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if(response.statusCode == 404){
      Map data  = json.decode(response.body);
      throw ('Message: ${data['message']} \n Status Code:  ${response.statusCode}');
    } else if(response.statusCode == 500){
      
      throw ('Internal server error \n Status Code ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch (e) {
    List data = List();
    data.add({'error': true, 'message': '${e.toString()}'});
    return data; 
  }
}

editWaterMeter(context, scaffoldKey, Map<String, dynamic> dataToSend ) async{
  final _apiConfig  = new API_Config();
  final _apiURL =  _apiConfig.apiUrl('editWaterMeter');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String _accessToken = prefs.getString('access_token');
  final Map<String, String> _headers = {                    
                    "Accept": 'application/json',
                    'Authorization': _accessToken,
                    };
    // dataToSend['user'] = prefs.getString('user');
    
  try {
    var response = await http.post(
      _apiURL,
      body: dataToSend, 
      headers: _headers,
    );

    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey, color: Colors.cyan);
    }else if(response.statusCode == 400) {
      Map data  = json.decode(response.body);
      throw('Message ${data['message']} \n Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if (response.statusCode == 422){
      Map data = json.decode(response.body);
      throw('Message: ${data['errors']} With Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 500){

      Map data = json.decode(response.body);
      throw('Message: Internal Server Error With Status Code:  ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}
deleteWaterMeter( context, scaffoldKey, meterID)async{
  final _apiConfig  = new API_Config();
  final _apiURL =  _apiConfig.apiUrl('deleteWaterMeter');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String _accessToken = prefs.getString('access_token');
  final Map<String, String> _headers = {                    
                    "Accept": 'application/json',
                    'Authorization': _accessToken,
                    };
    
  try {
    var response = await http.post(
      _apiURL,
      body: {'id': meterID.toString()}, 
      headers: _headers,
    );

    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey, color: Colors.cyan);
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if (response.statusCode == 422){
      Map data = json.decode(response.body);
      throw('Message: ${data['errors']} With Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 400){

      Map data = json.decode(response.body);
      throw('Message: ${data['message']}');
    }else if(response.statusCode == 500){

      Map data = json.decode(response.body);
      throw('Message: Internal Server Error With Status Code:  ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

changeWaterMeterStatus(context, scaffoldKey, meterID, status)async{
  final _apiConfig  = new API_Config();
  final _apiURL =  _apiConfig.apiUrl('changeWaterMeterStatus');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String _accessToken = prefs.getString('access_token');
  final Map<String, String> _headers = {                    
                    "Accept": 'application/json',
                    'Authorization': _accessToken,
                    };
    
  try {
    var response = await http.post(
      _apiURL,
      body: {'id': meterID.toString(), 'status': status.toString()}, 
      headers: _headers,
    );
    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey, color: Colors.cyan);
    }else if (response.statusCode == 422){
      Map data = json.decode(response.body);
      throw('Message: ${data['errors']} With Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 400){

      Map data = json.decode(response.body);
      throw('Message: ${data['message']}');
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if(response.statusCode == 500){
      Map data = json.decode(response.body);
      throw('Message: Internal Server Error With Status Code:  ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

addWaterNeighbor(context, scaffoldKey, Map dataToSend ) async {
    final _apiConfig  = new API_Config();
    final _apiURL =  _apiConfig.apiUrl('addWaterNeighbor');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String _accessToken = prefs.getString('access_token');
    final Map<String, String> _headers = {                    
                      "Accept": 'application/json',
                      'Authorization': _accessToken,
                      };
    dataToSend['user'] = prefs.getString('user');
  try {
    
    var response = await http.post(
      _apiURL,
      body: dataToSend, 
      headers: _headers,
    );
    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey, color: Colors.cyan);
    }else if(response.statusCode == 400){

      Map data = json.decode(response.body);
      throw('Message: ${data['message']}');
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if (response.statusCode == 422){
      Map data = json.decode(response.body);
      throw('Message: ${data['errors']} With Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 500){

      Map data = json.decode(response.body);
      throw('Message: Server Internal Error With Status Code:  ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch (e) {
    return createSnackBar('${e}', context, scaffoldKey, color: Colors.red);
  }
}

fetchWaterNeighbor() async{
  final _apiConfig  = new API_Config();
  final _apiURL =  _apiConfig.apiUrl('fetchWaterNeighbor');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  
  final Map _userData =jsonDecode(prefs.getString('user')); 
  final String _access_token = prefs.getString('access_token');
  final Map<String, String> _headers = {                    
                    "Accept": 'application/json',
                    'Authorization': _access_token,
                    };
  final Map<String, String> data = {'user_id': _userData['user_id'].toString()};
  
  try {
    final response = await http.post(_apiURL, body: (data), headers: _headers);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List data  = json.decode(response.body);
      return data;
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if(response.statusCode == 404){
      Map data  = json.decode(response.body);
      throw ('Message ${data['message']} \n Status Code:  ${response.statusCode}');
    } else if(response.statusCode == 500){
      
      throw ('Internal server error \n Status Code ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch (e) {
    List data = List();
    data.add({'error': true, 'message': '${e.toString()}'});
    return data; 

  }
}

deleteWaterNeighbor(context, scaffoldKey, neighborID)async{
  final _apiConfig  = new API_Config();
  final _apiURL =  _apiConfig.apiUrl('deleteWaterNeighbor');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String _accessToken = prefs.getString('access_token');
  final Map<String, String> _headers = {                    
                    "Accept": 'application/json',
                    'Authorization': _accessToken,
                    };
  try {
    var response = await http.post(
      _apiURL,
      body: {'id': neighborID.toString()}, 
      headers: _headers,
    );

    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey, color: Colors.cyan);
    }else if (response.statusCode == 422){
      Map data = json.decode(response.body);
      throw('Message: ${data['errors']} With Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 400){

      Map data = json.decode(response.body);
      throw('Message: ${data['message']}');
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if(response.statusCode == 500){
      Map data = json.decode(response.body);
      throw('Message: Internal Server Error \n With Status Code:  ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

addWaterBill(context, scaffoldKey, peopleTextFieldData, dataToSend) async{
  Map<String, String> neighborPeople = Map();
  peopleTextFieldData.forEach((key, value) { 
    neighborPeople.addAll({key : value.text});
  });

  dataToSend.addAll(<String, String>{'neighborPeople' : "${json.encode(neighborPeople)}"});

  final _apiConfig  = new API_Config();
  final _apiURL =  _apiConfig.apiUrl('addWaterBill');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String _access_token = prefs.getString('access_token');
  final Map<String, String> _headers = {                    
                    "Accept": 'application/json',
                    'Authorization': _access_token,
                    };
  dataToSend['user'] = prefs.getString('access_token');

  
  try {
    var response = await http.post(
      _apiURL,
      body: dataToSend, 
      headers: _headers,
    );
    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey, color: Colors.cyan);
    }else if (response.statusCode == 422){
      Map data = json.decode(response.body);
      throw('Message: ${data['errors']} With Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 400){

      Map data = json.decode(response.body);
      throw('Message: ${data['message']}');
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if(response.statusCode == 500){

      Map data = json.decode(response.body);
      throw('Message: Internal Server Error \n With Status Code:  ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }

}

fetchWaterBill()async{
  final _apiConfig  = new API_Config();
  final _apiURL =  _apiConfig.apiUrl('fetchWaterBills');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  
  final Map _userData =jsonDecode(prefs.getString('user')); 
  final String _access_token = prefs.getString('access_token');
  final Map<String, String> _headers = {                    
                    "Accept": 'application/json',
                    'Authorization': _access_token,
                    };
  final Map<String, String> data = {'user_id': _userData['user_id'].toString()};
  
  try {
    final response = await http.post(_apiURL, body: (data), headers: _headers);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List data  = json.decode(response.body);
      return data;
    }else if(response.statusCode == 404){
      Map data  = json.decode(response.body);
      throw ('Message ${data['message']} \n Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if(response.statusCode == 500){
      
      throw ('Internal server error \n Status Code ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch (e) {
    List data = List();
    data.add({'error': true, 'message': '${e.toString()}'});
    return data; 

  }
}

confirm(context, scaffoldKey, confirmationCode) async {
  final _apiConfig  = new API_Config();
  final _apiURL =  _apiConfig.apiUrl('checkConfirmationCode');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  
  final Map _userData =jsonDecode(prefs.getString('user')); 
  final String _access_token = prefs.getString('access_token');
  final Map<String, String> _headers = {                    
                    "Accept": 'application/json',
                    'Authorization': _access_token,
                    };
  final Map<String, String> dataToSend = {'user_id': _userData['user_id'].toString(), 'confirmation_code': confirmationCode.toString()};

  try {
    var response = await http.post(
      _apiURL,
      body: dataToSend, 
      headers: _headers,
    );
    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      return 'confirmed';
    }else if (response.statusCode == 422){
      Map data = json.decode(response.body);
      throw('Message: ${data['errors']} With Status Code:  ${response.statusCode}');
    }else if(response.statusCode == 400){

      Map data = json.decode(response.body);
      throw('Message: ${data['message']}');
    }else if(response.statusCode == 401){
      NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
    }else if(response.statusCode == 500){

      Map data = json.decode(response.body);
      throw('Message: Internal Server Error \n With Status Code:  ${response.statusCode}');
    }else{
      throw('Message: Unkown Error Status Code:  ${response.statusCode}');
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }



}