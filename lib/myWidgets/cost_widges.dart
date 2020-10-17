import 'package:flutter/material.dart';

myTextStyle({Color color, fontSize, FontWeight fontWeight}){
    return TextStyle(
      color: color, 
      fontSize: fontSize == null ? fontSize : fontSize.toDouble(),
      fontWeight: fontWeight,
      fontFamily: 'myFont'
    );
}

boxShadow(){
  return [BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0) ,blurRadius: 5.5, spreadRadius: .1,)];
}
void createSnackBar(String message, BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey) {                                                                               
    final snackBar = new SnackBar(
      content: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Text(message),
      ),                                                         
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      elevation: 6.0,
    );                                                                                      

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!                                            
    _scaffoldKey.currentState.showSnackBar(snackBar);                                                              
}
myInputDecoration({String labelText}){
  return InputDecoration(
    // border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff00BCD4),width: 1.0),
      borderRadius: BorderRadius.circular(8.0)
    ),
    // disabledBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Color(0x4200BBD4),width: 1.0),
    //   borderRadius: BorderRadius.circular(8.0)
    // ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff00BCD4), width: 2.0),
      borderRadius: BorderRadius.circular(8.0)
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[700], width: 2.0),
      borderRadius: BorderRadius.circular(8.0)
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[700], width: 2.0),
      borderRadius: BorderRadius.circular(8.0)
    ),
    labelStyle: myTextStyle(color: Color(0x77FF5622), fontWeight: FontWeight.w600),
    contentPadding: EdgeInsets.all(8.0),
    labelText: labelText,
    floatingLabelBehavior: FloatingLabelBehavior.always,
  );
}

iconButtonBackground( {Color color, double radius}){
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius.toDouble()),
    color: color,
  );
}