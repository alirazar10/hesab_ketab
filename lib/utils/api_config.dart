// ignore: camel_case_types
class API_Config {
  apiUrl(String urlKey) {
    final LOCAL_URL_NAME = "http://192.168.0.106:3000/api/";
    final REMOTE_URL_NAME = "https://hk.imali.dev/api/";
    final API_URL = REMOTE_URL_NAME;
    Map urlMap = {
      "login": API_URL + "auth/authenticate",
      "register": API_URL + "auth/signup",
      'checkConfirmationCode': API_URL + "auth/verify",
      'resendConfirmationCode': API_URL + "auth/verify/resendCode",
      "signout": API_URL + "auth/signout",
      'addMainMeter': API_URL + "addmainmeter",
      'fetchMainMeters': API_URL + "fetchmainmeters",
      'editMainMeter': API_URL + "editmainmeter",
      'changeStatusMainMeters': API_URL + "changestatusmainmeters",
      'deleteMainMeter': API_URL + "deletemainmeter",
      'addSubMeters': API_URL + "addsubmeters",
      'fetchSubmeters': API_URL + "fetchsubmeters",
      'deleteSubmeter': API_URL + "deletesubmeter",
      'addBillAndSubmeterDegree': API_URL + "addbillandsubmeterdegree",
      'fetchBills': API_URL + "fetchbills",
      'addWaterMeter': API_URL + "addwatermeter",
      'fetchWaterMeter': API_URL + "fetchwatermeter",
      'editWaterMeter': API_URL + "editwatermeter",
      'deleteWaterMeter': API_URL + "deletewatermeter",
      'changeWaterMeterStatus': API_URL + "changewatermeterstatus",
      'addWaterNeighbor': API_URL + "addwaterneighbor",
      'fetchWaterNeighbor': API_URL + "fetchwaterneighbor",
      'deleteWaterNeighbor': API_URL + "deletewaterneighbor",
      'addWaterBill': API_URL + "addwaterbill",
      'fetchWaterBills': API_URL + "fetchwaterbills",
    };
    return urlMap[urlKey];
  }
}
