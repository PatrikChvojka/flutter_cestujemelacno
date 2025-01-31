import 'dart:async';

import 'package:cityapp/include/strings.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CheckInternetClass extends StatefulWidget {
  const CheckInternetClass({super.key});

  @override
  State<CheckInternetClass> createState() => _CheckInternetClassState();
}

class _CheckInternetClassState extends State<CheckInternetClass> {
  bool haveInternetWidget = true;
  late Timer timer;

  Future checkInternetFunction() async {
    if (!mounted) return;

    if (await InternetConnectionChecker.instance.hasConnection) {
      if (mounted) {
        setState(() {
          haveInternetWidget = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          haveInternetWidget = false;
        });
      }
    }

    //print(haveInternet);
  }

  checkInternet() {
    timer = Timer.periodic(
        Duration(seconds: 2), (Timer t) => checkInternetFunction());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // INTERNET POPUP
  @override
  void initState() {
    super.initState();
    checkInternet();
  }

  // LOAD LANGUAGE
  String? userLanguage = "sk";
  Future<void> loadLang() async {
    final loadedLang = await lang().returnselectedValue();

    setState(() {
      userLanguage = loadedLang;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadLang();
    return haveInternetWidget
        ? Container()
        : Positioned(
            bottom: 10, //display untill the height of bottom widget
            left: 0, right: 0,
            child: Container(
              height: 50,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: haveInternetWidget ? Colors.green[500] : Colors.red[500],
              ),
              child: Center(
                child: Text(
                    lang().returnString(
                        userLanguage!, "nointernet_bezpripojenia"),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          );
  }
}
