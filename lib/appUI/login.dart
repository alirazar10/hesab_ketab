import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api_config.dart';
import '../utils/navigationService.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _password;

  static final _emailRegex =
      RegExp(r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$");

  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    final apiConfig = API_Config();
    final uri = Uri.parse(apiConfig.apiUrl('login'));

    try {
      final response = await http.post(uri,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": 'application/json',
          },
          body: json.encode({
            "email": _username,
            "password": _password,
          }));
      print({'response', response.headers});
      if (response.statusCode == 202) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', json.encode(data['user']));
        await prefs.setString('accessToken', data['accessToken']);
        // NavigationService.instance
        //     .navigateToRemoveUntil('/hesabKetab', arguments: data);
        print({'loginSuccess', response.body});
      } else {
        final data = json.decode(response.body);
        print({'failed', response.statusCode});
        _showSnackBar(data['message'] ?? 'Authentication failed.');
      }
    } catch (e) {
      print(e);
      _showSnackBar('An error occurred. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      elevation: 6.0,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xF0FFFFFF),
      body: Container(
        alignment: Alignment.center,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/logo/logo_no_txt.png"),
        //     fit: BoxFit.contain,
        //   ),
        // ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.08),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Image(
                  image: AssetImage(
                      "assets/images/logo/Hesab_ketab_Farsi_Logo.png"),
                  height: 100.0,
                ),
                const SizedBox(height: 20),
                const Text(
                  'ورود به حساب',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
                const Divider(
                  thickness: 2.0,
                  color: Color(0xff00BCD4),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  textDirection: TextDirection.ltr,
                  decoration: const InputDecoration(
                    labelText: 'ایمیل',
                    prefixIcon: Icon(Icons.email, color: Color(0xFF212121)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ایمیل تان را وارد نمایید';
                    }
                    if (!_emailRegex.hasMatch(value)) {
                      return 'ایمیل شما درست نمی‌باشد';
                    }
                    return null;
                  },
                  onSaved: (value) => _username = value!.trim(),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  textDirection: TextDirection.ltr,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'پسورد',
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF212121)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'پسورد تان را وارد نمایید';
                    }
                    if (value.length < 6) {
                      return 'تعداد حروف پسورد باید بیشتر از ۵ باشد';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!.trim(),
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              backgroundColor: const Color(0xFFFF5722),
                            ),
                            onPressed: _login,
                            child: const Text(
                              'ورود',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              NavigationService.instance
                                  .navigateTo('/register');
                            },
                            child: const Text(
                              'حساب جدید',
                              style: TextStyle(
                                color: Color(0xff00BCD4),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// //////////////////////////////////////////////////////////////////

