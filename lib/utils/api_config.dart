import 'package:flutter/material.dart';

// ignore: camel_case_types
class API_Config {
    apiUrl (String urlKey){
    Map urlMap = {
      "login": "http://10.0.2.2:8000/api/login",
      "resgister": "http://10.0.2.2:8000/api/registration",
      "logout": "http://10.0.2.2:8000/api/logout",
    };
    print(urlMap[urlKey]);
    return urlMap[urlKey];
  }
}