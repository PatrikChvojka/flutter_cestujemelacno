import 'dart:async';
import 'dart:convert';
import 'package:cityapp/pages/ponuka_detail.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:onepref/onepref.dart';
import '../include/bottom_menu.dart';
import '../include/checkInternet.dart';
import '../include/strings.dart';
import '../include/style.dart' as style;
import '../include/appbar.dart';
import '../models/ponuky_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/nointernet.dart';

class HomePageFree extends StatefulWidget {
  const HomePageFree({super.key});

  @override
  State<HomePageFree> createState() => _HomePageFreeState();
}

class _HomePageFreeState extends State<HomePageFree> {
  // INTERNET STATUS
  bool haveInternet = true;
  bool aktualnenacitavamponuky = false;
  // SCROLL CONTROLLER
  late final ScrollController _controller = ScrollController();
  // FIRST PAGE
  int pagenumber = 1;
  // CI BOLI PRVE PRISPEVKY NACITANE
  bool prvePrisevkyBoliNacitane = false;

  Future checkInternetFunction() async {
    if (await InternetConnectionChecker.instance.hasConnection) {
      if (prvePrisevkyBoliNacitane == false) {
        pagenumber = 1;
        loadAnotherPage(pagenumber);
        setState(() {
          pagenumber = 1;
        });
      }
      setState(() {
        haveInternet = true;
        prvePrisevkyBoliNacitane = true;
      });
    } else {
      setState(() {
        haveInternet = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Timer timer = Timer.periodic(Duration(seconds: 2), (Timer t) => checkInternetFunction());

    // NAčITAŤ PRVE PONUKY
    loadAnotherPage(pagenumber);

    // INFINITE SCROLLING
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          //print('At the top');
        } else {
          pagenumber++;
          loadAnotherPage(pagenumber);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  // dalšie načitane ponuka
  late List<ReceptyVypis> dalsiePonuky = [];
  List pagesLoaded = [];

  /// NACITAT DALSIE PONUKY DO POLA
  Future<void> loadAnotherPage(pagenumber) async {
    setState(() {
      aktualnenacitavamponuky = true;
    });

    var langurl = "";
    langurl = userLanguage = await lang().returnselectedValue();
    if (userLanguage == "cz") {
      langurl = "cs";
    }
    if (userLanguage == "at") {
      langurl = "de";
    }

    if (pagesLoaded.contains(pagenumber)) {
    } else {
      pagesLoaded.add(pagenumber);
    //final response = await http.get(Uri.parse("https://app.cestuje.me/" + langurl + "/ponukyfree_2.json?language=" + langurl + "&page=" + pagenumber.toString()));
    final response = await http.get(Uri.parse("https://app.cestuje.me/" + langurl + "/api/json_output?language=" + langurl + "&free=1&page=" + pagenumber.toString()));

    if (response.statusCode == 200) {
      setState(() {
        prvePrisevkyBoliNacitane = true;
      });
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      for (var json in parsed) {
        dalsiePonuky.add(
          ReceptyVypis(
            nid: json['nid'] as String,
            imageUrl: json['Image'] as String,
            pridane: json['pridane'] as String,
            krajina: json['kategorie'] as String,
            odletMonth: json['odletMonth'] as String,
            nazov_destinacie: json['nazov_destinacie'] as String,
            letecka_spol_logo: json['letecka_spol_logo'] as String,
            blizsie_info_php: json['blizsie_info_php'] as String,
            obojsmerny_let: json['obojsmerny_let'] as String,
            letenkyPHP: json['letenkyPHP'] as String,
            title: json['Title'] as String,
            banner: json['banner'] as String,
            viac_o_destinaci: json['viac_o_destinaci'] as String,
            galeria_destinacia: json['galeria_destinacia'] as String,
            fotka_lietadla: json['fotka_lietadla'] as String,
            prakticke_tipy_pre_cestovatelov: json['prakticke_tipy_pre_cestovatelov'] as String,
            vsetky_aktual_terminy_odkaz: json['vsetky_aktual_terminy_odkaz'] as String,
            vsetky_aktual_terminy_nadpis_tlac: json['vsetky_aktual_terminy_nadpis_tlac'] as String,
            vsetky_aktual_terminy_text: json['vsetky_aktual_terminy_text'] as String,
            galeria_ubytovanie: json['galeria_ubytovanie'] as String,
            dalsie_terminy: json['dalsie_terminy'] as String,
            screen_ubytovania: json['screen_ubytovania'] as String,
            tip_na_ubytovanie: json['tip_na_ubytovanie'] as String,
            tip_na_ubyt_odkaz: json['tip_na_ubyt_odkaz'] as String,
            tip_na_ubyt_nadpis_tlacidla: json['tip_na_ubyt_nadpis_tlacidla'] as String,
            tip_na_ubyt_nazov: json['tip_na_ubyt_nazov'] as String,
            cas_letu: json['cas_letu'] as String,
            textovy_popis_ponuky: json['textovy_popis_ponuky'] as String,
            letenky_len_za: json['letenky_len_za'] as String,
            nazov_letiska_odletu: json['nazov_letiska_odletu'] as String,
            nazov_letiska_priletu: json['nazov_letiska_priletu'] as String,
            text_usetrite_az: json['text_usetrite_az'] as String,
            ubytovanie_len_za: json['ubytovanie_len_za'] as String,
            usetrite_az: json['usetrite_az'] as String,
            x_dnovy_pobyt: json['x_dnovy_pobyt'] as String,
            kalendar_inych_letov_text: json['kalendar_inych_letov_text'] as String,
            kal_inych_letov_Odkaz: json['kal_inych_letov_Odkaz'] as String,
            kal_inych_letov_nadpis_tlacidla: json['kal_inych_letov_nadpis_tlacidla'] as String,
            kal_inych_letov_nazov: json['kal_inych_letov_nazov'] as String,
            free: json['free'] as String,
            nazov_letiska_priletu_suradnice: json['nazov_letiska_priletu_suradnice'] as String,
            nazov_letiska_odletu_suradnice: json['nazov_letiska_odletu_suradnice'] as String,
            pocasiedata: json['pocasiedata'] as String,
            datumdetail: json['datumdetail'] as String,
            ukazkovy_itinerar: json['ukazkovy_itinerar'] as String,
            banner_preplik: json['banner_preplik'] as String,
              banner_type: json['banner_type'] as String,
              banner_text: json['banner_text'] as String,
              banner_url: json['banner_url'] as String,
          ),
        );
      }
      setState(() {
        aktualnenacitavamponuky = false;
      });
    } else {
      setState(() {
        aktualnenacitavamponuky = false;
      });
    }
    }
  }

  // LOAD LANGUAGE
  String? userLanguage = "sk";
  int userLanguageLoaded = 0;
  Future<void> loadLang() async {
    userLanguage = await lang().returnselectedValue();
    setState(() {
      userLanguageLoaded = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userLanguageLoaded == 0) {
      loadLang();
    }

    return Scaffold(
      // appbar
      appBar: MainAppBar(userLanguage: userLanguage!),
      // body bg
      backgroundColor: style.MainAppStyle().bodyBG,
      // body
      body: Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/planeBg.png"),
            alignment: Alignment.topLeft,
          ),
        ),
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        constraints: const BoxConstraints.expand(),
        child: Stack(children: [
          RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.blue,
            onRefresh: () async {
              // redirect after refresh - pull to top
              Navigator.of(context).pushNamed("/home");
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // INTERNET CONDITION
                        (() {
                          if (haveInternet == true || haveInternet == false && prvePrisevkyBoliNacitane == true) {
                            /*  // loader
                            if (dalsiePonuky.isEmpty) {
                              return Center(child: CircularProgressIndicator());
                            }*/

                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: dalsiePonuky.length,
                                itemBuilder: (BuildContext context, index) {
                                  ReceptyVypis ponukaRow = dalsiePonuky[index];
                                  return ponukaRow.banner_type.isNotEmpty && ponukaRow.banner_type == "Zobraziť všetkým" ||
                                          ponukaRow.banner_type.isNotEmpty && ponukaRow.banner_type == "Zobraziť len plateným" && OnePref.getPremium() == true ||
                                          ponukaRow.banner_type.isNotEmpty && ponukaRow.banner_type == "Zobraziť len neplateným" && OnePref.getPremium() == false
                                      ? Container(
                                          margin: EdgeInsets.fromLTRB(3, 3, 3, 20),
                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                                          decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            color: Color.fromRGBO(205, 236, 204, 1),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(239, 241, 243, 1),
                                                spreadRadius: 0,
                                                blurRadius: 0,
                                                offset: Offset(-5, 5),
                                              ),
                                            ],
                                          ),
                                          child: InkWell(
                                            child: Html(
                                              data: ponukaRow.banner_text,
                                              style: {
                                                "body": Style(
                                                  margin: Margins.all(0),
                                                ),
                                                "p": Style(
                                                  padding: HtmlPaddings.all(0),
                                                  fontSize: FontSize(14),
                                                  lineHeight: LineHeight(1.6),
                                                  fontWeight: FontWeight.w400,
                                                )
                                              },
                                            ),
                                            onTap: () async {
                                              if (ponukaRow.banner_preplik == "Stránka platenia") {
                                                Navigator.of(context).popAndPushNamed("/paymentpage");
                                              }
                                              if (ponukaRow.banner_preplik == "URL") {
                                                if (!await launchUrl(Uri.parse(ponukaRow.banner_url), mode: LaunchMode.externalApplication)) {}
                                              }
                                            },
                                          ),
                                        ) : Container( child: ponukaRow.banner_type.isNotEmpty ? Container()
                                      :  GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ReceptScreen(
                                          ponuka: ponukaRow,
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      // main box
                                      margin: EdgeInsets.fromLTRB(3, 3, 3, 20),
                                      padding: EdgeInsets.all(0),
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.circular(10.0),
                                        color: ponukaRow.free != "0" ? Colors.white : Color.fromRGBO(249, 242, 218, 1),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(239, 241, 243, 1),
                                            spreadRadius: 0,
                                            blurRadius: 0,
                                            offset: Offset(-5, 5),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // hlavna fotka
                                          Stack(children: [
                                            ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(15.0),
                                            ),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                // Načítavacie koliečko
                                                const CircularProgressIndicator(),

                                                // Obrázok s načítavaním
                                                Image.network(
                                                  ponukaRow.imageUrl,
                                                  height: 200.0,
                                                  width: MediaQuery.of(context).size.width,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return const Center(child: CircularProgressIndicator());
                                                  },
                                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                    return const Icon(Icons.error); // Ikona chyby, ak načítanie zlyhá
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                            // usetrite az
                                            ponukaRow.text_usetrite_az.isNotEmpty
                                                ? Padding(
                                                    padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                                                    child: Container(
                                                        padding: EdgeInsets.fromLTRB(20.0, 13.0, 20.0, 13.0),
                                                        decoration: new BoxDecoration(
                                                          color: Color.fromRGBO(0, 0, 0, 0.5),
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        child: Text(
                                                          '${lang().returnString(userLanguage!, "vypis_usertriteat")} ${ponukaRow.text_usetrite_az}/${lang().returnString(userLanguage!, "vypis_osoba")}',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        )),
                                                  )
                                                : Container(),
                                            // lock icon
                                            ponukaRow.free == "0" && OnePref.getPremium() == false
                                                ? Align(
                                                    alignment: AlignmentDirectional.topEnd,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child: Container(
                                                        padding: EdgeInsets.all(10.0),
                                                        decoration: new BoxDecoration(
                                                          color: Color.fromRGBO(255, 202, 45, 1),
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        child: Image.asset(height: 22.0, "lib/assets/images/lockicon.png"),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            ponukaRow.free == "1" && OnePref.getPremium() == false
                                                ? Align(
                                                    alignment: AlignmentDirectional.topEnd,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child: Container(
                                                        padding: EdgeInsets.all(10.0),
                                                        decoration: new BoxDecoration(
                                                          color: Color.fromRGBO(158, 223, 141, 1),
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        child: Image.asset(height: 22.0, "lib/assets/images/lockiconOpen.png"),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            Align(
                                              alignment: AlignmentDirectional.topEnd,
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 0.0, top: 125.0),
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(15.0, 13.0, 20.0, 13.0),
                                                  decoration: new BoxDecoration(
                                                    color: Color.fromRGBO(255, 255, 255, 1),
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Image.asset(height: 22.0, "lib/assets/images/pin.png"),
                                                      SizedBox(width: 10.0),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          ponukaRow.krajina.isNotEmpty
                                                              ? Text(
                                                                  ponukaRow.krajina.length > 20 ? ponukaRow.krajina.substring(0, 20) + '...' : ponukaRow.krajina,
                                                                  style: TextStyle(
                                                                    color: Color.fromRGBO(45, 92, 117, 1),
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                )
                                                              : Container(),
                                                          ponukaRow.nazov_destinacie.isNotEmpty
                                                              ? Text(
                                                                  ponukaRow.nazov_destinacie,
                                                                  style: TextStyle(
                                                                    color: Color.fromRGBO(45, 92, 117, 1),
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]),

                                          // fieldset
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          ponukaRow.letenky_len_za.isNotEmpty
                                                              ? Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    ponukaRow.obojsmerny_let.isNotEmpty
                                                                        ? Image.asset(height: 22.0, "lib/assets/images/ponuka_planes_back.png")
                                                                        : Image.asset(height: 22.0, "lib/assets/images/ponuka_planes_back_single.png"),
                                                                    SizedBox(width: 10.0),
                                                                    Text(
                                                                      '${lang().returnString(userLanguage!, "vypis_lenza")} ${ponukaRow.letenky_len_za}',
                                                                      style: TextStyle(
                                                                        fontSize: 12.0,
                                                                        color: style.MainAppStyle().mainColor,
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              : Container(),
                                                          ponukaRow.ubytovanie_len_za.isNotEmpty
                                                              ? Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Image.asset(height: 22.0, "lib/assets/images/ponuka_home.png"),
                                                                    SizedBox(width: 10.0),
                                                                    Text(
                                                                      '${lang().returnString(userLanguage!, "vypis_lenza")} ${ponukaRow.ubytovanie_len_za}',
                                                                      style: TextStyle(
                                                                        fontSize: 12.0,
                                                                        color: style.MainAppStyle().mainColor,
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                      SizedBox(height: 20.0),
                                                      Text(
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        '${lang().returnString(userLanguage!, "vypis_pridane")}: ${ponukaRow.pridane}',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Color.fromRGBO(171, 171, 171, 1),
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8.0),
                                                      Text(
                                                        ponukaRow.title,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          height: 1.3,
                                                          fontSize: 16.0,
                                                          fontWeight: FontWeight.w600,
                                                          color: Color.fromRGBO(45, 92, 117, 1),
                                                        ),
                                                      ),
                                                      SizedBox(height: 20.0),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            ponukaRow.odletMonth,
                                                            style: TextStyle(
                                                              fontSize: 13.0,
                                                              color: style.MainAppStyle().mainColor,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
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
                                                              '${ponukaRow.nazov_letiska_odletu} > ${ponukaRow.nazov_letiska_priletu.length > 20 ? ponukaRow.nazov_letiska_priletu.substring(0, 20) + '...' : ponukaRow.nazov_letiska_priletu}',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                                });
                          } else {
                            return NoInternet();
                          }
                        }()),

                        aktualnenacitavamponuky
                            ? Column(
                                children: [
                                  Center(child: CircularProgressIndicator()),
                                ],
                              )
                            : Container(),

                        SizedBox(height: 50.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // CHECK INTERNET
          const CheckInternetClass(),
        ]),
      ),
      /* BOTTOM MENU */
      bottomNavigationBar: const bottomMenu(
        index: 2,
      ),
    );
  }
}
