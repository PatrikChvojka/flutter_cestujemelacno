import 'package:flutter/material.dart';
import '../include/appbar.dart';
import '../include/bottom_menu.dart';
import '../include/strings.dart';
import '../include/style.dart' as style;

class OchranaUdajovPage extends StatefulWidget {
  const OchranaUdajovPage({super.key});

  @override
  State<OchranaUdajovPage> createState() => _OchranaUdajovPageState();
}

class _OchranaUdajovPageState extends State<OchranaUdajovPage> {
  // LOAD LANGUAGE
  String? userLanguage = "sk";
  Future<void> loadLang() async {
    userLanguage = await lang().returnselectedValue();
  }

  @override
  Widget build(BuildContext context) {
    loadLang();
    return Scaffold(
      // appbar
      appBar: MainAppBar(userLanguage: userLanguage!),
      backgroundColor: style.MainAppStyle().bodyBG,
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        constraints: const BoxConstraints.expand(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            Text(
              "Ochrana osobných údajov",
              style: TextStyle(
                height: 1.3,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(45, 92, 117, 1),
              ),
            ),
          ],
        ),
      ),
      /* BOTTOM MENU */
      bottomNavigationBar: const bottomMenu(
        index: 3,
      ),
    );
  }
}
