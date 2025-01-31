import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../include/strings.dart';
import '../main.dart';
import '../include/style.dart' as style;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildPage({
    required int slideNumber,
    required Color color,
    required String urlImage,
    required String title,
    required String subtitle,
    required String button,
    required String buttonType,
    required String image,
    required String? userLanguage,
  }) =>
      Container(
        color: color,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            transform: Matrix4.translationValues(0.0, 80.0, 0.0),
            child: Column(
              children: [
                slideNumber == 1
                    ? Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Image.asset(height: 50.0, "lib/assets/images/mainIcon.png"),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang().returnString(userLanguage!, "appbar_title"),
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
                          SizedBox(height: 20.0),
                        ],
                      )
                    : Container(),
                Text(
                  title,
                  style: TextStyle(
                    color: Color.fromRGBO(40, 122, 198, 1),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                slideNumber == 1
                    ? Column(children: [
                        Text(
                          lang().returnString(userLanguage!, "slidy_nadpis1_2"),
                          style: TextStyle(
                            color: Color.fromRGBO(109, 139, 155, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 30),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(15.0, 13.0, 15.0, 13.0),
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
                                  button,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              onTap: () async {
                                if (buttonType == "ponuky") {
                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setBool('showHome', true);

                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => MyApp(showHome: true)),
                                  );
                                }
                                if (buttonType == "notification") {
                                  AppSettings.openAppSettings(type: AppSettingsType.notification);
                                  //getDeviceToken();
                                }
                                if (buttonType == "payment") {
                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setBool('showHome', true);
                                  Navigator.of(context).popAndPushNamed("/paymentpage");
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Text(
                          lang().returnString(userLanguage, "slidy_nadpis1_3"),
                          style: TextStyle(
                            color: Color.fromRGBO(40, 122, 198, 1),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 30),
                            Image.asset("lib/assets/images/" + image + "_" + userLanguage! + ".png"),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ])
                    : Container(),
                Html(
                  data: subtitle,
                  style: {
                    "body": Style(
                      margin: Margins.all(0),
                      color: Color.fromRGBO(109, 139, 155, 1),
                      fontSize: FontSize(15),
                      fontWeight: FontWeight.w500,
                      lineHeight: LineHeight(1.5),
                    ),
                    "p": Style(
                      border: Border.all(color: Color.fromARGB(255, 159, 194, 255)),
                      backgroundColor: Color.fromRGBO(217, 235, 241, 1),
                      margin: Margins.only(top: 0, bottom: 15, left: 0, right: 0),
                      padding: HtmlPaddings.all(20),
                      fontSize: FontSize(15),
                      color: Color.fromRGBO(109, 139, 155, 1),
                      fontWeight: FontWeight.w500,
                      lineHeight: LineHeight(1.5),
                    ),
                    "s": Style(
                      textDecoration: TextDecoration.lineThrough,
                      textDecorationThickness: 2,
                    )
                  },
                ),
                image.isNotEmpty && slideNumber != 1
                    ? Column(
                        children: [
                          const SizedBox(height: 30),
                          Image.asset("lib/assets/images/" + image + "_" + userLanguage! + ".png"),
                        ],
                      )
                    : Container(),
                slideNumber == 4
                    ? Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(15.0, 13.0, 15.0, 13.0),
                            decoration: new BoxDecoration(
                              border: Border.all(color: Color.fromARGB(255, 159, 194, 255)),
                              color: Color.fromRGBO(217, 235, 241, 1),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Image.asset(width: 60, "lib/assets/images/reviews.png"),
                                    const SizedBox(height: 5),
                                    Text(
                                      lang().returnString(userLanguage!, "review_1_name"),
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Container(width: MediaQuery.of(context).size.width - 150, child: Text(lang().returnString(userLanguage, "review_1_text"))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.fromLTRB(15.0, 13.0, 15.0, 13.0),
                            decoration: new BoxDecoration(
                              border: Border.all(color: Color.fromARGB(255, 159, 194, 255)),
                              color: Color.fromRGBO(217, 235, 241, 1),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Image.asset(width: 60, "lib/assets/images/reviews.png"),
                                    const SizedBox(height: 5),
                                    Text(
                                      lang().returnString(userLanguage, "review_2_name"),
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Container(width: MediaQuery.of(context).size.width - 150, child: Text(lang().returnString(userLanguage, "review_2_text"))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.fromLTRB(15.0, 13.0, 15.0, 13.0),
                            decoration: new BoxDecoration(
                              border: Border.all(color: Color.fromARGB(255, 159, 194, 255)),
                              color: Color.fromRGBO(217, 235, 241, 1),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Image.asset(width: 60, "lib/assets/images/reviews.png"),
                                    const SizedBox(height: 5),
                                    Text(
                                      lang().returnString(userLanguage, "review_3_name"),
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Container(
                                    width: MediaQuery.of(context).size.width - 150,
                                    child: Text(
                                      lang().returnString(userLanguage, "review_3_text"),
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.fromLTRB(15.0, 13.0, 15.0, 13.0),
                            decoration: new BoxDecoration(
                              border: Border.all(color: Color.fromARGB(255, 159, 194, 255)),
                              color: Color.fromRGBO(217, 235, 241, 1),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Image.asset(width: 60, "lib/assets/images/reviews.png"),
                                    const SizedBox(height: 5),
                                    Text(
                                      lang().returnString(userLanguage, "review_4_name"),
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Container(
                                    width: MediaQuery.of(context).size.width - 150,
                                    child: Text(
                                      lang().returnString(userLanguage, "review_4_text"),
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Image.asset(width: 70, "lib/assets/images/store_logo.png"),
                              const SizedBox(width: 20),
                              Container(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Column(
                                  children: [
                                    Text(
                                      "4.8 / 5.0",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Image.asset(width: 70, "lib/assets/images/store_stars.png"),
                                    const SizedBox(height: 5),
                                    Text(
                                      lang().returnString(userLanguage, "slidy_text4_app"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
                slideNumber == 5
                    ? Column(
                        children: [
                          const SizedBox(height: 30),
                          Image.asset(height: 70.0, "lib/assets/images/apple_pay2.png"),
                        ],
                      )
                    : Container(),
                button.isNotEmpty && slideNumber != 1
                    ? Column(
                        children: [
                          const SizedBox(height: 30),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(15.0, 13.0, 15.0, 13.0),
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
                                button,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            onTap: () async {
                              if (buttonType == "ponuky") {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setBool('showHome', true);

                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => MyApp(showHome: true)),
                                );
                              }
                              if (buttonType == "notification") {
                                AppSettings.openAppSettings(type: AppSettingsType.notification);
                                //getDeviceToken();
                              }
                              if (buttonType == "payment") {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setBool('showHome', true);
                                Navigator.of(context).popAndPushNamed("/paymentpage");
                              }
                            },
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(height: 180),
              ],
            ),
          ),
        ),
      );

  // LOAD LANGUAGE
  String? userLanguage = "sk";
  Future<void> loadLang() async {
    final loadedLang = await lang().returnselectedValue();

    setState(() {
      userLanguage = loadedLang;
    });
  }

  Future getDeviceToken() async {
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await _firebaseMessage.getToken();
  }

  @override
  Widget build(BuildContext context) {
    loadLang();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            if (index == 4) {
              setState(() {
                isLastPage = true;
              });
            } else {
              setState(() {
                isLastPage = false;
              });
            }
          },
          children: [
            buildPage(
              slideNumber: 1,
              userLanguage: userLanguage,
              color: Color.fromRGBO(226, 236, 241, 1),
              urlImage: 'lib/assets/images/onboarding01.jpg',
              title: lang().returnString(userLanguage!, "slidy_nadpis1"),
              subtitle: lang().returnString(userLanguage!, "slidy_text1"),
              button: lang().returnString(userLanguage!, "slidy_text1_button"),
              buttonType: "ponuky",
              image: "slide_1_img",
            ),
            buildPage(
              slideNumber: 2,
              userLanguage: userLanguage,
              color: Color.fromRGBO(226, 236, 241, 1),
              urlImage: 'lib/assets/images/onboarding02.jpg',
              title: lang().returnString(userLanguage!, "slidy_nadpis2"),
              subtitle: lang().returnString(userLanguage!, "slidy_text2"),
              button: lang().returnString(userLanguage!, "slidy_text2_button"),
              buttonType: "ponuky",
              image: "",
            ),
            buildPage(
              slideNumber: 3,
              userLanguage: userLanguage,
              color: Color.fromRGBO(226, 236, 241, 1),
              urlImage: 'lib/assets/images/onboarding03.jpg',
              title: lang().returnString(userLanguage!, "slidy_nadpis3"),
              subtitle: lang().returnString(userLanguage!, "slidy_text3"),
              button: lang().returnString(userLanguage!, "slidy_text3_button"),
              buttonType: "notification",
              image: "notif_slide_3",
            ),
            buildPage(
              slideNumber: 4,
              userLanguage: userLanguage,
              color: Color.fromRGBO(226, 236, 241, 1),
              urlImage: 'lib/assets/images/onboarding04.jpg',
              title: lang().returnString(userLanguage!, "slidy_nadpis4"),
              subtitle: lang().returnString(userLanguage!, "slidy_text4"),
              button: lang().returnString(userLanguage!, "slidy_text4_button"),
              buttonType: "payment",
              image: "",
            ),
            buildPage(
              slideNumber: 5,
              userLanguage: userLanguage,
              color: Color.fromRGBO(226, 236, 241, 1),
              urlImage: 'lib/assets/images/onboarding05.jpg',
              title: lang().returnString(userLanguage!, "slidy_nadpis5"),
              subtitle: lang().returnString(userLanguage!, "slidy_text5"),
              button: lang().returnString(userLanguage!, "slidy_text5_button"),
              buttonType: "payment",
              image: "",
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Color.fromRGBO(40, 122, 198, 1), minimumSize: const Size.fromHeight(80)),
              child: Text(
                lang().returnString(userLanguage!, "slidy_zobrazitponuky"),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () async {
                // navigate rirectly to home page
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('showHome', true);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MyApp(showHome: true)),
                );
              },
            )
          : Container(
              color: Color.fromRGBO(226, 236, 241, 1),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              height: 130.0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SmoothPageIndicator(
                          controller: controller,
                          count: 5,
                          effect: WormEffect(
                            spacing: 16,
                            dotColor: Color.fromRGBO(176, 197, 208, 1),
                            activeDotColor: Color.fromRGBO(40, 122, 198, 1),
                          ),
                          onDotClicked: (index) => controller.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeIn),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text(
                          lang().returnString(userLanguage!, "slidy_preskocit"),
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(124, 159, 177, 1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () => controller.jumpToPage(5),
                      ),
                      TextButton(
                        child: Text(
                          lang().returnString(userLanguage!, "slidy_dalej"),
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(53, 101, 125, 1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () => controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
