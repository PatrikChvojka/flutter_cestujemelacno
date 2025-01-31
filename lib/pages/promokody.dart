import 'package:flutter/material.dart';
import 'package:onepref/onepref.dart';
import '../include/appbar.dart';
import '../include/bottom_menu.dart';
import '../include/strings.dart';
import '../include/style.dart' as style;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class promoKody extends StatefulWidget {
  const promoKody({super.key});

  @override
  State<promoKody> createState() => _promoKodyState();
}

class _promoKodyState extends State<promoKody> {
  // LOAD LANGUAGE
  String? userLanguage = "sk";
  Future<void> loadLang() async {
    userLanguage = await lang().returnselectedValue();

    setState(() {
      userLanguage = userLanguage;
    });
  }

  // promoCodes
  bool havePromoCode = false;
  String myPromoCode = "";
  Future<Null> getPromoCode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      myPromoCode = prefs.getString("promoCodeCode") ?? "";
      havePromoCode = prefs.getBool("promoCode") ?? false;
    });

    if (myPromoCode != "") {
      final response = await http.get(Uri.parse("https://app.cestuje.me/firebase/promocodeExist.php?code=" + myPromoCode));
      if (response.body == "1") {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('promoCode', true);
        prefs.setString('promoCodeCode', myPromoCode);
        OnePref.setPremium(true);
        print("existujuci kod");
        setState(() {
          successPromoCode = true;
        });
      } else {
        prefs.setBool('promoCode', false);
        print("neexistujuci kod");
        setState(() {
          successPromoCode = false;
        });
      }
    } else {
      print("prazdny kod");
      prefs.setBool('promoCode', false);
      setState(() {
        successPromoCode = false;
      });
    }
  }

  bool showErrorMessage = false;
  bool successPromoCode = false;

  Future loadPromoCode(String promoCode) async {
    setState(() {
      showErrorMessage = false;
    });
    final response = await http.get(Uri.parse("https://app.cestuje.me/firebase/promocode.php?code=" + promoCode));
    print(response.body);
    if (response.body == "1") {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('promoCode', true);
      prefs.setString('promoCodeCode', promoCode);

      setState(() {
        successPromoCode = true;
      });
      OnePref.setPremium(true);
    } else {
      setState(() {
        showErrorMessage = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPromoCode();
  }

  final _formKey = GlobalKey<FormState>();

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
        child: successPromoCode == false
            ? Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Promo kód',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Prosím vyplň kód';
                        } else {
                          // spracuj data

                          loadPromoCode(value);
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Spracovávam dáta')),
                          );
                        }
                      },
                      child: const Text('Odoslať kód'),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    showErrorMessage == true
                        ? Text(
                            "Tento kód je zlý alebo neplatný",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Container()
                  ],
                ),
              )
            : Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "GRATULUJEME",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: style.MainAppStyle().mainColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Váš promo kód je aktívny",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: style.MainAppStyle().mainColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Môžete sa presunúť na domovskú obrazovku"),
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
