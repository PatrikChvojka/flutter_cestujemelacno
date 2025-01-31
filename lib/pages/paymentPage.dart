import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../include/appbar.dart';
import '../include/bottom_menu.dart';
import '../include/strings.dart';
import 'package:intl/intl.dart';
import '../include/style.dart' as style;
import 'package:flutter_html/flutter_html.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:onepref/onepref.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

class PayMentPage extends StatefulWidget {
  const PayMentPage({super.key});

  @override
  State<PayMentPage> createState() => _PayMentPageState();
}

class _PayMentPageState extends State<PayMentPage> {
  // LOAD LANGUAGE
  String? userLanguage = "sk";
  Future<void> loadLang() async {
    userLanguage = await lang().returnselectedValue();
  }

  // list products
  late final List<ProductDetails> _products = <ProductDetails>[];
  final List<ProductId> _productIds = <ProductId>[
    ProductId(id: "mesacne", isConsumable: false),
    ProductId(id: "polrocne", isConsumable: false),
  ];

  //IApengine
  IApEngine iApEngine = IApEngine();

  // bool
  bool isSubscribed = false;
  bool autoRenewing = false;
  // date bought
  String datebought = "";
  //product
  String productId = "";


/* 
  iosfinishtransaction() async {
      final paymentWrapper = SKPaymentQueueWrapper();
      final transactions = await paymentWrapper.transactions();
     transactions.forEach((transaction) async {
          await paymentWrapper.finishTransaction(transaction);
      });
    }

    */

    iosfinishtransaction() async {
  try {
    final paymentWrapper = SKPaymentQueueWrapper();
    final transactions = await paymentWrapper.transactions();
    
    for (var transaction in transactions) {
      if (transaction == null) {
        print("⚠ CHYBA: Transaction je NULL!");
        continue;
      }
      await paymentWrapper.finishTransaction(transaction);
    }
  } catch (e) {
    print("⚠ Výnimka v iosfinishtransaction(): $e");
  }
}


    savePaymentToDatabase(String saveRead, String paymentId, String productId, String timestamp) async {

       var deviceInfo = DeviceInfoPlugin();
       var iosDeviceInfo = await deviceInfo.iosInfo;

      if(saveRead == "save"){
        final response = await http.get(Uri.parse("https://app.cestuje.me/firebase/iospayment.php?paymentId=" + paymentId + "&productId=" + productId + "&timestamp=" + timestamp + "&device=" + iosDeviceInfo.identifierForVendor! ));

      }else{
        final response = await http.get(Uri.parse("https://app.cestuje.me/firebase/iospayment.php?device=" + iosDeviceInfo.identifierForVendor! ));
        if (response.statusCode == 200) {

           // var subscribedResult = response.body;
            final parsedSubscribed = jsonDecode(response.body);

            if(parsedSubscribed['subscribed'] == 1){
                print("subscribedResult: true");
                updateIsSub(true);

                var dt = DateTime.fromMillisecondsSinceEpoch(parsedSubscribed['expiration']);
                  //var d12 = DateFormat('MM/dd/yyyy, hh:mm a').format(dt);
                  var d24 = DateFormat('dd.MM.yyyy').format(dt);

                  datebought = d24;
            }else{
                print("subscribedResult: false");
                updateIsSub(false);
            }

        }  

      }
      
    }

