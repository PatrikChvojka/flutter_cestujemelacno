import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cityapp/pages/ponuka_detail.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../include/bottom_menu.dart';
import '../include/checkInternet.dart';
import '../include/strings.dart';
import '../include/style.dart' as style;
import '../include/appbar.dart';
import '../models/ponuky_model.dart';
import 'package:http/http.dart' as http;
// pay 2 - subscription
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:onepref/onepref.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/nointernet.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // INTERNET STATUS
  bool haveInternet = true;
  bool aktualnenacitavamponuky = false;
  // SCROLL CONTROLLER
  late final ScrollController _controller = ScrollController();
  // FIRST PAGE
  int pagenumber = 1;
  // CI BOLI PRVE PRISPEVKY NACITANE
  bool prvePrisevkyBoliNacitane = false;
  // IApEngine
  IApEngine iApEngine = IApEngine();
  late Timer timer;

  Future<void> getASPNToken() async {
    if (!mounted) return;

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    try {
      // Request permission first
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print("Firebase authorization status: ${settings.authorizationStatus}");

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Only try to get APNS token if authorized
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();

        if (apnsToken != null) {
          await getDeviceToken(apnsToken);
        } else {
          print("apnsToken is null");
          // Wait a bit longer before retrying
          await Future.delayed(const Duration(seconds: 3));
          if (mounted) {
            getASPNToken(); // Retry
          }
        }
      } else {
        print("Notification permissions not granted");
      }
    } catch (e) {
      print("Error getting APNS token: $e");
    }
  }

  Future<void> getDeviceToken(String apnsToken) async {
    if (!mounted) return;

    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();

      if (deviceToken != null) {
        print("Device token: $deviceToken");
        print("APNS token: $apnsToken");

        String userLanguage = await lang().returnselectedValue();

        // Unsubscribe from all topics first
        await Future.wait([
          FirebaseMessaging.instance.unsubscribeFromTopic('news_sk'),
          FirebaseMessaging.instance.unsubscribeFromTopic('news_cz'),
          FirebaseMessaging.instance.unsubscribeFromTopic('news_hu'),
          FirebaseMessaging.instance.unsubscribeFromTopic('news_pl'),
          FirebaseMessaging.instance.unsubscribeFromTopic('news_en'),
          FirebaseMessaging.instance.unsubscribeFromTopic('news_at'),
          FirebaseMessaging.instance.unsubscribeFromTopic('news_de'),
        ]);

        // Subscribe to new topic
        await FirebaseMessaging.instance.subscribeToTopic('news_$userLanguage');

        // Save token to server
        final response = await http.get(Uri.parse(
            "https://app.cestuje.me/firebase/savetokentest.php?token=$deviceToken&lang=$userLanguage"));

        if (response.statusCode != 200) {
          print("Error saving token to server: ${response.statusCode}");
        }
      }
    } catch (e) {
      print("Error in getDeviceToken: $e");
    }
  }

  Future<void> checkInternetFunction() async {
    if (!mounted) return;

    if (await InternetConnectionChecker.instance.hasConnection) {
      if (!mounted) return;
      if (!prvePrisevkyBoliNacitane) {
        pagenumber = 1;
        await loadAnotherPage(pagenumber);
        if (!mounted) return;
        setState(() {
          pagenumber = 1;
        });
      }
      if (!mounted) return;
      setState(() {
        haveInternet = true;
        prvePrisevkyBoliNacitane = true;
      });
    } else {
      if (!mounted) return;
      setState(() {
        haveInternet = false;
      });
    }
  }

  Future<void> iosfinishtransaction() async {
    try {
      final paymentWrapper = SKPaymentQueueWrapper();
      final transactions = await paymentWrapper.transactions();

      for (var transaction in transactions) {
        try {
          print(
              "Attempting to finish transaction: ${transaction.transactionIdentifier}");

          // Check if transaction is already finished
          if (transaction.transactionState ==
                  SKPaymentTransactionStateWrapper.purchased ||
              transaction.transactionState ==
                  SKPaymentTransactionStateWrapper.restored) {
            await paymentWrapper.finishTransaction(transaction);
            print("Successfully finished transaction");
          }
        } catch (e) {
          print("Error finishing transaction: $e");
          // Continue processing other transactions
          continue;
        }
      }
    } catch (e) {
      print("Error in iosfinishtransaction: $e");
    }
  }

  Future<void> savePaymentToDatabase(String saveRead, String paymentId,
      String productId, String timestamp) async {
    var deviceInfo = DeviceInfoPlugin();
    var iosDeviceInfo = await deviceInfo.iosInfo;

    if (saveRead == "save") {
      await http.get(Uri.parse(
          "https://app.cestuje.me/firebase/iospayment.php?paymentId=" +
              paymentId +
              "&productId=" +
              productId +
              "&timestamp=" +
              timestamp +
              "&device=" +
              iosDeviceInfo.identifierForVendor!));
    } else {
      final response = await http.get(Uri.parse(
          "https://app.cestuje.me/firebase/iospayment.php?device=" +
              iosDeviceInfo.identifierForVendor!));
      if (response.statusCode == 200) {
        final parsedSubscribed = jsonDecode(response.body);
        if (parsedSubscribed['subscribed'] == 1) {
          print("subscribedResult: true");
          updateIsSub(true);
        } else {
          print("subscribedResult: false");
          updateIsSub(false);
        }
      }
    }
  }

  // promoCodes
  bool havePromoCode = false;
  Future<void> getPromoCode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      havePromoCode = prefs.getBool("promoCode") ?? false;
    });
    if (havePromoCode) {
      OnePref.setPremium(true);
    }
    print(havePromoCode);
  }

  String myPromoCode = "";
  Future<void> validityPromoCode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      myPromoCode = prefs.getString("promoCodeCode") ?? "";
    });

    if (myPromoCode != "") {
      final response = await http.get(Uri.parse(
          "https://app.cestuje.me/firebase/promocodeExist.php?code=" +
              myPromoCode));
      if (response.body == "1") {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('promoCode', true);
      } else {
        prefs.setBool('promoCode', false);
      }
    } else {
      prefs.setBool('promoCode', false);
    }
  }

  // Listen for purchases
  Future<void> listenPurchases(List<PurchaseDetails> list) async {
    if (list.isNotEmpty) {
      print("list nie je prázdny");

      for (var purchaseDetails in list) {
        if (purchaseDetails.status == PurchaseStatus.restored ||
            purchaseDetails.status == PurchaseStatus.purchased) {
          if (Platform.isIOS) {
            savePaymentToDatabase("save", purchaseDetails.purchaseID!,
                purchaseDetails.productID, purchaseDetails.transactionDate!);
            savePaymentToDatabase("read", "", "", "");
          }

          // Complete the purchase if needed.
          if (purchaseDetails.pendingCompletePurchase) {
            await iApEngine.inAppPurchase
                .completePurchase(purchaseDetails)
                .then((value) {
              // You can update subscription status here if needed.
              // updateIsSub(true);
            });
          }
        }
      }

      if (Platform.isAndroid) {
        OnePref.setPremium(true);
        print("subscription result pay: true");
      }
    } else {
      print("nemáme subscription - list je prazdny");
      updateIsSub(false);
    }
  }

  // Change subscription status
  void updateIsSub(bool value) {
    print("update sub:");
    print(value);
    setState(() {
      OnePref.setPremium(value);
    });
    getPromoCode();
  }

  late StreamSubscription<List<PurchaseDetails>> _subscriptionStream;

  @override
  void initState() {
    super.initState();

    // Start loading data immediately
    _initializeData();

    // Initialize timer with a periodic check
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      if (mounted) {
        checkInternetFunction();
      }
    });

    // Optimize scroll listener
    _controller.addListener(_handleScroll);
  }

  // New method to handle initialization
  Future<void> _initializeData() async {
    if (!mounted) return;

    // Load first page immediately
    await loadAnotherPage(pagenumber);

    // Run other initializations in parallel
    await Future.wait<void>([
      validityPromoCode(),
      getASPNToken(),
      _initializePurchases(),
    ]);
  }

  // New method to handle purchases initialization
  Future<void> _initializePurchases() async {
    if (!mounted) return;

    // Initialize purchase listener
    _subscriptionStream =
        iApEngine.inAppPurchase.purchaseStream.listen((listOfPurchaseDetails) {
      if (mounted) {
        listenPurchases(listOfPurchaseDetails);
      }
    });

    if (Platform.isIOS) {
      await iosfinishtransaction();
    }

    // Restore purchases and check subscription status
    await iApEngine.inAppPurchase.restorePurchases();
    await savePaymentToDatabase("read", "", "", "");
  }

  // Optimize scroll handling
  void _handleScroll() {
    if (!mounted) return;

    if (_controller.position.atEdge &&
        _controller.position.pixels != 0 &&
        !aktualnenacitavamponuky) {
      setState(() {
        pagenumber++;
      });
      loadAnotherPage(pagenumber);
    }
  }

  // Additional offers (ponuky)
  late List<ReceptyVypis> dalsiePonuky = [];
  List pagesLoaded = [];

  /// Load additional offers into the list
  Future<void> loadAnotherPage(int pagenumber) async {
    if (!mounted || aktualnenacitavamponuky) return;

    setState(() {
      aktualnenacitavamponuky = true;
    });

    try {
      // Cache language to avoid multiple calls
      final langurl = await _getCachedLanguage();

      if (!pagesLoaded.contains(pagenumber)) {
        pagesLoaded.add(pagenumber);

        final response = await http
            .get(Uri.parse(
                "https://app.cestuje.me/$langurl/api/json_output?language=$langurl&page=$pagenumber"))
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200 && mounted) {
          final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
          setState(() {
            dalsiePonuky.addAll(parsed
                .map<ReceptyVypis>((json) => ReceptyVypis.fromJson(json))
                .toList());
            prvePrisevkyBoliNacitane = true;
          });
        }
      }
    } catch (e) {
      print("Error loading page: $e");
    } finally {
      if (mounted) {
        setState(() {
          aktualnenacitavamponuky = false;
        });
      }
    }
  }

  // Helper method to cache language
  String? _cachedLanguage;
  Future<String> _getCachedLanguage() async {
    if (_cachedLanguage != null) return _cachedLanguage!;

    var langurl = await lang().returnselectedValue();
    if (langurl == "cz") langurl = "cs";
    if (langurl == "at") langurl = "de";

    _cachedLanguage = langurl;
    return langurl;
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
      appBar: MainAppBar(userLanguage: userLanguage!),
      backgroundColor: style.MainAppStyle().bodyBG,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15.0, right: 15.0),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/images/planeBg.png"),
                alignment: Alignment.topLeft,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            constraints: const BoxConstraints.expand(),
            child: Stack(
              children: [
                RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.blue,
                  onRefresh: () async {
                    // Redirect after refresh - pull to top
                    Navigator.of(context).pushNamed("/home");
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20.0),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // INTERNET CONDITION
                              (() {
                                if (haveInternet == true ||
                                    (haveInternet == false &&
                                        prvePrisevkyBoliNacitane == true)) {
                                  return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: dalsiePonuky.length,
                                    itemBuilder: (BuildContext context, index) {
                                      ReceptyVypis ponukaRow =
                                          dalsiePonuky[index];
                                      return (ponukaRow
                                                      .banner_type.isNotEmpty &&
                                                  ponukaRow.banner_type ==
                                                      "Zobraziť všetkým") ||
                                              (ponukaRow
                                                      .banner_type.isNotEmpty &&
                                                  ponukaRow.banner_type ==
                                                      "Zobraziť len plateným" &&
                                                  OnePref.getPremium() ==
                                                      true) ||
                                              (ponukaRow
                                                      .banner_type.isNotEmpty &&
                                                  ponukaRow.banner_type ==
                                                      "Zobraziť len neplateným" &&
                                                  OnePref.getPremium() == false)
                                          ? Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  3, 3, 3, 20),
                                              padding: const EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 20.0,
                                                  top: 10.0,
                                                  bottom: 10.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                color: const Color.fromRGBO(
                                                    205, 236, 204, 1),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color.fromRGBO(
                                                        239, 241, 243, 1),
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
                                                      padding:
                                                          HtmlPaddings.all(0),
                                                      fontSize: FontSize(14),
                                                      lineHeight:
                                                          LineHeight(1.6),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )
                                                  },
                                                ),
                                                onTap: () async {
                                                  if (ponukaRow
                                                          .banner_preplik ==
                                                      "Stránka platenia") {
                                                    Navigator.of(context)
                                                        .popAndPushNamed(
                                                            "/paymentpage");
                                                  }
                                                  if (ponukaRow
                                                          .banner_preplik ==
                                                      "URL") {
                                                    if (!await launchUrl(
                                                        Uri.parse(ponukaRow
                                                            .banner_url),
                                                        mode: LaunchMode
                                                            .externalApplication)) {
                                                      // Handle error if needed
                                                    }
                                                  }
                                                },
                                              ),
                                            )
                                          : Container(
                                              child:
                                                  ponukaRow.banner_type
                                                          .isNotEmpty
                                                      ? Container()
                                                      : GestureDetector(
                                                          onTap: () =>
                                                              Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) =>
                                                                  ReceptScreen(
                                                                ponuka:
                                                                    ponukaRow,
                                                              ),
                                                            ),
                                                          ),
                                                          child: Container(
                                                            // main box
                                                            margin:
                                                                const EdgeInsets
                                                                    .fromLTRB(3,
                                                                    3, 3, 20),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              color: ponukaRow.free ==
                                                                          "0" &&
                                                                      OnePref.getPremium() ==
                                                                          false
                                                                  ? const Color
                                                                      .fromRGBO(
                                                                      249,
                                                                      242,
                                                                      218,
                                                                      1)
                                                                  : Colors
                                                                      .white,
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          239,
                                                                          241,
                                                                          243,
                                                                          1),
                                                                  spreadRadius:
                                                                      0,
                                                                  blurRadius: 0,
                                                                  offset:
                                                                      Offset(-5,
                                                                          5),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                // hlavna fotka
                                                                Stack(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          const BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(10.0),
                                                                        topRight:
                                                                            Radius.circular(15.0),
                                                                      ),
                                                                      child:
                                                                          Stack(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        children: [
                                                                          // Načítavacie koliečko
                                                                          const CircularProgressIndicator(),
                                                                          // Obrázok s načítavaním
                                                                          Image
                                                                              .network(
                                                                            ponukaRow.imageUrl,
                                                                            height:
                                                                                200.0,
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            loadingBuilder: (BuildContext context,
                                                                                Widget child,
                                                                                ImageChunkEvent? loadingProgress) {
                                                                              if (loadingProgress == null) {
                                                                                return child;
                                                                              }
                                                                              return const Center(child: CircularProgressIndicator());
                                                                            },
                                                                            errorBuilder: (BuildContext context,
                                                                                Object exception,
                                                                                StackTrace? stackTrace) {
                                                                              return const Icon(Icons.error);
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    // usetrite az
                                                                    ponukaRow
                                                                            .text_usetrite_az
                                                                            .isNotEmpty
                                                                        ? Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 15.0, top: 15.0),
                                                                            child: Container(
                                                                                padding: const EdgeInsets.fromLTRB(20.0, 13.0, 20.0, 13.0),
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color.fromRGBO(0, 0, 0, 0.5),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                child: Text(
                                                                                  '${lang().returnString(userLanguage!, "vypis_usertriteat")} ${ponukaRow.text_usetrite_az}/${lang().returnString(userLanguage!, "vypis_osoba")}',
                                                                                  style: const TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                )),
                                                                          )
                                                                        : Container(),
                                                                    // lock icon for non-premium content
                                                                    ponukaRow.free ==
                                                                                "0" &&
                                                                            OnePref.getPremium() ==
                                                                                false
                                                                        ? Align(
                                                                            alignment:
                                                                                AlignmentDirectional.topEnd,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(15.0),
                                                                              child: Container(
                                                                                padding: const EdgeInsets.all(10.0),
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color.fromRGBO(255, 202, 45, 1),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                child: Image.asset("lib/assets/images/lockicon.png", height: 22.0),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                    ponukaRow.free ==
                                                                                "1" &&
                                                                            OnePref.getPremium() ==
                                                                                false
                                                                        ? Align(
                                                                            alignment:
                                                                                AlignmentDirectional.topEnd,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(15.0),
                                                                              child: Container(
                                                                                padding: const EdgeInsets.all(10.0),
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color.fromRGBO(158, 223, 141, 1),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                child: Image.asset("lib/assets/images/lockiconOpen.png", height: 22.0),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                    Align(
                                                                      alignment:
                                                                          AlignmentDirectional
                                                                              .topEnd,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                0.0,
                                                                            top:
                                                                                125.0),
                                                                        child:
                                                                            Container(
                                                                          padding: const EdgeInsets
                                                                              .fromLTRB(
                                                                              15.0,
                                                                              13.0,
                                                                              20.0,
                                                                              13.0),
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color: Color.fromRGBO(
                                                                                255,
                                                                                255,
                                                                                255,
                                                                                1),
                                                                            borderRadius:
                                                                                BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Image.asset("lib/assets/images/pin.png", height: 22.0),
                                                                              const SizedBox(width: 10.0),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  ponukaRow.krajina.isNotEmpty
                                                                                      ? Text(
                                                                                          ponukaRow.krajina.length > 20 ? ponukaRow.krajina.substring(0, 20) + '...' : ponukaRow.krajina,
                                                                                          style: const TextStyle(
                                                                                            color: Color.fromRGBO(45, 92, 117, 1),
                                                                                            fontSize: 14,
                                                                                            fontWeight: FontWeight.w600,
                                                                                          ),
                                                                                        )
                                                                                      : Container(),
                                                                                  ponukaRow.nazov_destinacie.isNotEmpty
                                                                                      ? Text(
                                                                                          ponukaRow.nazov_destinacie,
                                                                                          style: const TextStyle(
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
                                                                  ],
                                                                ),
                                                                // fieldset
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Container(
                                                                        padding: const EdgeInsets
                                                                            .fromLTRB(
                                                                            20.0,
                                                                            20.0,
                                                                            20.0,
                                                                            20.0),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                ponukaRow.letenky_len_za.isNotEmpty
                                                                                    ? Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          ponukaRow.obojsmerny_let.isNotEmpty
                                                                                              ? Image.asset(
                                                                                                  "lib/assets/images/ponuka_planes_back.png",
                                                                                                  height: 22.0,
                                                                                                )
                                                                                              : Image.asset(
                                                                                                  "lib/assets/images/ponuka_planes_back_single.png",
                                                                                                  height: 22.0,
                                                                                                ),
                                                                                          const SizedBox(width: 10.0),
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
                                                                                          Image.asset(
                                                                                            "lib/assets/images/ponuka_home.png",
                                                                                            height: 22.0,
                                                                                          ),
                                                                                          const SizedBox(width: 10.0),
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
                                                                            const SizedBox(height: 20.0),
                                                                            Text(
                                                                              '${lang().returnString(userLanguage!, "vypis_pridane")}: ${ponukaRow.pridane}',
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: const TextStyle(
                                                                                fontSize: 12.0,
                                                                                color: Color.fromRGBO(171, 171, 171, 1),
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 8.0),
                                                                            Text(
                                                                              ponukaRow.title,
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: const TextStyle(
                                                                                height: 1.3,
                                                                                fontSize: 16.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Color.fromRGBO(45, 92, 117, 1),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 20.0),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  ponukaRow.odletMonth,
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: TextStyle(
                                                                                    fontSize: 13.0,
                                                                                    color: style.MainAppStyle().mainColor,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
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
                                                                                    '${ponukaRow.nazov_letiska_odletu} > ${ponukaRow.nazov_letiska_priletu.length > 20 ? ponukaRow.nazov_letiska_priletu.substring(0, 20) + '...' : ponukaRow.nazov_letiska_priletu}',
                                                                                    style: const TextStyle(
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
                                                        ),
                                            );
                                    },
                                  );
                                } else {
                                  return const NoInternet();
                                }
                              }()),
                              aktualnenacitavamponuky
                                  ? Column(
                                      children: const [
                                        Center(
                                            child: CircularProgressIndicator()),
                                      ],
                                    )
                                  : Container(),
                              const SizedBox(height: 50.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // CHECK INTERNET
                const CheckInternetClass(),
              ],
            ),
          ),
          // Show loading indicator when first loading
          if (!prvePrisevkyBoliNacitane && dalsiePonuky.isEmpty)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      /* BOTTOM MENU */
      bottomNavigationBar: const bottomMenu(
        index: 0,
      ),
    );
  }

  @override
  void dispose() {
    _subscriptionStream.cancel();
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }
}
