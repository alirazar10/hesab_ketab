import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:hesab_ketab/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'navigationService.dart';

logout(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) async {
  final prefs = await getSharedPreferences();
  final userData = await getUserData(prefs);
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('signout');
  print(userData);

  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {'user_id': userData['id'].toString()},
      headers: headers,
    );

    handleHttpResponse(response, context, scaffoldKey);

    if (response.statusCode == 202) {
      prefs.remove('user');
      prefs.remove('accessToken');
      NavigationService.instance.navigateToRemoveUntil('/login');
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

fetchMainMeters() async {
  final prefs = await getSharedPreferences();
  final userData = await getUserData(prefs);
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('fetchMainMeters');

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'user_id': userData['id'].toString()},
      headers: headers,
    );
    return handleHttpResponse(response, null, null);
  } catch (e) {
    return [
      {'error': true, 'message': '$e'}
    ];
  }
}

changeMainMeterStatus(BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey, String meterID, int status) async {
  final prefs = await getSharedPreferences();
  final userData = await getUserData(prefs);
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('changeStatusMainMeters');

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'user_id': userData['id'].toString(),
        'id': meterID,
        'status': status,
      },
      headers: headers,
    );

    handleHttpResponse(response, context, scaffoldKey);

    if (response.statusCode == 201) {
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey);
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

addSubMeters(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
    {String? meterID,
    String? submeterConsumer,
    String? meterDegree,
    DateTime? date}) async {
  final prefs = await getSharedPreferences();
  final userData = prefs.getString('user');
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('addSubMeters');

  final mainMeterData = {
    'mainmeter_id': meterID,
    'submeter_consumer': submeterConsumer,
    'meter_degree': meterDegree,
    'date': date.toString(),
    'user': userData,
  };

  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: mainMeterData,
      headers: headers,
    );

    handleHttpResponse(response, context, scaffoldKey);

    if (response.statusCode == 201) {
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey);
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

fetchSubmeter() async {
  final prefs = await getSharedPreferences();
  final userData = await getUserData(prefs);
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('fetchSubmeters');

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'user_id': userData['id'].toString()},
      headers: headers,
    );
    return handleHttpResponse(response, null, null);
  } catch (e) {
    return [
      {'error': true, 'message': '$e'}
    ];
  }
}

addBill(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
    Map<String, TextEditingController> degreeTextFieldController,
    Map<String, String> dataToSend) async {
  Map<String, String> submeterDegree = {};
  degreeTextFieldController.forEach((key, value) {
    submeterDegree[key] = value.text;
  });

  dataToSend['submeterDegree'] = json.encode(submeterDegree);

  final prefs = await getSharedPreferences();
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('addBillAndSubmeterDegree');
  dataToSend['user'] = prefs.getString('access_token') as String;

  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: dataToSend,
      headers: headers,
    );

    handleHttpResponse(response, context, scaffoldKey);

    if (response.statusCode == 201) {
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey,
          color: Colors.cyan);
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

fetchBills() async {
  final prefs = await getSharedPreferences();
  final userData = await getUserData(prefs);
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('fetchBills');

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'user_id': userData['id'].toString()},
      headers: headers,
    );
    return handleHttpResponse(response, null, null);
  } catch (e) {
    return [
      {'error': true, 'message': '$e'}
    ];
  }
}

addWaterMeter(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
    Map<String, dynamic> dataToSend) async {
  final prefs = await getSharedPreferences();
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('addWaterMeter');
  dataToSend['user'] = prefs.getString('user') as String;

  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: dataToSend,
      headers: headers,
    );

    handleHttpResponse(response, context, scaffoldKey);

    if (response.statusCode == 201) {
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey,
          color: Colors.cyan);
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

fetchWaterMeter() async {
  final prefs = await getSharedPreferences();
  final userData = await getUserData(prefs);
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('fetchWaterMeter');

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'user_id': userData['id'].toString()},
      headers: headers,
    );
    return handleHttpResponse(response, null, null);
  } catch (e) {
    return [
      {'error': true, 'message': '$e'}
    ];
  }
}

editWaterMeter(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
    Map<String, dynamic> dataToSend) async {
  final prefs = await getSharedPreferences();
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('editWaterMeter');
  dataToSend['user'] = prefs.getString('user') as String;

  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: dataToSend,
      headers: headers,
    );

    handleHttpResponse(response, context, scaffoldKey);

    if (response.statusCode == 201) {
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey,
          color: Colors.cyan);
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

