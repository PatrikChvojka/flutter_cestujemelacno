import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:onepref/onepref.dart';
import '../include/style.dart';
import '../pages/paymentPage.dart';

class bottomMenu extends StatelessWidget {
  final index;
  const bottomMenu({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    onTapFunction(i) {
      if (i == 0) {
        Navigator.of(context).popAndPushNamed("/home");
      }
      if (i == 1) {
        Navigator.of(context).popAndPushNamed("/paymentpage");
      }
      if (i == 2) {
        OnePref.getPremium() == true ? Navigator.of(context).popAndPushNamed("/infopage") : Navigator.of(context).popAndPushNamed("/homefree");
      }
      if (i == 3) {
        Navigator.of(context).popAndPushNamed("/settingspage");
      }
    }

    return StyleProvider(
      style: StyleBottomMenu(),
      child: ConvexAppBar(
        backgroundColor: Colors.white,
        activeColor: Color.fromRGBO(33, 125, 194, 1),
        color: Color.fromRGBO(168, 191, 213, 1),
        cornerRadius: 0.0,
        height: 70.0,
        top: 0.0,

        curveSize: 0.0,
        elevation: 0.5, // tien
        style: TabStyle.react,
        items: [
          TabItem(icon: new Image.asset("lib/assets/images/home_icon.png"), activeIcon: new Image.asset("lib/assets/images/home_icon_hover.png"), title: ''),
          TabItem(icon: new Image.asset("lib/assets/images/wallet_icon.png"), activeIcon: new Image.asset("lib/assets/images/wallet_icon_hover.png"), title: ''),
          OnePref.getPremium() == true
              ? TabItem(icon: new Image.asset("lib/assets/images/info_icon.png"), activeIcon: new Image.asset("lib/assets/images/info_icon_hover.png"), title: '')
              : TabItem(icon: new Image.asset("lib/assets/images/free_icon.png"), activeIcon: new Image.asset("lib/assets/images/free_icon_hover.png"), title: ''),
          TabItem(icon: new Image.asset("lib/assets/images/settings_icon.png"), activeIcon: new Image.asset("lib/assets/images/settings_icon_hover.png"), title: ''),
        ],
        initialActiveIndex: index,
        onTap: (int i) => onTapFunction(i),
      ),
    );
  }
}

class StyleBottomMenu extends StyleHook {
  @override
  double get activeIconSize => 35;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 30;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(fontSize: 20, color: color);
  }
}
