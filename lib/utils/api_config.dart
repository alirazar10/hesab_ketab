import 'package:flutter/material.dart';

// ignore: camel_case_types
class API_Config {
    apiUrl (String urlKey){
    Map urlMap = {
      "login": "http://hk.imorgroup.com/api/login",
      "resgister": "http://hk.imorgroup.com/api/registration",
      'checkConfirmationCode' : "http://hk.imorgroup.com/api/checkconfirmationcode",

      "logout": "http://hk.imorgroup.com/api/logout",
      'addMainMeter': "http://hk.imorgroup.com/api/addmainmeter",
      'fetchMainMeters': "http://hk.imorgroup.com/api/fetchmainmeters",
      'editMainMeter': "http://hk.imorgroup.com/api/editmainmeter",
      'changeStatusMainMeters': "http://hk.imorgroup.com/api/changestatusmainmeters",
      
      'deleteMainMeter': "http://hk.imorgroup.com/api/deletemainmeter",
      'addSubMeters' : "http://hk.imorgroup.com/api/addsubmeters",
      'fetchSubmeters' : "http://hk.imorgroup.com/api/fetchsubmeters",
      'deleteSubmeter' : "http://hk.imorgroup.com/api/deletesubmeter",
      'addBillAndSubmeterDegree' : "http://hk.imorgroup.com/api/addbillandsubmeterdegree",
      'fetchBills' : "http://hk.imorgroup.com/api/fetchbills",
      'addWaterMeter' : "http://hk.imorgroup.com/api/addwatermeter",
      'fetchWaterMeter' : "http://hk.imorgroup.com/api/fetchwatermeter",
      'editWaterMeter' : "http://hk.imorgroup.com/api/editwatermeter",
      'deleteWaterMeter' : "http://hk.imorgroup.com/api/deletewatermeter",
      'changeWaterMeterStatus' : "http://hk.imorgroup.com/api/changewatermeterstatus",
      'addWaterNeighbor' : "http://hk.imorgroup.com/api/addwaterneighbor",
      'fetchWaterNeighbor' : "http://hk.imorgroup.com/api/fetchwaterneighbor",
      'deleteWaterNeighbor' : "http://hk.imorgroup.com/api/deletewaterneighbor",
      'addWaterBill' : "http://hk.imorgroup.com/api/addwaterbill",
      'fetchWaterBills' : "http://hk.imorgroup.com/api/fetchwaterbills",

    };
    print(urlMap[urlKey]);
    return urlMap[urlKey];
  }
}