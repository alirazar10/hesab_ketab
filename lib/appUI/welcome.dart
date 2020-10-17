import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      // resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:  AssetImage("assets/images/designs/design2.png"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        // color: Colors.white,
        child: PageView(
          children: <Widget>[
            Container(
              // color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(flex: 1),

                  logoImage('logo/Hesab_ketab_Farsi_Logo.png'),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                  ),
                  
                  Spacer(flex: 1),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      threeDotsNext(1.0),
                      threeDotsNext(0.5),
                      threeDotsNext(0.5),
                    ],
                  )
                ],
              ),
            ),
            Container(
              // color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(flex: 1),
                  logoImage('icons/electricity.png'),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    // color: Colors.red,
                    child: Text(
                      'مدیریت محاسبه بل‌برق',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                        fontFamily: "myFont"
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(
                    indent: 70.0,
                    endIndent: 70.0,
                    color: Color.fromRGBO(82, 119, 160, 1.0),
                    height: 50.0,
                    thickness: 3.0,
                  ),
                  Spacer(flex: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      threeDotsNext(0.5),
                      threeDotsNext(1.0),
                      threeDotsNext(0.5),
                    ],
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Spacer(flex: 1),
                  logoImage('icons/water.png'),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'مدیریت محاسبه بل‌آب',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none),
                          textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(
                    indent: 70.0,
                    endIndent: 70.0,
                    color: Color.fromRGBO(82, 119, 160, 1.0),
                    height: 50.0,
                    thickness: 3.0,
                  ),
                  Spacer(flex: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      threeDotsNext(0.5),
                      threeDotsNext(0.5),
                      threeDotsNext(1.0),
                    ],
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: RaisedButton(
                        color: const Color(0xff00BCD4),
                        child: Text('ورود', style: TextStyle(color: Color(0xffFF5722), fontSize: 16.0),),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getBool('toLogin') == null){
                            prefs.setBool('toLogin', true);
                            print(prefs.getBool('toLogin'));
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                        }, 
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 40,
                      width: 200,
                      child: OutlineButton (
                        onPressed: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getBool('toLogin') == null){
                            prefs.setBool('toLogin', true);
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                        }, 
                        child: Text('راجستر', style: TextStyle(color: Color(0xffFF5722), fontSize: 16.0),),
                        color: Colors.teal[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide( color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  Widget logoImage(logoName){
    return Image.asset(
      'assets/images/$logoName',
      height: 150.0,
      width: 250.0,
    );
  }
  Widget  threeDotsNext(op){
    return Container(
      alignment: Alignment.center,
      child: Opacity(
        opacity: op,
        child: IconButton(
          icon: Icon(
            Icons.brightness_1,
            size: 15.2,
            color: Colors.black,
          ),
          onPressed: (){},
        ),
      ),
    );
  }
}
