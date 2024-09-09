import 'package:flutter/material.dart';
import 'package:hesab_ketab/utils/navigationService.dart';

TextStyle myTextStyle(
    {Color? color, double? fontSize, FontWeight? fontWeight}) {
  return TextStyle(
    color: color,
    fontSize: fontSize?.toDouble(),
    fontWeight: fontWeight,
    fontFamily: 'myFont',
  );
}

List<BoxShadow> boxShadow() {
  return [
    BoxShadow(
      color: Colors.grey,
      offset: Offset(1.0, 1.0),
      blurRadius: 5.5,
      spreadRadius: 0.1,
    ),
  ];
}

void createSnackBar(
  String message,
  BuildContext context,
  GlobalKey<ScaffoldState> _scaffoldKey, {
  Color? color,
}) {
  final snackBar = SnackBar(
    content: Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Text(message),
    ),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    elevation: 10.0,
  );

  // Find the Scaffold in the Widget tree and use it to show a SnackBar!
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

InputDecoration myInputDecoration({String? labelText, String? helperText}) {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff00BCD4), width: 1.0),
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff00BCD4), width: 2.0),
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[700]!, width: 2.0),
      borderRadius: BorderRadius.circular(8.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[700]!, width: 2.0),
      borderRadius: BorderRadius.circular(8.0),
    ),
    labelStyle: myTextStyle(
      color: Color(0x77FF5622),
      fontWeight: FontWeight.w600,
    ),
    contentPadding: EdgeInsets.all(8.0),
    labelText: labelText,
    helperText: helperText,
    helperStyle: myTextStyle(fontWeight: FontWeight.w600),
    floatingLabelBehavior: FloatingLabelBehavior.always,
  );
}

BoxDecoration iconButtonBackground({Color? color, double? radius}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius ?? 0),
    color: color,
  );
}

Widget showExceptionMsg(
    {required BuildContext context, required String message}) {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  return Container(
    height: height - 100.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: width,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Color(0xFFFfffff),
            boxShadow: boxShadow(),
          ),
          child: Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 60.0,
                color: Color(0xD0FF5622),
              ),
              Text(
                '$message',
                textAlign: TextAlign.center,
                style: myTextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Divider(thickness: 2.0),
        SizedBox(height: height * 0.012),
      ],
    ),
  );
}

class UnauthenticatedUser extends StatefulWidget {
  UnauthenticatedUser({Key? key}) : super(key: key);

  @override
  _UnauthenticatedUserState createState() => _UnauthenticatedUserState();
}

class _UnauthenticatedUserState extends State<UnauthenticatedUser> {
  final GlobalKey<ScaffoldState> unAuthUserScaffold =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning, size: 80.0, color: Colors.yellow[600]),
            SizedBox(height: 30.0),
            Text(
              'اعتبار شما منقضی شده ست!',
              textAlign: TextAlign.center,
              style: myTextStyle(
                color: Colors.redAccent,
                fontSize: 24.0,
              ),
            ),
            Text(
              'Authentication Expired!',
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: myTextStyle(
                color: Colors.redAccent,
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                NavigationService.instance.navigateToRemoveUntil('login');
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.cyan),
              ),
              child: Text(
                'ورود مجدد',
                style: myTextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