deleteWaterMeter(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
    int meterID) async {
  final prefs = await getSharedPreferences();
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('deleteWaterMeter');

  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {'id': meterID},
      headers: headers,
    );

    handleHttpResponse(response, context, scaffoldKey);

    if (response.statusCode == 201) {
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey);
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

changeWaterMeterStatus(BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey, String meterID, int status) async {
  final prefs = await getSharedPreferences();
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('changeWaterMeterStatus');

  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'id': meterID,
        'status': status,
      },
      headers: headers,
    );

    handleHttpResponse(response, context, scaffoldKey);

    if (response.statusCode == 201) {
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey);
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

addWaterNeighbor(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
    Map<String, dynamic> dataToSend) async {
  final prefs = await getSharedPreferences();
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('addWaterNeighbor');
  dataToSend['user'] = prefs.getString('user') as String;

  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: dataToSend,
      headers: headers,
    );

    handleHttpResponse(response, context, scaffoldKey);

    if (response.statusCode == 201) {
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey,
          color: Colors.cyan);
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

fetchWaterNeighbor() async {
  final prefs = await getSharedPreferences();
  final userData = await getUserData(prefs);
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('fetchWaterNeighbor');

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'user_id': userData['id'].toString()},
      headers: headers,
    );
    return handleHttpResponse(response, null, null);
  } catch (e) {
    return [
      {'error': true, 'message': '$e'}
    ];
  }
}

deleteWaterNeighbor(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
    int neighborID) async {
  final prefs = await getSharedPreferences();
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('deleteWaterNeighbor');

  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {'id': neighborID},
      headers: headers,
    );

    handleHttpResponse(response, context, scaffoldKey);

    if (response.statusCode == 201) {
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey);
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

addWaterBill(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
    Map<String, TextEditingController> peopleTextFieldData,
    Map<String, dynamic> dataToSend) async {
  final prefs = await getSharedPreferences();
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('addWaterBill');
  dataToSend['user'] = prefs.getString('user') as String;
  Map<String, String> neighborPeople = Map();
  peopleTextFieldData.forEach((key, value) {
    neighborPeople.addAll({key: value.text});
  });

  dataToSend.addAll(
      <String, String>{'neighborPeople': "${json.encode(neighborPeople)}"});

  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: dataToSend,
      headers: headers,
    );

    handleHttpResponse(response, context, scaffoldKey);

    if (response.statusCode == 201) {
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey,
          color: Colors.cyan);
    }
  } catch (e) {
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

fetchWaterBill() async {
  final prefs = await getSharedPreferences();
  final userData = await getUserData(prefs);
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('fetchWaterBill');

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'user_id': userData['id'].toString()},
      headers: headers,
    );
    return handleHttpResponse(response, null, null);
  } catch (e) {
    return [
      {'error': true, 'message': '$e'}
    ];
  }
}

confirm(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
    confirmationCode) async {
  final prefs = await getSharedPreferences();
  final userData = await getUserData(prefs);
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('checkConfirmationCode');
  final Map<String, String> dataToSend = {
    'userId': userData['id'].toString(),
    'confirmation_code': confirmationCode.toString()
  };
  print(json.encode(dataToSend.toString()));

  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode(dataToSend),
      headers: headers,
    );

    handleHttpResponse(response, context, scaffoldKey);

    if (response.statusCode == 202) {
      Map data = json.decode(response.body);
      return 'confirmed';
    }
  } catch (e) {
    print(e);
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}

resendConfirmationsCode(
    BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) async {
  final prefs = await getSharedPreferences();
  final userData = await getUserData(prefs);
  final headers = await getHeaders(prefs);
  final apiUrl = getApiUrl('resendConfirmationCode');
  final Map<String, String> dataToSend = {
    'userId': userData['id'].toString(),
    'email': userData['email'].toString(),
  };
  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode(dataToSend),
      headers: headers,
    );

    handleHttpResponse(response, context, scaffoldKey);

    if (response.statusCode == 202) {
      Map data = json.decode(response.body);
      return createSnackBar(data['message'], context, scaffoldKey);
    }
  } catch (e) {
    print(e);
    return createSnackBar('$e', context, scaffoldKey, color: Colors.red);
  }
}
