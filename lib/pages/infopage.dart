import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../include/appbar.dart';
import '../include/bottom_menu.dart';
import '../include/strings.dart';
import '../include/style.dart' as style;

class infoPage extends StatefulWidget {
  const infoPage({super.key});

  @override
  State<infoPage> createState() => _infoPageState();
}

class _infoPageState extends State<infoPage> {
  // LOAD LANGUAGE
  String? userLanguage = "sk";
  Future<void> loadLang() async {
    userLanguage = await lang().returnselectedValue();

    setState(() {
      userLanguage = userLanguage;
    });
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Html(
                data: '${lang().returnString(userLanguage!, "infopage")}',
                style: {
                  "body": Style(
                    margin: Margins.all(0),
                    fontSize: FontSize(15),
                    color: Color.fromRGBO(101, 141, 164, 1),
                    fontWeight: FontWeight.w400,
                    lineHeight: LineHeight(1.5),
                  ),
                  "p": Style(
                    margin: Margins.only(top: 0, bottom: 10, left: 0, right: 0),
                    padding: HtmlPaddings.all(0),
                    fontSize: FontSize(15),
                    color: Color.fromRGBO(101, 141, 164, 1),
                    fontWeight: FontWeight.w400,
                    lineHeight: LineHeight(1.5),
                  )
                },
              ),
              SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
      /* BOTTOM MENU */
      bottomNavigationBar: const bottomMenu(
        index: 2,
      ),
    );
  }
}
