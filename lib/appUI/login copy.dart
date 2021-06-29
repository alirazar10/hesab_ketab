import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hesab_ketab/appUI/home.dart';
import 'package:http/http.dart' as http;
import '../utils/api_config.dart';
import 'home.dart';
import 'dart:convert';
import 'hesab_ketab.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _username;
  String _password;
  static String p = r"^[a-zA-Z0-9._-][^<>!#$%&'*+\/=?^`{|}~]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
  RegExp  _validEmail = RegExp(p);
  void login() async {
    var apiConfig = new API_Config();
    var response = await http.post(
      apiConfig.apiUrl('login'),
      body: {
        "username": this._username,
        "password": this._password,
      },
      headers: {
        "Accept": 'application/json'
      },
    );
    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HesabKetab(userData: data)));
    }else{
      Map data = json.decode(response.body);
      // set up the AlertDialog
      // Alert(context: context, title: "Error", desc: data['message']).show();
      Alert(
        context: context,
        type: AlertType.error,
        title: "message",
        desc: data['message'],
        buttons: [
        DialogButton(
          child: Text(
            "Close",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
        ],
      ).show();
      print( data['message']);
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(20.0),
                
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        // color: const Color(0xff00BCD4), 
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff00BCD4),
                          
                        ),
                        child: Text('ورود به سیستم', textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 20.0, 
                          ),
                        ),
                      ),
                      TextFormField(
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    labelText: 'ایمیل: ',
                    prefixIcon: Icon(Icons.email, color: Color(0xFF212121)),
                    labelStyle: TextStyle(color: Color(0xFFFF5722))
                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return 'ایمیل تان را وارید نمایید';
                    }
                    bool isEmail = _validEmail.hasMatch(value);
                    if( !isEmail){
                      return 'ایمیل شما درست نمیباشد.$value';
                    }
                  },
                  onSaved: (String value) {
                    this._username = value.trim();
                  },
                ),
                SizedBox(height: 10,),
                TextFormField(
                  textDirection: TextDirection.ltr,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'پسورد: ',
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF212121)),
                    labelStyle: TextStyle(color: Color(0xFFFF5722))
                  ),
                  // ignore: missing_return
                  validator: (value){
                    if(value.isEmpty){
                      return 'پسورد تان را وارید نمایید';
                    }
                    if(value.length < 6){
                      return 'تعداد حروف پسورد باید بیشتر از 5 حروف باشد ';
                    }
                  },
                  onSaved: (String value) {
                    this._password = value;
                  },
                ),
                Container(
                  padding: EdgeInsets.only(top:10.0),
                  child: RaisedButton(
                    padding: EdgeInsets.all(10),
                    color: Color(0xFFFF5722),
                    child: Text('ورود', ),
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        _formKey.currentState.save();
                        login();

                      }
                    }
                  ),
                ),
                    ],
                  )
                )
              ),
            ],
          ),
        ),
      
    );
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _regFromKey = GlobalKey<FormState>();
  static String p = r"^[a-zA-Z0-9._-][^<>!#$%&'*+\/=?^`{|}~]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
  RegExp _validEmail = RegExp(p);
  String _firstName;
  String _lastName;
  String _email;
  String _password;
  String _confirm_password;
  void registration() async {
    var apiConfig = new API_Config();
    var response = await http.post(
      apiConfig.apiUrl('resgister'),
      body: {
        "username": this._email,
        "password": this._password,
        "password_confirmation":this._confirm_password
      },
      headers: {
        "Accept": 'application/json',
      }
    );
    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => HesabKetab(userData: data)),(Route<dynamic> route) => false
        // ModalRoute.withName("/HesabKetab") 
      );
    }else{
      Map data = json.decode(response.body);
      // set up the AlertDialog
      Alert(context: context, title: "RFLUTTER", desc:  data['errors']['username'][0]).show();
      print( data['errors']['username'][0]);
        
    }
  }


  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        // resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
      // color: Colors.transparent,
        body: Form(
          key: _regFromKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(  
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      // color: const Color(0xff00BCD4), 
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff00BCD4),
                        
                      ),
                      child: Text('حساب جدید ایجاد نمایید! ', textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 20.0, 
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: "ایمیل: ",
                        // prefixIcon: Icon(Icons.lock, color: Color(0xFF212121)),
                        labelStyle: TextStyle(color: Color(0xFFFF5722))
                      ),
                      // ignore: missing_return
                      validator: (value){
                        if(value.isEmpty){
                          return "ایمیل را وارد نمایید"; 
                        }
                        bool isEmail = _validEmail.hasMatch(value);
                        if(!isEmail){
                          return 'ایمیل شما درست نمیباشد.$value';
                        }
                      },
                      onChanged: (String value) {
                        this._email = value.trim().toLowerCase();
                      },
                    ),
                    
                    SizedBox(height: 10,),
                    TextFormField(
                      textDirection: TextDirection.ltr,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "پسورد: ",
                        // prefixIcon: Icon(Icons.lock, color: Color(0xFF212121)),
                        labelStyle: TextStyle(color: Color(0xFFFF5722))
                      ),
                      // ignore: missing_return
                      validator: (value){
                        if(value.isEmpty){
                          return 'پسورد را وارید نمایید';
                        }
                        if(value.length < 6){
                          return 'تعداد حروف پسورد باید بیشتر از 5 حروف باشد ';
                        }
                      },
                      onChanged: (value){
                        this._password = value;
                      },
                      onSaved: (value) {
                        this._password = value;
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      textDirection: TextDirection.ltr,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "تکرار پسورد: ",
                        // prefixIcon: Icon(Icons.lock, color: Color(0xFF212121)),
                        labelStyle: TextStyle(color: Color(0xFFFF5722))
                      ),
                      // ignore: missing_return
                      validator: (value){
                        if(value.isEmpty){
                          return 'پسورد را وارید نمایید';
                        }
                        if(value.length < 6){
                          return 'تعداد حروف پسورد باید بیشتر از 5 حروف باشد ';
                        }
                        if(value != _password){
                          return 'تکرار پسورد با پسورد باید یکسان باشد.';
                        }
                      },
                      onSaved: (value) {
                        this._confirm_password = value;
                      },
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.only(top:10.0),
                      child: RaisedButton(
                        padding: EdgeInsets.all(10),
                        color: Color(0xFFFF5722),
                        child: Text('ورود', ),
                        onPressed: (){
                          if(_regFromKey.currentState.validate()){
                            _regFromKey.currentState.save();
                            registration();

                          }
                        }
                      ),
                    ),
                    // Expanded
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    Container(
                      child: Text('By Registering you are agreeing Term of use and Policy'),
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }
}