  late StreamSubscription _subscriptionStream;
  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
         iosfinishtransaction();
    }

    // listen pruchaes
    _subscriptionStream =iApEngine.inAppPurchase.purchaseStream.listen((listOfPurchaseDetails) {
      listenPurchases(listOfPurchaseDetails);
    });

    getProducts();

    // get subscription status
    iApEngine.inAppPurchase.restorePurchases();
    // get subscription data from mysql
    savePaymentToDatabase("read", "", "", "");

    print("subscription result getPremium:");
    print(OnePref.getPremium());

    isSubscribed = OnePref.getPremium() ?? false;
  }

  @override
  void dispose() {
    _subscriptionStream.cancel();
    super.dispose();
  }


  // listen pruchaes
  Future<void> listenPurchases(List<PurchaseDetails> list) async {
    if (list.isNotEmpty) {

      print("list nie je prázdny: $list ");

      for (var purchase in list) {
      print("ID: ${purchase.productID}, Stav: ${purchase.status}, Dátum: ${purchase.transactionDate}");
    }


      for (var purchaseDetails in list) {

        print(purchaseDetails.status);

        if (purchaseDetails.status == PurchaseStatus.restored || purchaseDetails.status == PurchaseStatus.purchased) {
          

             print("purchaseDetails: ${purchaseDetails.status} - ${purchaseDetails.productID} - ${purchaseDetails.transactionDate}");

             savePaymentToDatabase("save", purchaseDetails.purchaseID!, purchaseDetails.productID, purchaseDetails.transactionDate!);
             savePaymentToDatabase("read", "", "", "");

          
         // complete
          if (purchaseDetails.pendingCompletePurchase) {
             await iApEngine.inAppPurchase.completePurchase(purchaseDetails).then((value) => {
              savePaymentToDatabase("read", "", "", "")
              });
          }

        } else if (purchaseDetails.status == PurchaseStatus.error) {
          // Ak je stav error, vytlačíme podrobnosti o chybe
          print("Purchase error: ${purchaseDetails.error?.message}");
          print("Error details: ${purchaseDetails.error?.details}");
          // Môžeš tiež pridať logovanie, ktoré ti poskytne informácie o chybe v transakcii
        }
      }


    } else {
      print(" nemáme subscription - list je prazdny");
      updateIsSub(false);
    }

  }

  // change subscription
  void updateIsSub(bool value) {
    print("update sub:");
    print(value);
    setState(() {
      isSubscribed = value;
      OnePref.setPremium(value);
    });
  }

  // get products
  void getProducts() async {

     print("detail produktov");

    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      print("NOT CONNECTED");
    } else {
      print("CONNECTED TO STORE");
    }

    await iApEngine.getIsAvailable().then((value) async {
      if (value) {
        await iApEngine.queryProducts(_productIds).then((res) {
          if (res.notFoundIDs.isNotEmpty) {
            print("Produkty sa nenašli:");
            print(res.notFoundIDs);
          }
          _products.clear;
          setState(() {
            print("detail produktu");
            print(res.productDetails.toString());

            print(res.productDetails);
            _products.addAll(res.productDetails);
          });
        });
      }
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
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        constraints: const BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                    child: isSubscribed
                       //
                        // SUBSCRIBED
                        //
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Html(
                                data: '${lang().returnString(userLanguage!, "payment_sub_thanks")}',
                                style: {
                                  "body": Style(
                                    margin: Margins.all(0),
                                    fontSize: FontSize(18),
                                    color: style.MainAppStyle().mainColor,
                                    fontWeight: FontWeight.w500,
                                    lineHeight: LineHeight(1.5),
                                  ),
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Html(
                                data: '${lang().returnString(userLanguage!, "payment_sub_text1")}',
                                style: {
                                  "body": Style(
                                    margin: Margins.all(0),
                                    fontSize: FontSize(15),
                                    color: Color.fromRGBO(101, 141, 164, 1),
                                    fontWeight: FontWeight.w400,
                                    lineHeight: LineHeight(1.5),
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
                                  "h4": Style(
                                    margin: Margins.only(top: 0, bottom: 5, left: 0, right: 0),
                                    fontWeight: FontWeight.w400,
                                    fontSize: FontSize(13),
                                  ),
                                  "p": Style(
                                    margin: Margins.only(top: 0, bottom: 10, left: 0, right: 0),
                                    padding: HtmlPaddings.all(0),
                                    fontSize: FontSize(17),
                                    color: Color.fromRGBO(75, 144, 73, 1),
                                    fontWeight: FontWeight.w400,
                                  ),
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                '${lang().returnString(userLanguage!, "payment_sub_stepredplatitelom")}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color.fromRGBO(101, 141, 164, 1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              autoRenewing
                                  ? Text(
                                      '${lang().returnString(userLanguage!, "payment_sub_obnovisa")} $datebought',
                                      style: TextStyle(
                                        color: Color.fromRGBO(101, 141, 164, 1),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : Text(
                                      '${lang().returnString(userLanguage!, "payment_sub_expiruje")} $datebought',
                                      style: TextStyle(
                                        color: Color.fromRGBO(101, 141, 164, 1),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                              SizedBox(
                                height: 30,
                              ),
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.all(15.0),
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
                                    '${lang().returnString(userLanguage!, "payment_sub_spravovat")}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  if (Platform.isAndroid) {
                                    if (!await launchUrl(Uri.parse("https://play.google.com/store/account/subscriptions"), mode: LaunchMode.externalApplication)) {}
                                  } else {
                                    if (!await launchUrl(Uri.parse("https://apps.apple.com/account/subscriptions"), mode: LaunchMode.externalApplication)) {}
                                  }
                                },
                              ),
                            ],
                          )
                       //
                        // NOT SUBSCRIBED
                        //
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${lang().returnString(userLanguage!, "payment_no_title")}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: style.MainAppStyle().mainColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Html(
                                data: '${lang().returnString(userLanguage!, "payment_no_text1")}',
                                style: {
                                  "body": Style(
                                    margin: Margins.all(0),
                                    fontSize: FontSize(15),
                                    color: Color.fromRGBO(101, 141, 164, 1),
                                    fontWeight: FontWeight.w400,
                                    lineHeight: LineHeight(1.5),
                                  ),
                                  "hr": Style(
                                    margin: Margins.only(top: 20, bottom: 20),
                                    border: Border.all(color: Color.fromRGBO(101, 141, 164, 1)),
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
                                  "h4": Style(
                                    margin: Margins.only(top: 0, bottom: 5, left: 0, right: 0),
                                    fontWeight: FontWeight.w400,
                                    fontSize: FontSize(13),
                                  ),
                                  "p": Style(
                                    margin: Margins.only(top: 0, bottom: 10, left: 0, right: 0),
                                    padding: HtmlPaddings.all(0),
                                    fontSize: FontSize(17),
                                    color: Color.fromRGBO(75, 144, 73, 1),
                                    fontWeight: FontWeight.w400,
                                  ),
                                },
                              ),
                              Text(
                                lang().returnString(userLanguage!, "payment_small_text"),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  height: 1.6,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              // produsct list
                              ListView.separated(
                                shrinkWrap: true,
                                itemCount: _products.length,
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },
                                itemBuilder: ((contaxt, index) {
                                  return GestureDetector(
                                    onTap: () => {
                                     // iApEngine.handlePurchase(_products[index], _productIds),
                                      InAppPurchase.instance.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: _products[index])),
                                    },
                                    child: ListTile(
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      title: Text(
                                        _products[index].id == "mesacne" ? '${lang().returnString(userLanguage!, "payment_product1_title")}' : '${lang().returnString(userLanguage!, "payment_product2_title")}',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                         _products[index].id == "mesacne" ? '${lang().returnString(userLanguage!, "payment_product1_desc")}' : '${lang().returnString(userLanguage!, "payment_product2_desc")}',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      trailing: Text(
                                        _products[index].price,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      tileColor: style.MainAppStyle().mainColor,
                                    ),
                                  );
                                }),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              // restore button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    child: Container(
                                      padding: EdgeInsets.all(15.0),
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
                                        '${lang().returnString(userLanguage!, "payment_no_restore")}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      iApEngine.inAppPurchase.restorePurchases();
                                    },
                                  ),
                                  Image.asset(height: 30.0, "lib/assets/images/apple_pay2.png"),
                                ],
                              ),
                            ],
                          )),
              ),
            ],
          ),
        ),
      ),
      /* BOTTOM MENU */
      bottomNavigationBar: const bottomMenu(
        index: 1,
      ),
    );
  }
}
