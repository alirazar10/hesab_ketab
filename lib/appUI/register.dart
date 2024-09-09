import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hesab_ketab/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/api_config.dart';
import '../utils/navigationService.dart';
// import '../utils/cookies.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  static final _emailRegex =
      RegExp(r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$");

  String? _email;
  String? _password;
  String? _confirmPassword;
  bool _isLoading = false;

  final String _policyLink =
      'https://sites.google.com/view/hesabketab-at-imorgroup/home';

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _email = _emailController.text.trim().toLowerCase();
      _password = _passwordController.text.trim();
      _confirmPassword = _confirmPasswordController.text.trim();
    });

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    final apiConfig = API_Config();
    final uri = Uri.parse(apiConfig.apiUrl('register'));

    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": 'application/json',
        },
        body: json.encode({
          "username": _email,
          "email": _email,
          "password": _password,
          "password_confirmation": _confirmPassword,
        }),
      );

      if (response.statusCode == 202) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', json.encode(data['user']));
        final cookies = response.headers['set-cookie'];

        if (cookies != null) {
          print('Cookies: $cookies');

          // Parse the cookie string if needed
          final cookieMap = parseCookies(cookies);
          setTokens(prefs, cookieMap['accessToken'], cookieMap['refreshToken']);
        }
        NavigationService.instance.navigateTo('/confirmEmail');
      } else {
        final data = json.decode(response.body);
        _showSnackBar(data['message'] ?? 'Registration failed.');
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

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(url as Uri)) {
      _showSnackBar('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xF0FFFFFF),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/logo/logo_no_txt.png"),
            fit: BoxFit.cover,
          ),
        ),
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
                const Divider(
                  thickness: 2.0,
                  color: Color(0xFFFF5722),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textDirection: TextDirection.ltr,
                  decoration: const InputDecoration(
                    labelText: "ایمیل",
                    prefixIcon: Icon(Icons.email, color: Color(0xFF212121)),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "ایمیل را وارد نمایید";
                    }
                    if (!_emailRegex.hasMatch(value)) {
                      return 'ایمیل شما درست نمی‌باشد';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  textDirection: TextDirection.ltr,
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "پسورد",
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF212121)),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'پسورد را وارد نمایید';
                    }
                    if (value.length < 6) {
                      return 'تعداد حروف پسورد باید بیشتر از ۵ باشد';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  textDirection: TextDirection.ltr,
                  obscureText: true,
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: "تکرار پسورد",
                    prefixIcon:
                        Icon(Icons.lock_outline, color: Color(0xFF212121)),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'تکرار پسورد را وارد نمایید';
                    }
                    if (value != _confirmPasswordController.text) {
                      return 'تکرار پسورد با پسورد باید یکسان باشد';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      const TextSpan(text: 'با استفاده از برنامه ما، شما با '),
                      TextSpan(
                        text: 'شرایط استفاده',
                        style: TextStyle(
                          color: Colors.blue.shade400,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _launchURL(_policyLink),
                      ),
                      const TextSpan(text: ' و '),
                      TextSpan(
                        text: 'سیاست حفظ حریم خصوصی',
                        style: TextStyle(
                          color: Colors.blue.shade400,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _launchURL(_policyLink),
                      ),
                      const TextSpan(text: ' موافقت می‌کنید.'),
                    ],
                  ),
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
                            onPressed: _register,
                            child: const Text(
                              'راجستر',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              NavigationService.instance.navigateTo('/login');
                            },
                            child: const Text(
                              'ورود به حساب',
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
