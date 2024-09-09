import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hesab_ketab/utils/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'navigationService.dart';

// Helper function to get API URL
String getApiUrl(String endpoint) {
  final _apiConfig = API_Config();
  return _apiConfig.apiUrl(endpoint);
}

// Helper function to get shared preferences
Future<SharedPreferences> getSharedPreferences() async {
  return await SharedPreferences.getInstance();
}

// Helper function to get user data
Future<Map> getUserData(SharedPreferences prefs) async {
  final String? user = prefs.getString('user');
  return jsonDecode(user as String);
}

// Helper function to get headers
Future<Map<String, String>> getHeaders(SharedPreferences prefs) async {
  final String? accessToken = prefs.getString('accessToken');
  print(prefs.getKeys());
  return {
    "Accept": 'application/json',
    'Authorization': accessToken as String,
  };
}

// Helper function for handling HTTP responses
dynamic handleHttpResponse(
    http.Response response, BuildContext? context, scaffoldKey) {
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return json.decode(response.body);
  } else if (response.statusCode == 401) {
    NavigationService.instance.navigateToRemoveUntil('/unAuthUser');
  } else if (response.statusCode == 404 ||
      response.statusCode == 400 ||
      response.statusCode == 422) {
    Map data = json.decode(response.body);
    throw ('${data['message']} \n ${response.statusCode}');
  } else if (response.statusCode == 500) {
    throw ('Internal server error \n Status Code ${response.statusCode}');
  } else {
    throw ('Unknown Error Status Code:  ${response.statusCode}');
  }
}

// Function to parse cookies
Map<String, String> parseCookies(String rawCookie) {
  final cookies = <String, String>{};
  if (rawCookie.isNotEmpty) {
    rawCookie.split(',').forEach((cookie) {
      final cookieParts = cookie.split(';').first.split('=');
      if (cookieParts.length == 2) {
        cookies[cookieParts[0].trim()] = cookieParts[1];
      }
    });
  }
  return cookies;
}

setTokens(
    SharedPreferences prefs, String? accessToken, String? refreshToken) async {
  await prefs.setString('accessToken', accessToken!);
  await prefs.setString('refreshToken', refreshToken!);
}
