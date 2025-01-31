import 'package:flutter/material.dart';
import '../include/strings.dart';
import '../include/style.dart' as style;

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50.0),
            Image.asset(height: 100.0, "lib/assets/images/noInternet.png"),
            SizedBox(height: 10.0),
            Text(
              lang().returnString(userLanguage!, "nointernet_oops"),
              style: TextStyle(
                fontSize: 24.0,
                color: style.MainAppStyle().mainColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              lang().returnString(userLanguage!, "nointernet_skontrolujte"),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: Color.fromRGBO(101, 141, 164, 1),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
