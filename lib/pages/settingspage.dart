import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../include/appbar.dart';
import '../include/bottom_menu.dart';
import '../include/strings.dart';
import '../include/style.dart' as style;
import 'package:app_settings/app_settings.dart';

class settingsPage extends StatefulWidget {
  const settingsPage({super.key});

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  bool notificationStatus = false;

  getAuthorizationStatus() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      setState(() {
        notificationStatus = true;
      });
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      setState(() {
        notificationStatus = true;
      });
    } else {
      setState(() {
        notificationStatus = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Null> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
  }

  // LOAD LANGUAGE
  String? userLanguage = "sk";
  String? selectedValue = "sk";
  Future<void> loadLang() async {
    userLanguage = await lang().returnselectedValue();
    setState(() {
      selectedValue = userLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // notification status
    getAuthorizationStatus();
    loadLang();

    return Scaffold(
      // appbar
      appBar: MainAppBar(userLanguage: userLanguage!),
      backgroundColor: style.MainAppStyle().bodyBG,
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        constraints: const BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Text(
                lang().returnString(userLanguage!, "settings_aplikacia"),
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                highlightColor: Colors.transparent,
                onTap: () async {
                  AppSettings.openAppSettings(type: AppSettingsType.notification);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(231, 235, 240, 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.bell_solid,
                            size: 20.0,
                          ),
                          SizedBox(width: 10.0),
                          new Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang().returnString(userLanguage!, "settings_notifikacie"),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                notificationStatus
                                    ? Text(
                                        lang().returnString(userLanguage!, "settings_zapnute"),
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      )
                                    : Text(
                                        lang().returnString(userLanguage!, "settings_vypnute"),
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          Image.asset(height: 15.0, "lib/assets/images/arrowright.png"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                highlightColor: Colors.transparent,
                onTap: () async {
                  Navigator.of(context).pushNamed("/selectlanguage");
                },
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(231, 235, 240, 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.globe,
                            size: 20.0,
                          ),
                          SizedBox(width: 10.0),
                          new Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang().returnString(userLanguage!, "settings_vyberregionu"),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  selectedValue!.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(height: 15.0, "lib/assets/images/arrowright.png"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                highlightColor: Colors.transparent,
                onTap: () async {
                  Navigator.of(context).pushNamed("/onboarding");
                },
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(231, 235, 240, 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.info,
                            size: 20.0,
                          ),
                          SizedBox(width: 10.0),
                          new Expanded(
                            child: Text(
                              lang().returnString(userLanguage!, "settings_oaplikaci"),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Image.asset(height: 15.0, "lib/assets/images/arrowright.png"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /*  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromRGBO(231, 235, 240, 1),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10.0),
                        new Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Režim",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              /*SizedBox(height: 5.0),
                              Text(
                                "Tmavý režim",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),*/
                            ],
                          ),
                        ),
                        Image.asset(height: 15.0, "lib/assets/images/arrowright.png"),
                      ],
                    ),
                  ),
                ],
              ),*/
              SizedBox(height: 30.0),
              Text(
                lang().returnString(userLanguage!, "settings_informacie"),
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (!await launchUrl(Uri.parse("https://wetravelcheaply.com/privacypolicy-apple.php"), mode: LaunchMode.externalApplication)) {}
                },
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(231, 235, 240, 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.link,
                            size: 20.0,
                          ),
                          SizedBox(width: 10.0),
                          new Expanded(
                            child: Text(
                              lang().returnString(userLanguage!, "settings_ochranaos"),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Image.asset(height: 15.0, "lib/assets/images/arrowright.png"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (Platform.isAndroid) {
                    if (!await launchUrl(Uri.parse("https://wetravelcheaply.com/termsofuseand.php"), mode: LaunchMode.externalApplication)) {}
                  } else {
                    if (!await launchUrl(Uri.parse("https://wetravelcheaply.com/termsofuseios.php"), mode: LaunchMode.externalApplication)) {}
                  }
                },
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(231, 235, 240, 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.link,
                            size: 20.0,
                          ),
                          SizedBox(width: 10.0),
                          new Expanded(
                            child: Text(
                              lang().returnString(userLanguage!, "settings_gdpr"),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Image.asset(height: 15.0, "lib/assets/images/arrowright.png"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              (() {
                if (selectedValue == "sk" || selectedValue == "cz") {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: Image.asset(height: 40.0, "lib/assets/images/facebook.png"),
                        onTap: () async {
                          if (!await launchUrl(Uri.parse("https://www.facebook.com/"), mode: LaunchMode.externalApplication)) {}
                        },
                      ),
                      InkWell(
                        child: Image.asset(height: 40.0, "lib/assets/images/instagram.png"),
                        onTap: () async {
                          if (!await launchUrl(Uri.parse("https://www.instagram.com/cestujemelacno.sk"), mode: LaunchMode.externalApplication)) {}
                        },
                      ),
                      InkWell(
                        child: Image.asset(height: 40.0, "lib/assets/images/tiktok.png"),
                        onTap: () async {
                          if (!await launchUrl(Uri.parse("https://www.tiktok.com/@cestujemelacno.sk"), mode: LaunchMode.externalApplication)) {}
                        },
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }()),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Text(
                      lang().returnString(userLanguage!, "nahlasit_chybu"),
                    ),
                    onTap: () async {
                      if (!await launchUrl(Uri.parse("https://forms.gle/b14C49roNmCmcdmt5"), mode: LaunchMode.externalApplication)) {}
                    },
                  ),
                ],
              ),
              
              userLanguage! == "sk"
                  ? Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Text(
                                "Promo kód",
                              ),
                              onTap: () async {
                                Navigator.of(context).pushNamed("/promokody");
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "34.0.0",
                    style: TextStyle(
                      color: Color.fromARGB(255, 150, 150, 150),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
      /* BOTTOM MENU */
      bottomNavigationBar: const bottomMenu(
        index: 3,
      ),
    );
  }
}
