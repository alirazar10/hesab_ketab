import 'package:flutter/material.dart';

// ignore: camel_case_types
class API_Config {
    apiUrl (String urlKey){
    Map urlMap = {
      // "login": "http://192.168.254.25:8000/api/login",
      // "resgister": "http://192.168.254.25:8000/api/registration",
      // 'checkConfirmationCode' : "http://192.168.254.25:8000/api/checkconfirmationcode",

      // "logout": "http://192.168.254.25:8000/api/logout",
      // 'addMainMeter': "http://192.168.254.25:8000/api/addmainmeter",
      // 'fetchMainMeters': "http://192.168.254.25:8000/api/fetchmainmeters",
      // 'editMainMeter': "http://192.168.254.25:8000/api/editmainmeter",
      // 'changeStatusMainMeters': "http://192.168.254.25:8000/api/changestatusmainmeters",
      
      // 'deleteMainMeter': "http://192.168.254.25:8000/api/deletemainmeter",
      // 'addSubMeters' : "http://192.168.254.25:8000/api/addsubmeters",
      // 'fetchSubmeters' : "http://192.168.254.25:8000/api/fetchsubmeters",
      // 'deleteSubmeter' : "http://192.168.254.25:8000/api/deletesubmeter",
      // 'addBillAndSubmeterDegree' : "http://192.168.254.25:8000/api/addbillandsubmeterdegree",
      // 'fetchBills' : "http://192.168.254.25:8000/api/fetchbills",
      // 'addWaterMeter' : "http://192.168.254.25:8000/api/addwatermeter",
      // 'fetchWaterMeter' : "http://192.168.254.25:8000/api/fetchwatermeter",
      // 'editWaterMeter' : "http://192.168.254.25:8000/api/editwatermeter",
      // 'deleteWaterMeter' : "http://192.168.254.25:8000/api/deletewatermeter",
      // 'changeWaterMeterStatus' : "http://192.168.254.25:8000/api/changewatermeterstatus",
      // 'addWaterNeighbor' : "http://192.168.254.25:8000/api/addwaterneighbor",
      // 'fetchWaterNeighbor' : "http://192.168.254.25:8000/api/fetchwaterneighbor",
      // 'deleteWaterNeighbor' : "http://192.168.254.25:8000/api/deletewaterneighbor",
      // 'addWaterBill' : "http://192.168.254.25:8000/api/addwaterbill",
      // 'fetchWaterBills' : "http://192.168.254.25:8000/api/fetchwaterbills",
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
      'fetchWaterBills' : "https://hk.imorgroup.com/api/fetchwaterbills",
    };
    print(urlMap[urlKey]);
    return urlMap[urlKey];
  }
}