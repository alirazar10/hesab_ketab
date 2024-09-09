import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hesab_ketab/utils/navigationService.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';

class EmailConfirmation extends StatefulWidget {
  EmailConfirmation({Key? key}) : super(key: key);

  @override
  _EmailConfirmationState createState() => _EmailConfirmationState();
}

class _EmailConfirmationState extends State<EmailConfirmation> {
  final GlobalKey<FormState> _confirmationFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _confirmationScaffoldKey =
      GlobalKey<ScaffoldState>();
  final TextEditingController _confirmationCodeTEController =
      TextEditingController();
  bool waitForResponse = false;
  late BuildContext _context;
  double? height;
  double? width;
  double? bottomInset;

  @override
  Widget build(BuildContext context) {
    _context = context;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final EdgeInsets _padding = EdgeInsets.only(
      left: height! * 0.012,
      top: height! * 0.012,
      right: height! * 0.012,
      bottom: bottomInset!,
    );

    return Scaffold(
      key: _confirmationScaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xC2212121),
        title: const Text('تأیید ایمیل'),
        centerTitle: true,
      ),
      body: Container(
        height: height,
        width: width,
        padding: _padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(50.0),
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
                      margin: const EdgeInsets.only(bottom: 20.0),
                      child: const Text(
                        'کد شش رقمی‌ای که به ایمیل تان ارسال شده است را وارد نمایید.',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff000000)),
                      ),
                    ),
                    TextFormField(
                      controller: _confirmationCodeTEController,
                      decoration: myInputDecoration(labelText: 'کد تاییدی'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'کد تاییدی را وارد نمایید';
                        }
                        if (value.length != 8) {
                          return 'تعداد ارقام درست نمی باشد';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Resend code action
                        },
                        child: Row(
                          children: [
                            const Icon(FontAwesomeIcons.rotate,
                                size: 14, color: Colors.blueAccent),
                            const SizedBox(width: 8.0),
                            ElevatedButton(
                                child: Text(
                                  'ارسال دوباره کد تاییدی',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.blueAccent),
                                ),
                                onPressed: () async {
                                  resendConfirmationsCode(
                                      _context, _confirmationScaffoldKey);
                                }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        backgroundColor: const Color(0xFFFF5722),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'تایید',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(width: 8.0),
                          if (waitForResponse)
                            const SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                                backgroundColor: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      onPressed: () async {
                        if (_confirmationFormKey.currentState?.validate() ??
                            false) {
                          _confirmationFormKey.currentState?.save();
                          setState(() {
                            waitForResponse = true;
                          });

                          final result = await confirm(
                              _context,
                              _confirmationScaffoldKey,
                              _confirmationCodeTEController.text);
                          if (result.toString().isNotEmpty &&
                              result.toString() == 'confirmed') {
                            setState(() {
                              waitForResponse = false;
                            });
                            NavigationService.instance
                                .navigateToRemoveUntil('/hesabKetab');
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
