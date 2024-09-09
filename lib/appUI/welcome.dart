import 'package:flutter/material.dart';
import 'package:hesab_ketab/appUI/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/designs/design2.png"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: PageView(
          children: <Widget>[
            _buildPage(
              context,
              'logo/Hesab_ketab_Farsi_Logo.png',
              <Widget>[
                _buildDots(1.0, 0.5, 0.5),
              ],
            ),
            _buildPage(
              context,
              'icons/electricity.png',
              <Widget>[
                _buildText('مدیریت محاسبه بل‌برق'),
                const Divider(
                  indent: 70.0,
                  endIndent: 70.0,
                  color: Color.fromRGBO(82, 119, 160, 1.0),
                  height: 50.0,
                  thickness: 3.0,
                ),
                _buildDots(0.5, 1.0, 0.5),
              ],
            ),
            _buildPage(
              context,
              'icons/water.png',
              <Widget>[
                _buildText('مدیریت محاسبه بل‌آب'),
                const Divider(
                  indent: 70.0,
                  endIndent: 70.0,
                  color: Color.fromRGBO(82, 119, 160, 1.0),
                  height: 50.0,
                  thickness: 3.0,
                ),
                _buildDots(0.5, 0.5, 1.0),
              ],
            ),
            _buildLoginRegisterButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, String logo, List<Widget> children) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Spacer(flex: 1),
          _logoImage(logo),
          const Padding(padding: EdgeInsets.all(20.0)),
          ...children,
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _buildText(String text) {
    return Container(
      padding: const EdgeInsets.all(15),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.redAccent,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
          fontFamily: "myFont",
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDots(double first, double second, double third) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _threeDotsNext(first),
        _threeDotsNext(second),
        _threeDotsNext(third),
      ],
    );
  }

  Widget _buildLoginRegisterButtons(BuildContext context) {
    return Container(
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00BCD4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'ورود',
                  style: TextStyle(color: Color(0xffFF5722), fontSize: 16.0),
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  if (prefs.getBool('toLogin') == null) {
                    prefs.setBool('toLogin', true);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 40,
              width: 200,
              child: OutlinedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  if (prefs.getBool('toLogin') == null) {
                    prefs.setBool('toLogin', true);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                child: const Text(
                  'راجستر',
                  style: TextStyle(color: Color(0xffFF5722), fontSize: 16.0),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoImage(String logoName) {
    return Image.asset(
      'assets/images/$logoName',
      height: 150.0,
      width: 250.0,
    );
  }

  Widget _threeDotsNext(double opacity) {
    return Container(
      alignment: Alignment.center,
      child: Opacity(
        opacity: opacity,
        child: IconButton(
          icon: const Icon(
            Icons.brightness_1,
            size: 15.2,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
