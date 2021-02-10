import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hesab_ketab/appUI/hesab_ketab.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:hesab_ketab/utils/navigationService.dart';

class EmailConfirmation extends StatefulWidget {
  EmailConfirmation({Key key}) : super(key: key);

  @override
  _EmailConfirmationState createState() => _EmailConfirmationState();
}

class _EmailConfirmationState extends State<EmailConfirmation> {
  GlobalKey<FormState> _confirmationFormKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _confirmationScaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _confirmationCodeTEController = TextEditingController();
  var waitForResponse = false;
  BuildContext _context;
  var height;
  var width;
  var bottomInset;
  @override
  Widget build(BuildContext context) {
    this._context = context;
    this.height = MediaQuery.of(context).size.height;
    this.width = MediaQuery.of(context).size.width;
    this.bottomInset = MediaQuery.of(context).viewInsets.bottom;
    var _padding = EdgeInsets.only(
      left: this.height * 0.012,
      top: this.height * 0.012,
      right: this.height * 0.012,
      bottom: this.bottomInset,
    );
    return Scaffold(
      key: _confirmationScaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xC2212121),
        title: Text('تأیید ایمیل'),
        centerTitle: true,
      ),

      body: Container(
        height: this.height,
        width: this.width,
        padding: _padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            

            Container(
              padding: EdgeInsets.all(50.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: boxShadow(), 
              ),
              child: Form(
                key: _confirmationFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child:Text(
                        'کد شش رقمی‌ای که به ایمیل تان ارسال شده است را وارد نمایید.',
                        style: myTextStyle(fontSize: 14, color: Color(0xff000000)),
                      )
                    ),
                    TextFormField(
                      controller: _confirmationCodeTEController,
                      decoration: myInputDecoration(labelText: 'کد تاییدی'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => FocusScope.of(context).nextFocus(),
                      // ignore: missing_return
                      validator: (String value){
                        if(value.isEmpty){
                          return 'کد تاییدی را وارد نمایید';
                        }
                        if(value.length != 6){
                          return 'تعداد ارقام درست نمی باشد';
                        }
                        
                      },
                    ),
                    SizedBox(height: 10.0,),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          
                        },
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.syncAlt, size: 14, color: Colors.blueAccent[700]),
                            SizedBox(width: 8.0,),
                            Text('ارسال دوباره کد تاییدی',
                              style: myTextStyle(fontSize: 14, color: Colors.blueAccent[700]),

                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    RaisedButton(
                      padding: EdgeInsets.only(top:10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('تایید',
                            style: myTextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(width: 8.0,),
                          waitForResponse ? Container(
                            height: 20.0,width: 20.0, 
                            child: (CircularProgressIndicator(value: 0.01,strokeWidth: 3.0, backgroundColor: Colors.white,))
                          ) : Container()
                        ],
                      ),
                      color: Color(0xFFFF5722),
                      onPressed: () async{
                        if(_confirmationFormKey.currentState.validate()){
                          _confirmationFormKey.currentState.save();
                          setState(() {
                            waitForResponse = true;
                          });

                          var result = await confirm(_context, _confirmationScaffoldKey, _confirmationCodeTEController.text);
                          if(result.toString().isNotEmpty && result.toString() == 'confirmed'){

                            setState(() {
                              waitForResponse = false;
                            });
                            NavigationService.instance.navigateToRemoveUntil('/hesabKetab');
                            // Navigator.pushAndRemoveUntil(
                            //   context, 
                            //   MaterialPageRoute(
                            //     builder: (context) => HesabKetab()
                            //   ),
                            //   (Route<dynamic> route) => false
                            //   // ModalRoute.withName("/HesabKetab") 
                            // );
                          }
                          
                          
                        }
                      }
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}