import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onepref/onepref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'package:maps_curved_line/maps_curved_line.dart';
import '../include/appbar.dart';
import '../include/bottom_menu.dart';
import '../include/checkInternet.dart';
import '../include/strings.dart';
import '../include/style.dart' as style;
import 'package:http/http.dart' as http;
import '../models/ponuky_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as markerMaps;
import '../widgets/dialog.dart';

class ReceptScreen extends StatefulWidget {
  final ReceptyVypis ponuka;

  ReceptScreen({required this.ponuka});

  @override
  State<ReceptScreen> createState() => _ReceptScreenState();
}

class _ReceptScreenState extends State<ReceptScreen> {
  // ZOBRAZIT CELY TEXT BOOL
  bool descTextShowFlag = false;
  bool viacoDestTextShowFlag = false;
  bool ukazkovyItinerarTextShowFlag = false;
  List<markerMaps.Marker> markers = [];

  loadMarkers() async {

    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)), isIOS ? 'lib/assets/images/pinnew.png' : 'lib/assets/images/pinmap.png').then((d) {
      setState(() {
        markers.add(markerMaps.Marker(
            markerId: const MarkerId("marker1"),
            position: LatLng(double.parse(widget.ponuka.nazov_letiska_odletu_suradnice.split(', ')[0]), double.parse(widget.ponuka.nazov_letiska_odletu_suradnice.split(', ')[1])),
            infoWindow: InfoWindow(title: widget.ponuka.nazov_letiska_odletu),
            icon: d));

        markers.add(markerMaps.Marker(
            markerId: const MarkerId("marker2"),
            position: LatLng(double.parse(widget.ponuka.nazov_letiska_priletu_suradnice.split(', ')[0]), double.parse(widget.ponuka.nazov_letiska_priletu_suradnice.split(', ')[1])),
            infoWindow: InfoWindow(title: widget.ponuka.nazov_letiska_priletu),
            icon: d));
      });
    });
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

  CarouselSliderController controller = CarouselSliderController();
  CarouselSliderController controller2 = CarouselSliderController();
  int active_gallery_1 = 0;
  int active_gallery_2 = 0;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _targetKey = GlobalKey();

  // promoCodes
  bool havePromoCode = false;
  bool checkPromoCode = false;
  Future<Null> getPromoCode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      havePromoCode = prefs.getBool("promoCode") ?? false;
      checkPromoCode = true;
    });
    if (havePromoCode) {
      OnePref.setPremium(true);
    }

    //////////////////////////////////////////////////////////////////////////////////// test - vymazat
    //OnePref.setPremium(true);
    //////////////////////////////////////////////////////////////////////////////////// test - vymazat
  }

   List<dynamic> pocasiedata = [];
  List<dynamic> blizsie_info_php = [];
  List<dynamic> letenkyPHP = [];
  final List<String> imgListUbytovanie = [];
  final List<String> imgList = [];

  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();

    // galeria destinacia
    final splitGaleria_destinacia = widget.ponuka.galeria_destinacia.split(',');

    for (int i = 0; i < splitGaleria_destinacia.length; i++) {
      imgList.add(splitGaleria_destinacia[i]);
    }

    // galeria ubytovanie
    final splitGaleria_ubytovanie = widget.ponuka.galeria_ubytovanie.split(',');

    for (int i = 0; i < splitGaleria_ubytovanie.length; i++) {
      imgListUbytovanie.add(splitGaleria_ubytovanie[i]);
    }

    if (widget.ponuka.blizsie_info_php.isNotEmpty) {
      blizsie_info_php = jsonDecode(widget.ponuka.blizsie_info_php);
    }
    if (widget.ponuka.letenkyPHP.isNotEmpty) {
      letenkyPHP = jsonDecode(widget.ponuka.letenkyPHP);
    }
    if (widget.ponuka.pocasiedata.isNotEmpty) {
      pocasiedata = jsonDecode(widget.ponuka.pocasiedata);
    }
    int ponukafree = jsonDecode(widget.ponuka.free);

    // Polyline

    if(widget.ponuka.nazov_letiska_priletu_suradnice != ""){
         var location1 = LatLng(double.parse(widget.ponuka.nazov_letiska_priletu_suradnice.split(', ')[0]), double.parse(widget.ponuka.nazov_letiska_priletu_suradnice.split(', ')[1]));
        var location2 = LatLng(double.parse(widget.ponuka.nazov_letiska_odletu_suradnice.split(', ')[0]), double.parse(widget.ponuka.nazov_letiska_odletu_suradnice.split(', ')[1]));
        
        polylinesDraw(location1, location2);
    }
    
   
  }


  polylinesDraw(location1, location2) async {
    polylines.add(Polyline(
      polylineId: PolylineId(location1.toString()),
      visible: true,
      width: 2,
      points: [
      location1,
      location2,
      ],
      color: Colors.blue,
    ));


  setState(() {
  //refresh UI
  });
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    List<String> postupList;
    // MAP


    if (userLanguageLoaded == 0) {
      loadLang();
    }
    if (checkPromoCode == false) {
      // get Promo code
    getPromoCode();
    }
    

    

    return Scaffold(
      // appbar
      //appBar: MainAppBar(userLanguage: userLanguage!),
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: style.MainAppStyle().bodyBG,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
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
            ),
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
                    fontSize: 18.0,
                    color: style.MainAppStyle().mainColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  lang().returnString(userLanguage!, "appbar_title2"),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Color.fromRGBO(101, 141, 164, 1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: style.MainAppStyle().bodyBG,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // head
                Stack(
                  children: [
                    Container(
                      height: 280.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0.0, 2.0),
                          ),
                        ],
                      ),
                      child: Hero(
                        tag: widget.ponuka.imageUrl,
                        child: ClipRRect(
                          child: Image.network(
                            widget.ponuka.imageUrl,
                            height: 140.0,
                            width: 140.0,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return SizedBox(
                                height: 140.0,
                                width: 140.0,
                                child: const Center(child: CircularProgressIndicator()),
                              );
                            },
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return SizedBox(
                                height: 140.0,
                                width: 140.0,
                                child: const Icon(Icons.error, size: 50), // Veľkosť ikony môžeš upraviť podľa potreby
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    /*  Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 20.0),
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
                    widget.ponuka.text_usetrite_az.isNotEmpty
                        ? Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20.0, top: 24.0),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(20.0, 13.0, 20.0, 13.0),
                                decoration: new BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  '${lang().returnString(userLanguage!, "vypis_usertriteat")} ${widget.ponuka.text_usetrite_az}/${lang().returnString(userLanguage!, "vypis_osoba")}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0.0, top: 160.0),
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
                                  widget.ponuka.krajina.isNotEmpty
                                      ? Text(
                                          widget.ponuka.krajina,
                                          style: TextStyle(
                                            color: Color.fromRGBO(45, 92, 117, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      : Container(),
                                  widget.ponuka.nazov_destinacie.isNotEmpty
                                      ? Text(
                                          widget.ponuka.nazov_destinacie,
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
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0.0, top: 225.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(20.0),
                          decoration: new BoxDecoration(
                            color: widget.ponuka.free == "0" && OnePref.getPremium() == false ? Color.fromRGBO(249, 242, 218, 1) : Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  widget.ponuka.letenky_len_za.isNotEmpty
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            widget.ponuka.obojsmerny_let.isNotEmpty
                                                ? Image.asset(height: 22.0, "lib/assets/images/ponuka_planes_back.png")
                                                : Image.asset(height: 22.0, "lib/assets/images/ponuka_planes_back_single.png"),
                                            SizedBox(width: 10.0),
                                            Text(
                                              '${lang().returnString(userLanguage!, "vypis_lenza")} ${widget.ponuka.letenky_len_za}',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: style.MainAppStyle().mainColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  widget.ponuka.ubytovanie_len_za.isNotEmpty
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(height: 22.0, "lib/assets/images/ponuka_home.png"),
                                            SizedBox(width: 10.0),
                                            Text(
                                              '${lang().returnString(userLanguage!, "vypis_lenza")} ${widget.ponuka.ubytovanie_len_za}',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: style.MainAppStyle().mainColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                '${lang().returnString(userLanguage!, "vypis_pridane")}:  ${widget.ponuka.pridane}',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color.fromRGBO(171, 171, 171, 1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '${widget.ponuka.title}',
                                style: TextStyle(
                                  height: 1.3,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(45, 92, 117, 1),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              OnePref.getPremium() == true || widget.ponuka.free == "1"
                                  ? Text(
                                      '${lang().returnString(userLanguage!, "detail_termin")}: ${widget.ponuka.datumdetail}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        height: 1.3,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: style.MainAppStyle().mainColor,
                                      ),
                                    )
                                  : Container(),
                              SizedBox(height: 20.0),
                              GestureDetector(
                                onTap: () {
                                  if (_targetKey.currentContext != null) {
                                    final RenderBox renderBox = _targetKey.currentContext!.findRenderObject() as RenderBox;
                                    final position = renderBox.localToGlobal(Offset.zero);

                                    // Poscrolluj na pozíciu cieľového widgetu s odpočítaním 100px (alebo inej hodnoty)
                                    _scrollController.animateTo(
                                      _scrollController.offset + position.dy - 145, // Scroll o 100px menej
                                      duration: Duration(seconds: 1),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(15.0, 13.0, 15.0, 13.0),
                                  decoration: new BoxDecoration(
                                    border: Border.all(color: style.MainAppStyle().mainColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${widget.ponuka.nazov_letiska_odletu} > ${widget.ponuka.nazov_letiska_priletu}',
                                    style: TextStyle(
                                      color: style.MainAppStyle().mainColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              widget.ponuka.letecka_spol_logo.isNotEmpty && OnePref.getPremium() == true || widget.ponuka.letecka_spol_logo.isNotEmpty && widget.ponuka.free == "1"
                                  ? Image.network(
                                      widget.ponuka.letecka_spol_logo,
                                      height: 50.0,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return SizedBox(
                                          height: 50.0,
                                          width: 50.0, // Prispôsobené rovnakým rozmerom ako výška
                                          child: const Center(child: CircularProgressIndicator()),
                                        );
                                      },
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return SizedBox(
                                          height: 50.0,
                                          width: 50.0, // Rovnaké rozmery ako obrázok
                                          child: const Center(child: Icon(Icons.error, size: 24)), // Veľkosť ikony môžeš prispôsobiť
                                        );
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /**
                     * BLEDO ZELENY PASIK
                     */
                      widget.ponuka.x_dnovy_pobyt.isNotEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(15.0),
                              decoration: new BoxDecoration(
                                color: Color.fromRGBO(114, 182, 96, 1),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(height: 45.0, "lib/assets/images/bledozelena-icon.png"),
                                  SizedBox(width: 20.0),
                                  Flexible(
                                    child: Text(
                                      widget.ponuka.x_dnovy_pobyt,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        height: 1.6,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      SizedBox(height: 20.0),

                      /**
                     * TMAVO ZELENY PASIK
                     */
                      widget.ponuka.usetrite_az.isNotEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(15.0),
                              decoration: new BoxDecoration(
                                color: Color.fromRGBO(45, 124, 99, 1),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.ponuka.usetrite_az,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        height: 1.6,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20.0),
                                  Image.asset(height: 45.0, "lib/assets/images/tmavozelena-icon.png"),
                                ],
                              ),
                            )
                          : Container(),
                      SizedBox(height: 20.0),
                      /**
                     * Textový popis ponuky
                     */

                      widget.ponuka.textovy_popis_ponuky.isNotEmpty && OnePref.getPremium() == true || widget.ponuka.textovy_popis_ponuky.isNotEmpty && widget.ponuka.free == "1"
                          ? Html(
                              data: widget.ponuka.textovy_popis_ponuky,
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
                              onLinkTap: (url, _, __) async {
                                          if (!await launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication)) {
                                            // throw Exception('Could not launch url');
                                          }
                                        },
                            )
                          : Container(),
                      OnePref.getPremium() == true || widget.ponuka.free == "1"
                          ? Column(
                            key: _targetKey, // Pridaj kľúč pre cieľový container
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20.0),
                                Text(
                                  '${lang().returnString(userLanguage!, "detail_letenkykupitetu")}: ',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(22, 97, 174, 1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 15.0),
                                /**
                         * LETENKY
                         */
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // row
                                    widget.ponuka.letenkyPHP.isNotEmpty
                                        ? Column(
                                            children: List.generate(letenkyPHP.length, (index) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  padding: const EdgeInsets.all(15.0),
                                                  decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(234, 238, 242, 1),
                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              letenkyPHP[index]['nadpis'],
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                                height: 1.6,
                                                                color: style.MainAppStyle().colorText,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                            Text(
                                                              letenkyPHP[index]['field_podnadpisletenky'],
                                                              style: TextStyle(
                                                                fontSize: 11.0,
                                                                height: 1.6,
                                                                color: style.MainAppStyle().colorText,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 15.0),
                                                      Row(
                                                        children: [
                                                          letenkyPHP[index]['fotka_letenky'].isNotEmpty
                                                              ? InkWell(
                                                                  child: Container(
                                                                    padding: const EdgeInsets.all(7.0),
                                                                    decoration: const BoxDecoration(
                                                                      color: Color.fromRGBO(255, 255, 255, 1),
                                                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                                    ),
                                                                    child: Image.asset(height: 20.0, "lib/assets/images/cameraletenky.png"),
                                                                  ),
                                                                  onTap: () async {
                                                                    showDialog(
                                                                        context: context,
                                                                        builder: (BuildContext context) {
                                                                          return CustomDialogBox(
                                                                            title: '${lang().returnString(userLanguage!, "ukazka_leteniek_z")} ${widget.ponuka.pridane}',
                                                                            type: "image",
                                                                            mainIcon: "cameraletenky",
                                                                            descriptions: letenkyPHP[index]['fotka_letenky'],
                                                                          );
                                                                        });
                                                                  },
                                                                )
                                                              : Container(),
                                                          const SizedBox(width: 10.0),
                                                          Container(
                                                            padding: const EdgeInsets.fromLTRB(10.0, 13.0, 10.0, 13.0),
                                                            decoration: BoxDecoration(
                                                              gradient: const LinearGradient(
                                                                colors: [
                                                                  Color.fromRGBO(22, 97, 174, 1),
                                                                  Color.fromRGBO(20, 153, 208, 1),
                                                                ],
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                              ),
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: InkWell(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    letenkyPHP[index]['field_nadpis_linku'].toUpperCase(),
                                                                    style: const TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 10,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 5.0),
                                                                  Image.asset(height: 15.0, "lib/assets/images/external-link.png"),
                                                                ],
                                                              ),
                                                              onTap: () async {
                                                                if (!await launchUrl(Uri.parse(letenkyPHP[index]['field_link']), mode: LaunchMode.externalApplication)) {
                                                                  // throw Exception('Could not launch url');
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 15.0),
                                                letenkyPHP[index]['fotka_letenky'].isNotEmpty
                                                              ? 
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Image.asset(height: 20.0, "lib/assets/images/cameraletenky.png"),
                                                          SizedBox(width: 15.0),
                                                          Text(
                                                            '${lang().returnString(userLanguage!, "ukazka_leteniek_z")} ${widget.ponuka.pridane}',
                                                            style: const TextStyle(
                                                              color: Color.fromRGBO(22, 97, 174, 1),
                                                              fontWeight: FontWeight.w500,
                                                              decoration: TextDecoration.underline,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      onTap: () async {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return CustomDialogBox(
                                                                title: '${lang().returnString(userLanguage!, "ukazka_leteniek_z")} ${widget.ponuka.pridane}',
                                                                type: "image",
                                                                mainIcon: "cameraletenky",
                                                                descriptions: letenkyPHP[index]['fotka_letenky'],
                                                              );
                                                            });
                                                      },
                                                    ),
                                                    
                                                SizedBox(height: 25.0),
                                                  ],
                                                ) : Container(),
                                              ],
                                            );
                                          }))
                                        : Container(),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(height: 20.0),
                      /**
                     * KALENDAR TERMINOV
                     */
                      widget.ponuka.kal_inych_letov_nadpis_tlacidla.isNotEmpty && OnePref.getPremium() == true || widget.ponuka.kal_inych_letov_nadpis_tlacidla.isNotEmpty && widget.ponuka.free == "1"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      // row
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.ponuka.kal_inych_letov_nazov,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    height: 1.6,
                                                    color: style.MainAppStyle().colorText,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 15.0),
                                          Row(
                                            children: [
                                              widget.ponuka.kalendar_inych_letov_text.isNotEmpty
                                                  ? InkWell(
                                                      child: Container(
                                                        padding: const EdgeInsets.all(7.0),
                                                        decoration: new BoxDecoration(
                                                          color: Color.fromRGBO(220, 229, 238, 1),
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                        ),
                                                        child: Image.asset(height: 25.0, "lib/assets/images/info.png"),
                                                      ),
                                                      onTap: () async {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return CustomDialogBox(
                                                                mainIcon: "",
                                                                type: "text",
                                                                title: widget.ponuka.kal_inych_letov_nazov,
                                                                descriptions: widget.ponuka.kalendar_inych_letov_text,
                                                              );
                                                            });
                                                      },
                                                    )
                                                  : Container(),
                                              SizedBox(width: 10.0),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(10.0, 13.0, 10.0, 13.0),
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
                                                child: InkWell(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        widget.ponuka.kal_inych_letov_nadpis_tlacidla.toUpperCase(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5.0),
                                                      Image.asset(height: 15.0, "lib/assets/images/external-link.png"),
                                                    ],
                                                  ),
                                                  onTap: () async {
                                                    if (!await launchUrl(Uri.parse(widget.ponuka.kal_inych_letov_Odkaz), mode: LaunchMode.externalApplication)) {
                                                      // throw Exception('Could not launch url');
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 40.0),
                              ],
                            )
                          : Container(),

                     /**
                     * VYHODY TEXT - NEZAPLATENY
                     */
                      OnePref.getPremium() == false && widget.ponuka.free == "0"
                          ? Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: new BoxDecoration(
                                    color: Color.fromRGBO(205, 236, 204, 1),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      // row
                                      Html(
                                        data: '${lang().returnString(userLanguage!, "infodetailnopaymenttext")}',
                                        style: {
                                          "body": Style(
                                            margin: Margins.all(0),
                                            fontSize: FontSize(15),
                                            color: Color.fromRGBO(75, 144, 73, 1),
                                            fontWeight: FontWeight.w400,
                                            lineHeight: LineHeight(1.5),
                                          ),
                                          "hr": Style(
                                            margin: Margins.only(top: 20, bottom: 20),
                                            border: Border.all(color: Color.fromRGBO(75, 144, 73, 1)),
                                            height: Height(1),
                                          ),
                                          "li": Style(
                                            margin: Margins.all(0),
                                            listStylePosition: ListStylePosition.outside,
                                            listStyleImage: ListStyleImage(""),
                                            lineHeight: LineHeight.number(1.2),
                                          ),
                                          "ul": Style(
                                            padding: HtmlPaddings.only(left: 0),
                                            margin: Margins.only(bottom: 20),
                                            listStyleType: ListStyleType.circle,
                                            lineHeight: LineHeight.number(1.2),
                                          ),
                                          "h3": Style(
                                            margin: Margins.only(top: 0, bottom: 5, left: 0, right: 0),
                                            fontWeight: FontWeight.w400,
                                            fontSize: FontSize(14),
                                          ),
                                          "p": Style(
                                            margin: Margins.only(top: 0, bottom: 10, left: 0, right: 0),
                                            padding: HtmlPaddings.all(0),
                                            fontSize: FontSize(17),
                                            color: Color.fromRGBO(75, 144, 73, 1),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        },
                                       onLinkTap: (url, _, __) async {
                                          if (!await launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication)) {
                                            // throw Exception('Could not launch url');
                                          }
                                        },
                                      ),
                                      SizedBox(height: 30.0),
                                      Image.asset(height: 50.0, "lib/assets/images/apple_pay2.png"),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed("/paymentpage");
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(20.0),
                                          width: MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.all(20.0),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
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
                                            '${lang().returnString(userLanguage!, "button_predplatit_detail")}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            )
                          : Container(),

                      /**
                     * mapka
                     */
                   
                       widget.ponuka.nazov_letiska_priletu_suradnice != ""
                          ? Transform.scale(
                              scale: 1.15,
                              child: Column(children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width + 40,
                                  height: 250,
                                  child: GoogleMap(
                                    myLocationButtonEnabled: false,
                                    mapToolbarEnabled: false,
                                    zoomControlsEnabled: false,
                                    gestureRecognizers: {Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())},
                                    onMapCreated: (GoogleMapController controller) {
                                      controller.setMapStyle(
                                          '[{"featureType":"water","elementType":"geometry","stylers":[{"color":"#e9e9e9"},{"lightness":17}]},{"featureType":"landscape","elementType":"geometry","stylers":[{"color":"#f5f5f5"},{"lightness":20}]},{"featureType":"road.highway","elementType":"geometry.fill","stylers":[{"color":"#ffffff"},{"lightness":17}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#ffffff"},{"lightness":29},{"weight":0.2}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#ffffff"},{"lightness":18}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#ffffff"},{"lightness":16}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#f5f5f5"},{"lightness":21}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#dedede"},{"lightness":21}]},{"elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":"#ffffff"},{"lightness":16}]},{"elementType":"labels.text.fill","stylers":[{"saturation":36},{"color":"#333333"},{"lightness":40}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#f2f2f2"},{"lightness":19}]},{"featureType":"administrative","elementType":"geometry.fill","stylers":[{"color":"#fefefe"},{"lightness":20}]},{"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#fefefe"},{"lightness":17},{"weight":1.2}]}]');

                                      // load markers
                                      loadMarkers();

                                      // the bounds you want to set
                                      LatLngBounds bounds = LatLngBounds(
                                        southwest: LatLng(double.parse(widget.ponuka.nazov_letiska_priletu_suradnice.split(', ')[0]), double.parse(widget.ponuka.nazov_letiska_priletu_suradnice.split(', ')[1])),
                                        northeast: LatLng(double.parse(widget.ponuka.nazov_letiska_odletu_suradnice.split(', ')[0]), double.parse(widget.ponuka.nazov_letiska_odletu_suradnice.split(', ')[1])),
                                      );
                                      // calculating centre of the bounds
                                      LatLng centerBounds = LatLng((bounds.northeast.latitude + bounds.southwest.latitude) / 2, (bounds.northeast.longitude + bounds.southwest.longitude) / 2);

                                      // setting map position to centre to start with
                                      controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                        target: centerBounds,
                                      )));
                                      zoomToFit(controller, bounds, centerBounds);


                                    },
                                    initialCameraPosition: CameraPosition(target: LatLng(double.parse(widget.ponuka.nazov_letiska_priletu_suradnice.split(', ')[0]), double.parse(widget.ponuka.nazov_letiska_priletu_suradnice.split(', ')[1])), zoom: 1.3),
                                    markers: markers.toSet(),
                                    polylines: polylines,
                                    /*polylines: {
                                      Polyline(
                                        polylineId: PolylineId('1'),
                                        color: Colors.blue,
                                        width: 2,
                                        patterns: [
                                          PatternItem.dash(7),
                                          PatternItem.gap(15),
                                        ],
                                        points: [
                                          LatLng(double.parse(widget.ponuka.nazov_letiska_priletu_suradnice.split(', ')[0]), double.parse(widget.ponuka.nazov_letiska_priletu_suradnice.split(', ')[1])),
                                          LatLng(double.parse(widget.ponuka.nazov_letiska_odletu_suradnice.split(', ')[0]), double.parse(widget.ponuka.nazov_letiska_odletu_suradnice.split(', ')[1]))
                                        ],
                                      ),
                                    },*/
                                  ),
                                )
                              ]),
                            )
                          : Container(),


                      /**
                     * trvanie
                     */
                      widget.ponuka.cas_letu.isNotEmpty
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                //margin: EdgeInsets.only(right: 40.0),
                                padding: EdgeInsets.fromLTRB(15.0, 13.0, 15.0, 13.0),
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: style.MainAppStyle().mainColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${lang().returnString(userLanguage!, "detail_trvanieletu")}: ${widget.ponuka.cas_letu} ${lang().returnString(userLanguage!, "flight_duration")}',
                                  style: TextStyle(
                                    color: style.MainAppStyle().mainColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 30.0),

                      /**
                     * Tip na ubytovanie
                     */
                      widget.ponuka.tip_na_ubytovanie.isNotEmpty && OnePref.getPremium() == true || widget.ponuka.tip_na_ubytovanie.isNotEmpty && widget.ponuka.free == "1"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${lang().returnString(userLanguage!, "detail_tipnaubytovanie")}:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(22, 97, 174, 1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Html(
                                  data: widget.ponuka.tip_na_ubytovanie,
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
                                SizedBox(height: 20.0),
                              ],
                            )
                          : Container(),

                      /**
                     * Tip na ubytovanie tlačidlo
                     */
                      widget.ponuka.tip_na_ubyt_nadpis_tlacidla.isNotEmpty && OnePref.getPremium() == true || widget.ponuka.tip_na_ubyt_nadpis_tlacidla.isNotEmpty && widget.ponuka.free == "1"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${lang().returnString(userLanguage!, "detail_ubytovaniekupitetu")}:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(22, 97, 174, 1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: new BoxDecoration(
                                    color: Color.fromRGBO(234, 238, 242, 1),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      // row
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.ponuka.tip_na_ubyt_nazov,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    height: 1.6,
                                                    color: style.MainAppStyle().colorText,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 15.0),
                                          Row(
                                            children: [
                                              widget.ponuka.screen_ubytovania.isNotEmpty
                                                  ? InkWell(
                                                      child: Container(
                                                        padding: const EdgeInsets.all(7.0),
                                                        decoration: new BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                        ),
                                                        child: Image.asset(height: 25.0, "lib/assets/images/ubytovanienewicon.png"),
                                                      ),
                                                      onTap: () async {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return CustomDialogBox(
                                                                mainIcon: "",
                                                                title: lang().returnString(userLanguage!, "detail_tipnaubytovanie"),
                                                                type: "image",
                                                                descriptions: widget.ponuka.screen_ubytovania,
                                                              );
                                                            });
                                                      },
                                                    )
                                                  : Container(),
                                              SizedBox(width: 10.0),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(10.0, 13.0, 10.0, 13.0),
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Color.fromRGBO(22, 97, 174, 1),
                                                      Color.fromRGBO(20, 153, 208, 1),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: InkWell(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        widget.ponuka.tip_na_ubyt_nadpis_tlacidla.toUpperCase(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5.0),
                                                      Image.asset(height: 15.0, "lib/assets/images/external-link.png"),
                                                    ],
                                                  ),
                                                  onTap: () async {
                                                    if (!await launchUrl(Uri.parse(widget.ponuka.tip_na_ubyt_odkaz), mode: LaunchMode.externalApplication)) {
                                                      // throw Exception('Could not launch url');
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                widget.ponuka.screen_ubytovania.isNotEmpty ?
                                Column(
                                  children: [
                                    InkWell(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(height: 20.0, "lib/assets/images/cameraletenky.png"),
                                          SizedBox(width: 15.0),
                                          Text(
                                            '${lang().returnString(userLanguage!, "ukazka_ubytovania_z")} ${widget.ponuka.pridane}',
                                            style: const TextStyle(
                                              color: Color.fromRGBO(22, 97, 174, 1),
                                              fontWeight: FontWeight.w500,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomDialogBox(
                                                title: '${lang().returnString(userLanguage!, "ukazka_ubytovania_z")} ${widget.ponuka.pridane}',
                                                type: "image",
                                                mainIcon: "cameraletenky",
                                                descriptions: widget.ponuka.screen_ubytovania,
                                              );
                                            });
                                      },
                                    ),
                                    
                                    SizedBox(height: 25.0),
                                  ],
                                ) : Container(),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),

               /**
             * GALERIA UBYTOVANIE
             */
            imgListUbytovanie.length > 1 && OnePref.getPremium() == true || imgListUbytovanie.length > 1 && widget.ponuka.free == "1"
                ? Column(
                    children: [
                      CarouselSlider.builder(
                        carouselController: controller2,
                        itemCount: imgListUbytovanie.length,
                        options: CarouselOptions(
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.3,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (val, _) {
                            setState(() {
                              active_gallery_2 = val;
                            });
                          },
                        ),
                        itemBuilder: (context, index, realIdx) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              // Načítavacie koliečko
                              const CircularProgressIndicator(),

                              // Obrázok s podmienkou na načítanie
                              Image.network(
                                imgListUbytovanie[index],
                                fit: BoxFit.cover,
                                width: 1000,
                                loadingBuilder: (BuildContext context, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (BuildContext context, Object exception,
                                    StackTrace? stackTrace) {
                                  return const Icon(Icons.error); // Zobrazí ikonu, ak obrázok zlyhá
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < imgListUbytovanie.length; i++)
                            InkWell(
                              onTap: () {
                                controller2.animateToPage(i);
                              },
                              child: Container(
                                margin: EdgeInsets.all(4),
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: active_gallery_2 == i
                                      ? Color(0xff000000)
                                      : Color.fromARGB(255, 201, 201, 201),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  )
                : Container(),
                SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /**
                     * dalsie terminy
                     */
                      widget.ponuka.dalsie_terminy.length > 0 && OnePref.getPremium() == true || widget.ponuka.dalsie_terminy.length > 0 && widget.ponuka.free == "1"
                          ? Column(
                              children: [
                                Text(
                                  '${lang().returnString(userLanguage!, "detail_dalsieterminy")}:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(22, 97, 174, 1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                              ],
                            )
                          : Container(),

                      /**
                     * Dalšie terminy
                     */
                      widget.ponuka.dalsie_terminy.isNotEmpty && OnePref.getPremium() == true || widget.ponuka.dalsie_terminy.isNotEmpty && widget.ponuka.free == "1"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Html(
                                  data: widget.ponuka.dalsie_terminy,
                                  style: {
                                    "body": Style(
                                      margin: Margins.all(0),
                                      maxLines: descTextShowFlag ? 100 : 8,
                                    ),
                                    "p": Style(
                                      textOverflow: TextOverflow.ellipsis,
                                      padding: HtmlPaddings.all(0),
                                      fontSize: FontSize(14),
                                      lineHeight: LineHeight(1.6),
                                      fontWeight: FontWeight.w400,
                                    )
                                  },
                                   onLinkTap: (url, _, __) async {
                                          if (!await launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication)) {
                                            // throw Exception('Could not launch url');
                                          }
                                        },
                                ),
                                /**
                             * Zobraziť všetky terminy
                             */
                                !descTextShowFlag
                                    ? InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            bottom: 5, // Space between underline and text
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                            color: Colors.black,
                                            width: 1.0, // Underline thickness
                                          ))),
                                          child: Text(
                                            '${lang().returnString(userLanguage!, "detail_zobrvsetkyterminy")}',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: style.MainAppStyle().colorText,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            descTextShowFlag = !descTextShowFlag;
                                          });
                                        },
                                      )
                                    : Container(),
                                SizedBox(height: 20.0),
                              ],
                            )
                          : Container(),

                      /**
                     * Všetky aktualne terminy - button
                     */

                      widget.ponuka.vsetky_aktual_terminy_nadpis_tlac.isNotEmpty && OnePref.getPremium() == true ||
                              widget.ponuka.vsetky_aktual_terminy_nadpis_tlac.isNotEmpty && widget.ponuka.free == "1"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      // row
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${lang().returnString(userLanguage!, "detail_vsetkyaktterminy")}:',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    height: 1.6,
                                                    color: style.MainAppStyle().colorText,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 15.0),
                                          Row(
                                            children: [
                                              widget.ponuka.vsetky_aktual_terminy_text.isNotEmpty
                                                  ? InkWell(
                                                      child: Container(
                                                        padding: const EdgeInsets.all(7.0),
                                                        decoration: new BoxDecoration(
                                                          color: Color.fromRGBO(220, 229, 238, 1),
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                        ),
                                                        child: Image.asset(height: 25.0, "lib/assets/images/info.png"),
                                                      ),
                                                      onTap: () async {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return CustomDialogBox(
                                                                mainIcon: "",
                                                                type: "text",
                                                                title: lang().returnString(userLanguage!, "detail_vsetkyaktterminy"),
                                                                descriptions: widget.ponuka.vsetky_aktual_terminy_text,
                                                              );
                                                            });
                                                      },
                                                    )
                                                  : Container(),
                                              SizedBox(width: 10.0),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(10.0, 13.0, 10.0, 13.0),
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
                                                child: InkWell(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        widget.ponuka.vsetky_aktual_terminy_nadpis_tlac.toUpperCase(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5.0),
                                                      Image.asset(height: 15.0, "lib/assets/images/external-link.png"),
                                                    ],
                                                  ),
                                                  onTap: () async {
                                                    if (!await launchUrl(Uri.parse(widget.ponuka.vsetky_aktual_terminy_odkaz), mode: LaunchMode.externalApplication)) {
                                                      // throw Exception('Could not launch url');
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.0),
                              ],
                            )
                          : Container(),

                      /**
                     * bližšie informacie
                     */

                      blizsie_info_php.length > 1 && OnePref.getPremium() == true || blizsie_info_php.length > 1 && widget.ponuka.free == "1"
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: new BoxDecoration(
                                color: Color.fromRGBO(234, 238, 242, 1),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Column(
                                children: [
                                  // title
                                  Container(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      children: [
                                        Image.asset(height: 20.0, "lib/assets/images/blizsieinfo.png"),
                                        SizedBox(width: 10.0),
                                        Text(
                                          '${lang().returnString(userLanguage!, "detail_blizsieinfo")}',
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            height: 1.6,
                                            color: Color.fromRGBO(22, 97, 174, 1),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  widget.ponuka.fotka_lietadla.isNotEmpty ? Image.network(
                                    widget.ponuka.fotka_lietadla,
                                    fit: BoxFit.cover,
                                    width: 1000,
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return SizedBox(
                                        width: 1000,
                                        height: 200, // Nastav vhodnú výšku podľa dizajnu
                                        child: const Center(child: CircularProgressIndicator()),
                                      );
                                    },
                                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                      return SizedBox(
                                        width: 1000,
                                        height: 200, // Rovnaká výška ako pri načítavaní
                                        child: const Center(child: Icon(Icons.error, size: 50)), // Ikona chyby
                                      );
                                    },
                                  ) : Container(),
                                  // row
                                  widget.ponuka.blizsie_info_php.isNotEmpty && blizsie_info_php.length > 1
                                      ? Container(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            children: List.generate(blizsie_info_php.length, (index) {
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      blizsie_info_php[index]['field_tid'].isNotEmpty
                                                          ? Image.asset(width: 30.0, "lib/assets/images/tip-" + blizsie_info_php[index]['field_tid'] + ".png")
                                                          : Container(),
                                                      SizedBox(width: 25.0),
                                                      Flexible(
                                                        child: Html(
                                                          data: blizsie_info_php[index]['field_popis'],
                                                          style: {
                                                            "body": Style(
                                                              margin: Margins.all(0),
                                                            ),
                                                            "p": Style(
                                                              padding: HtmlPaddings.all(0),
                                                              margin: Margins.all(0),
                                                            )
                                                          },
                                                          onLinkTap: (url, _, __) async {
                                          if (!await launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication)) {
                                            // throw Exception('Could not launch url');
                                          }
                                        },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20.0),
                                                ],
                                              );
                                            }),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            )
                          : Container(),
                      SizedBox(height: 20.0),
                      /**
                     * prakticke tipy pre cestovatelov
                     */
                      widget.ponuka.prakticke_tipy_pre_cestovatelov.isNotEmpty && OnePref.getPremium() == true || widget.ponuka.prakticke_tipy_pre_cestovatelov.isNotEmpty && widget.ponuka.free == "1"
                          ? Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: new BoxDecoration(
                                    color: Color.fromRGBO(205, 236, 204, 1),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      // title
                                      Container(
                                        child: Row(
                                          children: [
                                            Image.asset(height: 30.0, "lib/assets/images/tipyprecesto.png"),
                                            SizedBox(width: 15.0),
                                            Text(
                                              '${lang().returnString(userLanguage!, "detail_tipyprecest")}:',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                height: 1.6,
                                                color: Color.fromRGBO(75, 144, 73, 1),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      // row
                                      Html(
                                        data: widget.ponuka.prakticke_tipy_pre_cestovatelov,
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
                                        onLinkTap: (url, _, __) async {
                                          if (!await launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication)) {
                                            // throw Exception('Could not launch url');
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 40.0),
                              ],
                            )
                          : Container(),

                      /**
                       * POCASIE
                      */
                      widget.ponuka.pocasiedata.isNotEmpty && widget.ponuka.viac_o_destinaci.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${lang().returnString(userLanguage!, "detail_pocasiepocaspobytu")}:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(22, 97, 174, 1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '${lang().returnString(userLanguage!, "detail_datazminroka")}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(22, 97, 174, 1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Row(
                                  children: List.generate(
                                    pocasiedata.length,
                                    (index) {
                                      return Expanded(
                                        child: Column(
                                          children: [
                                            Image.asset(height: 50.0, "lib/assets/images/weather-" + pocasiedata[index]['icon'] + ".png"),
                                            SizedBox(height: 10.0),
                                            Text(
                                              pocasiedata[index]['datum'] + ".",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color.fromRGBO(154, 155, 157, 1),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 10.0),
                                            Html(
                                              data: "<b>" + pocasiedata[index]['pocasie2'] + "</b> / " + pocasiedata[index]['pocasie'],
                                              style: {
                                                "body": Style(
                                                  margin: Margins.all(0),
                                                  fontSize: FontSize(13),
                                                  textAlign: TextAlign.center,
                                                ),
                                                "p": Style(
                                                  padding: HtmlPaddings.all(0),
                                                  fontSize: FontSize(13),
                                                  lineHeight: LineHeight(1.6),
                                                  fontWeight: FontWeight.w400,
                                                  textAlign: TextAlign.center,
                                                )
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 30.0),
                              ],
                            )
                          : Container(),
                      SizedBox(height: 15.0),

                     /**
                     * Ukážkový itinerár
                     */

                      widget.ponuka.ukazkovy_itinerar.isNotEmpty && OnePref.getPremium() == true || widget.ponuka.ukazkovy_itinerar.isNotEmpty && widget.ponuka.free == "1"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${lang().returnString(userLanguage!, "ukazkovy_itinerar")}:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(22, 97, 174, 1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Html(
                                  data: ukazkovyItinerarTextShowFlag
                                      ? widget.ponuka.ukazkovy_itinerar
                                      : ((widget.ponuka.ukazkovy_itinerar.length >= 190 ? widget.ponuka.ukazkovy_itinerar.substring(0, 190) + '...' : widget.ponuka.ukazkovy_itinerar)),
                                  style: {
                                    "body": Style(
                                      margin: Margins.all(0),
                                      fontSize: FontSize(14),
                                      lineHeight: LineHeight(1.6),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    "p": Style(
                                      padding: HtmlPaddings.all(0),
                                      fontSize: FontSize(14),
                                      lineHeight: LineHeight(1.6),
                                      fontWeight: FontWeight.w400,
                                    )
                                  },
                                ),
                                /**
                            * "Zobraziť celý popis"
                        */
                                !ukazkovyItinerarTextShowFlag
                                    ? InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            bottom: 5, // Space between underline and text
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                            color: Colors.black,
                                            width: 1.0, // Underline thickness
                                          ))),
                                          child: Text(
                                            '${lang().returnString(userLanguage!, "detail_zobrcelypopis")}',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: style.MainAppStyle().colorText,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            ukazkovyItinerarTextShowFlag = !ukazkovyItinerarTextShowFlag;
                                          });
                                        },
                                      )
                                    : Container(),
                                SizedBox(height: 30.0),
                              ],
                            )
                          : Container(),
                      /**
                     * VIAC O DESTINACII
                     */
                      widget.ponuka.viac_o_destinaci.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${lang().returnString(userLanguage!, "detail_viacodest")}:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(22, 97, 174, 1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Html(
                                  data: viacoDestTextShowFlag
                                      ? widget.ponuka.viac_o_destinaci
                                      : ((widget.ponuka.viac_o_destinaci.length >= 190 ? widget.ponuka.viac_o_destinaci.substring(0, 190) + '...' : widget.ponuka.viac_o_destinaci)),
                                  style: {
                                    "body": Style(
                                      margin: Margins.all(0),
                                      fontSize: FontSize(14),
                                      lineHeight: LineHeight(1.6),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    "p": Style(
                                      padding: HtmlPaddings.all(0),
                                      fontSize: FontSize(14),
                                      lineHeight: LineHeight(1.6),
                                      fontWeight: FontWeight.w400,
                                    )
                                  },
                                ),
                                /**
                            * "Zobraziť celý popis"
                        */
                                !viacoDestTextShowFlag
                                    ? InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            bottom: 5, // Space between underline and text
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                            color: Colors.black,
                                            width: 1.0, // Underline thickness
                                          ))),
                                          child: Text(
                                            '${lang().returnString(userLanguage!, "detail_zobrcelypopis")}',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: style.MainAppStyle().colorText,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            viacoDestTextShowFlag = !viacoDestTextShowFlag;
                                          });
                                        },
                                      )
                                    : Container(),
                                SizedBox(height: 30.0),
                              ],
                            )
                          : Container(),

                      /**
                     * GALERIA - DESTINACIA
                     */
                      imgList.length > 1
                        ? Column(
                            children: [
                              CarouselSlider.builder(
                                carouselController: controller,
                                itemCount: imgList.length,
                                options: CarouselOptions(
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 0.8,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  enlargeFactor: 0.3,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (val, _) {
                                    setState(() {
                                      active_gallery_1 = val;
                                    });
                                  },
                                ),
                                itemBuilder: (context, index, realIdx) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Načítavacie koliečko
                                      const CircularProgressIndicator(),

                                      // Obrázok s podmienkou na načítanie
                                      Image.network(
                                        imgList[index],
                                        fit: BoxFit.cover,
                                        width: 1000,
                                        loadingBuilder: (BuildContext context, Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const Center(child: CircularProgressIndicator());
                                        },
                                        errorBuilder: (BuildContext context, Object exception,
                                            StackTrace? stackTrace) {
                                          return const Icon(Icons.error); // Zobrazí ikonu, ak obrázok zlyhá
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 0; i < imgList.length; i++)
                                    InkWell(
                                      onTap: () {
                                        controller.animateToPage(i);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(4),
                                        height: 12,
                                        width: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: active_gallery_1 == i
                                              ? Color(0xff000000)
                                              : Color.fromARGB(255, 201, 201, 201),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          )
                        : Container(),
                      SizedBox(height: 40.0),
                     /**
                     * SPODNY BANNER
                     */
                      widget.ponuka.banner.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Načítavacie koliečko
                                    const CircularProgressIndicator(),

                                    // Obrázok s podmienkou na načítanie
                                    Image.network(
                                      widget.ponuka.banner,
                                      fit: BoxFit.cover,
                                      width: 1000,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const Center(child: CircularProgressIndicator());
                                      },
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return const Icon(Icons.error); // Zobrazí ikonu, ak obrázok zlyhá
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),

                      /**
                           *  button predplatit
                           */
                      OnePref.getPremium() == false && widget.ponuka.free == "0"
                          ? InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed("/paymentpage");
                              },
                              child: Container(
                                margin: EdgeInsets.all(20.0),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
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
                                  '${lang().returnString(userLanguage!, "button_predplatit")}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),

                SizedBox(height: 20.0),
              ],
            ),
          ),
          // CHECK INTERNET
          CheckInternetClass(),
        ],
      ),
      /* BOTTOM MENU */
      bottomNavigationBar: const bottomMenu(
        //index: ponukafree == 1 ? 2 : 0,
        index: 0,
      ),
    );
  }

  // google map center
  Future<void> zoomToFit(GoogleMapController controller, LatLngBounds bounds, LatLng centerBounds) async {
    bool keepZoomingOut = true;

    while (keepZoomingOut) {
      final LatLngBounds screenBounds = await controller.getVisibleRegion();
      if (fits(bounds, screenBounds)) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - 0.5;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      } else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck = screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck = screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck = screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck = screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck && northEastLongitudeCheck && southWestLatitudeCheck && southWestLongitudeCheck;
  }
  
}
