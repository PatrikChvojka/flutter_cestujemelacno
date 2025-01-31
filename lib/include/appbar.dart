import 'package:cityapp/include/strings.dart';
import 'package:flutter/material.dart';
import 'style.dart' as style;

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userLanguage;

  const MainAppBar({key, required this.userLanguage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      elevation: 0,
      backgroundColor: style.MainAppStyle().bodyBG,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          /* Padding(
            padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 20),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
                maximumSize: Size(40.0, 40.0),
                minimumSize: Size(40.0, 40.0),
              ),
              child: Icon(
                size: 23.0,
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Image.asset(height: 50.0, "lib/assets/images/mainIcon.png"),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang().returnString(userLanguage, "appbar_title"),
                style: TextStyle(
                  fontSize: 24.0,
                  color: style.MainAppStyle().mainColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.0),
              Text(
                lang().returnString(userLanguage, "appbar_title2"),
                style: TextStyle(
                  fontSize: 13.0,
                  color: Color.fromRGBO(101, 141, 164, 1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(70);
}
