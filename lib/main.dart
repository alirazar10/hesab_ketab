import 'package:flutter/material.dart';
import 'appUI/welcome.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      supportedLocales: [
        const Locale('en', ''), // American English
        const Locale('fa', ''), // Persian 
        // ...
      ],
      locale: Locale("fa", "IR"),
      title: 'الکتروخانه',
      home: Welcome(),
    ),
  );
}