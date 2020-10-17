import 'package:flutter/material.dart';

// ignore: camel_case_types
class API_Config {
    apiUrl (String urlKey){
    Map urlMap = {
      "login": "http://192.168.1.108:8000/api/login",
      "resgister": "http://192.168.1.108:8000/api/registration",
      "logout": "http://192.168.1.108:8000/api/logout",
      'addMainMeter': "http://192.168.1.108:8000/api/addmainmeter",
      'fetchMainMeters': "http://192.168.1.108:8000/api/fetchmainmeters",
      'editMainMeter': "http://192.168.1.108:8000/api/editmainmeter",
      'changeStatusMainMeters': "http://192.168.1.108:8000/api/changestatusmainmeters",
      
      'deleteMainMeter': "http://192.168.1.108:8000/api/deletemainmeter",
      'addSubMeters' : "http://192.168.1.108:8000/api/addsubmeters",
      'fetchSubmeters' : "http://192.168.1.108:8000/api/fetchsubmeters",
      'deleteSubmeter' : "http://192.168.1.108:8000/api/deletesubmeter",
      'addBillAndSubmeterDegree' : "http://192.168.1.108:8000/api/addbillandsubmeterdegree",

    };
    print(urlMap[urlKey]);
    return urlMap[urlKey];
  }
}