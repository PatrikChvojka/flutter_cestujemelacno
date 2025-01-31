import 'dart:convert';

import 'package:cityapp/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../include/strings.dart';
import '../include/style.dart' as style;
import '../main.dart';
import 'dart:io';

class selectLanguage extends StatefulWidget {
  const selectLanguage({super.key});

  @override
  State<selectLanguage> createState() => _selectLanguageState();
}

class _selectLanguageState extends State<selectLanguage> {
  // data
  final List<String> items = [
    'sk',
    'cz',
    'hu',
    'pl',
    'en',
    'at',
  ];

  String? selectedValue = "sk";
  bool showHome = false;

  // names for select
  final List<List<String>> itemsNames = [
    ['', 'cestujeme', 'lacno', '.sk'],
    ['', 'cestujeme', 'levne', '.cz'],
    ['', 'olcson', 'utazunk', '.hu'],
    ['', 'podrozujemy', 'tanio', '.pl'],
    ['we', 'travel', 'cheaply', '.com'],
    ['wir', 'reisen', 'gunstig', '.at'],
  ];

  // LOAD LANGUAGE
  String? userLanguage = "sk";
  Future<Null> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      showHome = prefs.getBool('showHome') ?? false;

      // ak niesme prvy krat
      if (showHome == true) {
        selectedValue = prefs.getString("selectedlanguage") ?? "sk";
        userLanguage = prefs.getString("selectedlanguage") ?? "sk";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    getCountry();
  }

  Future<void> getCountry() async {
    final String defaultLocale = Platform.localeName;

    // first time
    if (showHome == false && userLanguage == 'sk') {
      if (defaultLocale == "sk_SK") {
        setState(() {
          userLanguage = "sk";
          selectedValue = "sk";
        });
      }
      if (defaultLocale == "cs_CZ") {
        setState(() {
          userLanguage = "cz";
          selectedValue = "cz";
        });
      }
      if (defaultLocale == "hu_HU") {
        setState(() {
          userLanguage = "hu";
          selectedValue = "hu";
        });
      }
      if (defaultLocale == "pl_PL") {
        setState(() {
          userLanguage = "pl";
          selectedValue = "pl";
        });
      }
      if (defaultLocale == "de_DE") {
        print("set state DE");
        setState(() {
          userLanguage = "at";
          selectedValue = "at";
        });
      }
      if (defaultLocale != "sk_SK" && defaultLocale != "cs_CZ" && defaultLocale != "hu_HU" && defaultLocale != "pl_PL" && defaultLocale != "de_DE") {
        setState(() {
          userLanguage = "en";
          selectedValue = "en";
        });
      }
    }
    // sk_SK, cs_CZ, hu_HU, en_US, pl_PL, de_DE
  }

  @override
  Widget build(BuildContext context) {
    print(selectedValue);

    return Scaffold(
      backgroundColor: Color.fromRGBO(226, 236, 241, 1),
      body: Column(
        children: [
          SizedBox(
            height: 80.0,
          ),
          Image.asset(height: 150.0, "lib/assets/images/mainIcon.png"),
          SizedBox(
            height: 20.0,
          ),
          Text(
            lang().returnString(userLanguage!, "appbar_title"),
            style: TextStyle(
              fontSize: 24.0,
              color: style.MainAppStyle().mainColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            lang().returnString(userLanguage!, "jazyk_title2"),
            style: TextStyle(
              fontSize: 15.0,
              color: Color.fromRGBO(101, 141, 164, 1),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          // CUSTOM DROPDOWN
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Row(
                children: [
                  Image.asset(
                    height: 30,
                    "lib/assets/images/sk-flag.png",
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Color.fromRGBO(67, 108, 129, 1),
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'cestujeme'),
                          TextSpan(text: 'Lacno', style: const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: '.sk'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              items: items
                  .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Row(
                          children: [
                            Image.asset(
                              height: 22,
                              "lib/assets/images/" + item + "-flag.png",
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Color.fromRGBO(67, 108, 129, 1),
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: itemsNames[items.indexOf(item)][0], style: const TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: itemsNames[items.indexOf(item)][1]),
                                  TextSpan(text: itemsNames[items.indexOf(item)][2], style: const TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: itemsNames[items.indexOf(item)][3]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              onChanged: (String? value) async {
                setState(() {
                  selectedValue = value;
                });
              },
              // main select style
              buttonStyleData: ButtonStyleData(
                height: 70,
                width: MediaQuery.of(context).size.width - 40,
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Color.fromRGBO(125, 161, 179, 1),
                  ),
                  color: Color.fromRGBO(217, 230, 237, 1),
                ),
                elevation: 0,
              ),
              // icon right side
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 19,
                iconEnabledColor: Color.fromRGBO(125, 161, 179, 1),
                iconDisabledColor: Color.fromRGBO(125, 161, 179, 1),
              ),
              // dropdown
              dropdownStyleData: DropdownStyleData(
                maxHeight: 400,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(217, 230, 237, 1),
                ),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: MaterialStateProperty.all<double>(6),
                  thumbVisibility: MaterialStateProperty.all<bool>(true),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 45,
                padding: EdgeInsets.only(left: 14, right: 14),
              ),
            ),
          ),
          // POTVRDIT
          InkWell(
            child: Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(22, 97, 174, 1),
                    Color.fromRGBO(20, 153, 208, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                lang().returnString(userLanguage!, "jazyk_potvrdit"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('selectedlanguage', selectedValue!);

              print(showHome);

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => showHome ? MyApp(showHome: true) : OnboardingScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
