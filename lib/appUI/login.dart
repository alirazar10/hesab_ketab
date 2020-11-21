import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_config.dart';
import 'dart:convert';
import 'hesab_ketab.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _loginScaffoldGlobalKye = GlobalKey<ScaffoldState>();
  BuildContext scaffoldContext;
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
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": 'application/json',
      },
    );
    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.remove('users');
      prefs.setString('user', json.encode(data['user']));
      prefs.setString('access_token', data['access_token']);
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(
          builder: (context) => HesabKetab(userData: data)
        ),
        (Route<dynamic> route) => false
      );
    }else{
      Map data = json.decode(response.body);
      
      // set up the AlertDialog
      // Alert(context: context, title: "Error", desc: data['message']).show();
      
      return createSnackBar(data['message']);
      
    }
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scaffoldContext = context;
    return Scaffold(
      key: _loginScaffoldGlobalKye,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/logo/logo_no_txt.png"),
              fit: BoxFit.contain,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.08,
                      top: MediaQuery.of(context).size.width * 0.08,
                      right: MediaQuery.of(context).size.width * 0.08,
                      bottom:  MediaQuery.of(context).size.width * 0.08),
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
               
                
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
                          
                        ),
                        child: Text('ورود به حساب', textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 25.0, 
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 5.0,
                        color: const Color(0xff00BCD4),
                      ),
                      SizedBox(height: 10,),

                      TextFormField(
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          labelText: 'ایمیل: ',
                          prefixIcon: Icon(Icons.email, color: Color(0xFF212121)),
                          labelStyle: TextStyle(color: Color(0xFFFF5722))
                        ),
                        // ignore: missing_return
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
                      SizedBox(height: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top:20.0),
                            child: RaisedButton(
                              padding: EdgeInsets.all(10),
                              color: Color(0xFFFF5722),
                              child: Text('ورود', style: myTextStyle( color: Colors.white, fontSize: 15.0),),
                              onPressed: (){
                                if(_formKey.currentState.validate()){
                                  _formKey.currentState.save();
                                  login();

                                }
                              }
                            ),
                          ),
                          InkWell(
                            onTap: () {                          
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top:20.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFFF5722), width:2.0),
                                borderRadius: BorderRadius.circular(3.0),
                                color: Colors.transparent,
                              ),
                              child: Text(
                                'حساب جدید ',
                                style: myTextStyle( color: Color(0xff00BCD4), fontSize: 15.0),
                              )
                            ),
                          ),
                          
                        ],
                      ),
                    ],
                  )
                )
              ),
            ],
          ),
        ),
      ),
    ); 
  }

  void createSnackBar(String message) {                                                                               
    final snackBar = new SnackBar(
      content: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Text(message)
      ),                                                         
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      elevation: 6.0,
    );                                                                                      

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!                                            
    _loginScaffoldGlobalKye.currentState.showSnackBar(snackBar);                                                              
  } 
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _regFromKey = GlobalKey<FormState>();
  final _registerScaffoldGlobalKye = GlobalKey<ScaffoldState>();
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
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": 'application/json',
      }
    );
    if(response.statusCode == 201){
      Map data = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user', json.encode(data['user']));
      prefs.setString('access_token', data['access_token']);

      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(
          builder: (context) => HesabKetab(userData: data)
        ),
        (Route<dynamic> route) => false
        // ModalRoute.withName("/HesabKetab") 
      );
    }else{
      Map data = json.decode(response.body);
      // set up the AlertDialog
      // Alert(context: context, title: "Error", desc:  data['errors']['username'][0]).show();
      return createSnackBar(data['message']);
      
        
    }
  }

 
  void initState() {
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final _veiwInset = MediaQuery.of(context).viewInsets.bottom;
    
    return Scaffold(
      key: _registerScaffoldGlobalKye,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/logo/logo_no_txt.png"),
              fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Form(
                key: _regFromKey,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xE9FFFFFF),
                    
                  ),
                  padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.08,
                        top: MediaQuery.of(context).size.width * 0.08,
                        right: MediaQuery.of(context).size.width * 0.08,
                        bottom:  MediaQuery.of(context).size.width * 0.08),
                  margin: EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom * 1.06 ),
                  child: Column(
                    
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('راجستر', 
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Divider(thickness: 5.0, color: Color(0xFFFF5722),),
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
                      SizedBox(height: 30,),
                      Container( 
                        
                        child: Text(
                          'By Registering you are agreeing Term of use and Policy',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top:15.0),
                            child: RaisedButton(
                              padding: EdgeInsets.all(10),
                              color: Color(0xFFFF5722),
                              child: Text(' راجستر ', 
                                style: myTextStyle( color: Colors.white, fontSize: 15.0),
                              ),
                              onPressed: (){
                                if(_regFromKey.currentState.validate()){
                                  _regFromKey.currentState.save();
                                  registration();

                                }
                              }
                            ),
                          ),
                          InkWell(
                            onTap: () {                          
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top:20.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFFF5722), width:2.0),
                                borderRadius: BorderRadius.circular(3.0),
                                // color: Colors.transparent,
                              ),
                              child: Text(
                                'ورود به حساب ',
                                style: myTextStyle( color: Color(0xff00BCD4), fontSize: 15.0),
                              )
                            ),
                          ),
                        ],
                      ),
                      
                    ],
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
  void createSnackBar(String message) {                                                                               
    final snackBar = new SnackBar(
      content: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Text(message)
      ),                                                         
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      elevation: 6.0,
    );                                                                                      

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!                                            
    _registerScaffoldGlobalKye.currentState.showSnackBar(snackBar);                                                              
  }
}