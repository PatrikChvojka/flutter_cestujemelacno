

import 'dart:convert';

import 'package:cityapp/pages/homepage.dart';
import 'package:cityapp/pages/homepage_free.dart';
import 'package:cityapp/pages/onboarding.dart';
import 'package:cityapp/pages/paymentPage.dart';
import 'package:cityapp/pages/selectlanguage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:cityapp/pages/promokody.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onepref/onepref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../include/style.dart' as style;
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'include/strings.dart';
import 'pages/infopage.dart';
import 'pages/ochranaosudajov.dart';
import 'pages/settingspage.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
// remove notification icon
    FlutterAppBadger.removeBadge();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

  await OnePref.init();

  runApp(
    MaterialApp(
      theme: style.MainAppStyle().themeData,
      home: MyApp(showHome: showHome),
    ),
  );
}


class MyApp extends StatelessWidget {
  final bool showHome;
  const MyApp({Key? key, required this.showHome}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Cestujeme Lacno',
      theme: style.MainAppStyle().themeData,
      home: showHome ? MyHomePage() : selectLanguage(),
      routes: {
        '/home': (context) => MyHomePage(),
        '/homefree': (context) => HomePageFree(),
        '/onboarding': (context) => OnboardingScreen(),
        '/selectlanguage': (context) => selectLanguage(),
        '/paymentpage': (context) => PayMentPage(),
        '/settingspage': (context) => settingsPage(),
        '/ochranaosudajov': (context) => OchranaUdajovPage(),
        '/infopage': (context) => infoPage(),
        '/promokody': (context) => promoKody(),
      },
    );
  }
}
