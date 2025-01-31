import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class lang {
  String selectedValue = "sk";

  Future<dynamic> returnselectedValue() async {
    final prefs = await SharedPreferences.getInstance();
    selectedValue = prefs.getString("selectedlanguage") ?? "sk";
    return selectedValue;
  }

  /* SK */
  var strings_sk = json.decode('''{


      "ukazka_leteniek_z":      "Ukážka leteniek z", 
      "ukazka_ubytovania_z":    "Ukážka ubytovania z", 

      "flight_duration":      "hod.", 
      "ukazkovy_itinerar":      "Ukážkový itinerár", 

      "appbar_title":           "Cestujeme lacno", 
      "appbar_title2":          "Dovolenka bez cestovky",

      "button_predplatit":      "Predplatiť",
      "button_predplatit_detail":      "Predplatiť a získať prístup ihneď!",
      "nahlasit_chybu":         "Nahlásiť chybu",

      "settings_aplikacia":     "Nastavenia aplikácie",
      "settings_notifikacie":   "Notifikácie",
      "settings_zapnute":       "Zapnuté",
      "settings_vypnute":       "Vypnuté",
      "settings_vyberregionu":  "Výber regiónu",
      "settings_oaplikaci":     "Ako funguje aplikácia?",
      "settings_informacie":    "Informácie",
      "settings_ochranaos":     "Ochrana osobných údajov",
      "settings_gdpr":          "Podmienky používania",


      "payment_small_text":             "Predplatné si môžete zakúpiť kliknutím na tlačidlá nižšie. Na výber je mesačné predplatné (9,99€/mesiac) a polročné predplatné (47,99€/polrok - v prepočte 7,99€/mesiac). Predplatné sa automaticky obnovuje a môžete ho kedykoľvek zrušiť v nastaveniach App Store.",


      "payment_sub_thanks":             "Ďakujeme, že ste súčasťou komunity <b>Cestujeme lacno PREMIUM!</b>",
      "payment_sub_text1":              "Získali ste <b>plný prístup</b> ku všetkým našim exkluzívnym ponukám! Čo vám prináša naše PREMIUM členstvo:<br> <br> ✈️ <b>Každý deň nové ponuky</b> za exkluzívne ceny<br> 🌍 <b>Lacné letenky a ubytovanie</b> v obľúbených destináciách<br> 🗺️ <b>Praktické tipy</b> a odporúčania z prvej ruky<br> 📱 <b>Kompletné informácie</b> prehľadne na jednom mieste<br> 🔔 <b>Okamžité upozornenia</b> na nové ponuky<br> 💸 <b>Až 70% úspory</b> oproti bežným cenám leteniek",
      "payment_sub_stepredplatitelom":  "Ste predplatiteľom!",
      "payment_sub_obnovisa":           "Predplatené do",
      "payment_sub_expiruje":           "Predplatené do",
      "payment_sub_spravovat":          "Spravovať predplatné",
     
      "payment_no_title":             "Získajte prístup do PREMIUM verzie!",
      "payment_no_text1":             "🔓 <b>Odomknite si všetky naše ponuky</b> a využite <b>exkluzívne ceny</b>, ktoré inde nenájdete. Všetko jednoducho <b>na pár kliknutí</b> vo vašom mobile!<br> <hr> <br> ✈️ <b>Každý deň nové ponuky</b> za exkluzívne ceny<br> 🌍 <b>Lacné letenky a ubytovanie</b> v obľúbených destináciách<br> 📱 <b>Kompletné informácie</b> prehľadne na jednom mieste<br> 🔔 <b>Okamžité upozornenia</b> na nové ponuky<br> 👍 <b>Overené</b> tisíckami spokojných užívateľov<br> 🔍 <b>Dlhoročné skúsenosti</b> s lacnými letenkami<br> 💸 <b>Bez skrytých poplatkov</b> - predplatné môžete kedykoľvek zrušiť<br> 💳 <b>Rýchla a bezpečná platba</b> cez Apple Pay/Google Pay <hr>",
      "payment_no_restore":           "Obnoviť predchádzajúce nákupy",     
     
      "payment_product1_title":       "Mesačné predplatné",
      "payment_product1_desc":        "(zľava 50% z 19,99€)",
      "payment_product2_title":       "Polročné predplatné",
      "payment_product2_desc":        "(zľava 60% z 119,99€)",
      "payment_zlavovykod":           "Zľavový kód",

      "nointernet_oops":                "Ooops!",
      "nointernet_skontrolujte":        "Skontrolujte vaše pripojenie na internet",
      "nointernet_bezpripojenia":       "Bez pripojenia na internet",

      "vypis_lenza":            "Len za",
      "vypis_pridane":          "Pridané",
      "vypis_usertriteat":      "Ušetríte až",
      "vypis_osoba":             "osoba",

      "jazyk_title2":             "Potvrďte správny výber regiónu",
      "jazyk_potvrdit":           "Potvrdiť",

      "slidy_preskocit":          "Preskočiť",
      "slidy_dalej":              "Ďalej",
      "slidy_zobrazitponuky":     "Zobraziť ponuky",



      "slidy_nadpis1":             "Exkluzívne ponuky na lacné letenky a ubytovanie každý deň priamo vo vašom mobile!",      
      "slidy_nadpis1_2":           "Vitajte v aplikácii Cestujeme lacno! S nami ušetríte stovky eur na dovolenke bez cestovky!",      
      "slidy_nadpis1_3":           "Ukážková ponuka:",      
      "slidy_nadpis2":             "Kompletné informácie prehľadne na jednom mieste",      
      "slidy_nadpis3":             "Okamžité upozornenia na nové ponuky",      
      "slidy_nadpis4":             "Aplikácia overená užívateľmi",      
      "slidy_nadpis5":             "Získajte plný prístup teraz!",      
     
      "slidy_text1":              "<p>❌ Bežná cena: <s>100€</s><br> ✅ Naša cena: <b>20€</b><br><br> 💸 Ušetríte v priemere <b>až 70%!</b></p>  <p>🇮🇹 Lacný výlet do Ríma:<br> ✈️ Spiatočné letenky za <b>20€</b><br> 🏨 Ubytovanie na 3 dni za <b>68€</b><br> ✈️+🏨 Letenky + ubytovanie na 3 dni <b>len za 88€!</b><br><br> 💸 Všetky ceny <b>sú konečné!</b></p>",
      "slidy_text2":              "Nikto iný vám neposkytne toľko <b>kvalitných a overených informácií</b> ku každej ponuke:<br> <br>  ✈️ <b>Lacné letenky</b> - priamo s odkazom na rezerváciu<br> 🏨 <b>Výhodné a overené ubytovanie</b> - s odkazom na rezerváciu<br> 💸 <b>Bez skrytých poplatkov</b> – letenky aj ubytovanie si rezervujete napriamo za najnižšie ceny, u nás neplatíte nič navyše<br> 📅 <b>Viacero termínov za rovnakú cenu</b> - stačí kliknúť a rezervovať<br> 🧳 <b>Informácie o batožine</b> - presné rozmery a váha povolenej batožiny<br> 🚌 <b>Doprava z letiska</b> - detailný návod, ako sa dostať do centra<br> 📝 <b>Praktické tipy</b> - odporúčania z prvej ruky<br> 🗺️ <b>Ukážkový itinerár</b> - návrhy, čo sa oplatí vidieť a zažiť<br> ☀️ <b>Počasie v destinácii + fotogaléria</b><br> ✨ <b>a veľa ďalšieho…</b>",
      "slidy_text3":              "🔔 <b>Zapnite si notifikácie</b> a už vám neunikne žiadna nová ponuka!<br> <br> O všetkých výhodných akciách sa dozviete <b>ako prví</b> a môžete tak cestovať za tie <b>najnižšie ceny!</b>",
      "slidy_text4":              "Naša aplikácia pomohla <b>tisíckam cestovateľov</b> ušetriť stovky eur - pridajte sa k našim spokojným členom!<br> <br> Exkluzívne ponuky vám <b>každý deň</b> prinášame <b>už 8 rokov</b> - s overenými tipmi a bez skrytých poplatkov!<br> <br> <p><b> 🔍 8+ rokov skúseností<br> 👍 Tisícky spokojných užívateľov </p>  ⭐ Čo o nás povedali naši užívatelia:<br>",
      "slidy_text4_app":          "2. najsťahovanejšia aplikácia v kategórii cestovanie",
      "slidy_text5":              "<b>Odomknite si plný prístup</b> ku všetkým našim ponukám s predplatným už od <b>7,99€ za mesiac!</b> <br> <br> Platba <b>rýchlo a jednoducho</b> cez Apple Pay <br> <br> Čakajú na vás <b>exkluzívne ponuky</b> každý deň<br> <br> S nami ušetríte <b>stovky</b> eur na dovolenke bez <b>cestovky!</b>",
    
      "review_1_name" : "Sofia T.",
      "review_1_text" : "Appka so super ponukami pre cestovateľov. Určite odporúčam, veľmi prehľadne spravené a skvelý prístup.",
      "review_2_name" : "Silvia L.",
      "review_2_text" : "Perfektná aplikácia, neskutočne dobré tipy a rady na cestovanie, využívam pravidelne a som veľmi spokojná a inšpirovaná.",
      "review_3_name" : "Erik K.",
      "review_3_text" : "Veľmi veľa výhodných ponúk, prehľadné, ochotní pomôcť, rozhodne sa to oplatí.",
      "review_4_name" : "Silvia K.",
      "review_4_text" : "Veľká spokojnosť. Veľa dobrých odporúčaní, rád, skúsenosti a odpoveď na každú jednu otázku. Určite odporúčam. Veľká vďaka.",

      "slidy_text1_button":       "Pozrieť najnovšie ponuky",
      "slidy_text2_button":       "Získajte prístup k overeným informáciám už teraz!",
      "slidy_text3_button":       "Zapnúť notifikácie",
      "slidy_text4_button":       "Staňte sa členom teraz a začnite šetriť!",
      "slidy_text5_button":       "Získať prístup už od 7,99€!",




      "detail_termin":                  "Termín",
      "detail_letenkykupitetu":         "Letenky kúpite tu",
      "detail_trvanieletu":             "Trvanie letu",
      "detail_tipnaubytovanie":         "Tip na ubytovanie",
      "detail_ubytovaniekupitetu":      "Ubytovanie kúpite tu",
      "detail_dalsieterminy":           "Ďalšie termíny",
      "detail_zobrvsetkyterminy":       "Zobraziť všetky termíny",
      "detail_vsetkyaktterminy":        "Všetky aktuálne termíny",
      "detail_blizsieinfo":              "Bližšie informácie",
      "detail_tipyprecest":              "Praktické tipy pre cestovateľov",
      "detail_pocasiepocaspobytu":       "Počasie v destinácii počas pobytu",
      "detail_datazminroka":             "(dáta sú z minulého roka)",
      "detail_viacodest":                "Viac o destinácií",
      "detail_zobrcelypopis":            "Zobraziť celý popis",

      "infodetailnopaymenttext":         "<p>🔒 Pre zobrazenie všetkých informácií si predplaťte <b>PREMIUM verziu</b> a odomknite si prístup ku všetkým ponukám:</p> <hr> <p>Každá ponuka obsahuje <b>kvalitné a overené informácie:</b></p>✈️ <b>Lacné letenky</b> - priamo s odkazom na rezerváciu<br> 🏨 <b>Výhodné a overené ubytovanie</b> - s odkazom na rezerváciu<br> 💸 <b>Bez skrytých poplatkov</b> – letenky aj ubytovanie si rezervujete napriamo za najnižšie ceny, u nás neplatíte nič navyše<br> 📅 <b>Viacero termínov za rovnakú cenu</b> - stačí kliknúť a rezervovať<br> 🧳 <b>Informácie o batožine</b> - presné rozmery a váha povolenej batožiny<br> 🚌 <b>Doprava z letiska</b> - detailný návod, ako sa dostať do centra<br> 📝 <b>Praktické tipy</b> - odporúčania z prvej ruky<br> 🗺️ <b>Ukážkový itinerár</b> - návrhy, čo sa oplatí vidieť a zažiť<br> ☀️ <b>Počasie v destinácii + fotogaléria</b><br> ✨ <b>a veľa ďalšieho…</b><br>  <br><hr> Ako vyzerá <b>plný prístup</b> na ukážku? Kliknite na odomknuté ponuky v spodnom menu.<br> <br> Nezmeškajte túto príležitosť, čakajú na vás <b>exkluzívne ponuky</b> každý deň!<br> <br> Odomknite si prístup <b>rýchlo a jednoducho</b> cez Apple Pay:",
      
      "infopage":            "Ďakujeme, že ste súčasťou komunity <b>Cestujeme lacno PREMIUM!</b><br> <br> Ako náš PREMIUM člen máte prístup ku <b>všetkým exkluzívnym ponukám</b> a užitočným informáciám, ktoré vám pomôžu ušetriť stovky eur na dovolenke bez cestovky.<br> <br> Čo vám prináša naše PREMIUM členstvo:<br> <br> ✈️ <b>Každý deň nové ponuky</b> za exkluzívne ceny<br> 🌍 <b>Lacné letenky a ubytovanie</b> v obľúbených destináciách<br> 🗺️ <b>Praktické tipy</b> a odporúčania z prvej ruky<br> 📱 <b>Kompletné informácie</b> prehľadne na jednom mieste<br> 🔔 <b>Okamžité upozornenia</b> na nové ponuky<br> 💸 <b>Až 70% úspory</b> oproti bežným cenám leteniek<br> <br> <br> ⭐ <b>Spokojnosť našich členov</b> je pre nás prioritou! Ak využívate výhody našej aplikácie a pomohla vám ušetriť na cestovaní, budeme veľmi radi za recenziu na App Store alebo Google Play.<br> <br> <b>Ďakujeme</b> za vašu dôveru a prajeme vám skvelé zážitky na vašich cestách!"
   
   
   }''');

  /* CZ */
  var strings_cz = json.decode('''{

      "ukazka_leteniek_z":      "Ukázka letenek z", 
      "ukazka_ubytovania_z":    "Ukázka ubytování z", 


      "flight_duration":      "hod.", 
      "ukazkovy_itinerar":      "Vzorový itinerář", 


      "appbar_title":           "Cestujeme levně", 
      "appbar_title2":          "Dovolená bez cestovky",

       "button_predplatit":      "Předplatit",
       "nahlasit_chybu":         "Nahlásit chybu",

      "settings_aplikacia":     "Nastavení aplikace",
      "settings_notifikacie":   "Upozornění",
      "settings_zapnute":       "Zapnuto",
      "settings_vypnute":       "Vypnuto",
      "settings_vyberregionu":  "Výběr regionu",
      "settings_oaplikaci":     "Jak funguje aplikace?",
      "settings_informacie":    "Informace",
      "settings_ochranaos":     "Ochrana osobných údajov",
      "settings_gdpr":          "Podmínky používání",

      "payment_small_text":             "Předplatné si můžete zakoupit kliknutím na tlačítka níže. Můžete si vybrat mezi měsíčním předplatným (249 Kč/měsíc) a půlročním předplatným (1199 Kč/půlročně - v přepočtu 199 Kč/měsíc). Předplatné se automaticky obnovuje a lze jej kdykoli zrušit v nastavení App Store.",


      "payment_sub_thanks":             "Děkujeme, že jste součástí komunity <b>Cestujeme levně PREMIUM!</b>",
      "payment_sub_text1":              "Získali jste <b>plný přístup</b> ke všem našim exkluzivním nabídkám! Co vám přináší naše PREMIUM členství:<br> <br> ✈️ <b>Každý den nové nabídk</b> za exkluzivní ceny<br> 🌍 <b>Levné letenky a ubytování</b> v oblíbených destinacích<br> 🗺️ <b>Praktické tipy a doporučení</b> z první ruky<br> 📱 <b>Kompletní informace</b> přehledně na jednom místě<br> 🔔 <b>Okamžitá upozornění</b> na nové nabídky<br> 💸 <b>Až 70% úspory</b> oproti běžným cenám letenek <br><br> <b>Spravovat předplatné</b> můžete přímo v nastavení App Store kliknutím na tlačítko níže:",
      "payment_sub_stepredplatitelom":  "Jste předplatitelem!",
      "payment_sub_obnovisa":           "Obnoví se",
      "payment_sub_expiruje":           "Předplaceno do",
      "payment_sub_spravovat":          "Spravovat předplatné",


      "payment_no_title":             "Získejte plný přístup do PREMIUM verze!",
      "payment_no_text1":             "🔓 <b>Odemkněte si všechny naše nabídky</b> a využijte <b>exkluzivní ceny</b>, které jinde nenajdete. Všechno jednoduše <b>za pár kliknutí</b> ve vašem mobilu!<br> <hr> <br> ✈️ <b>Každý den nové nabídky</b> za exkluzivní ceny<br> 🌍 <b>Levné letenky a ubytování</b> v oblíbených destinacích<br> 📱 <b>Kompletní informace</b> přehledně na jednom místě<br> 🔔 <b>Okamžitá upozornění</b> na nové nabídky<br> 👍 <b>Ověřeno</b> tisíci spokojených uživatelů<br> 🔍 <b>Dlouholeté zkušenosti</b> s levnými letenkami<br> 💸 <b>Bez skrytých poplatků</b> - předplatné můžete kdykoli zrušit<br> 💳 <b>Rychlá a bezpečná platba</b> přes Apple Pay/Google Pay <hr>",
      "payment_no_restore":           "Obnovit předchozí nákupy", 

     
      "payment_product1_title":       "Měsíční předplatné",
      "payment_product1_desc":        "(sleva 50% z 499 Kč)",
      "payment_product2_title":       "Půlroční předplatné",
      "payment_product2_desc":        "(sleva 60% z 2 999 Kč)",
      "payment_zlavovykod":           "Slevový kód",


      "nointernet_oops":                "Ooops!",
      "nointernet_skontrolujte":        "Zkontrolujte své připojení k internetu",
      "nointernet_bezpripojenia":       "Bez připojení k internetu",

      "vypis_lenza":            "Pouze za",
      "vypis_pridane":          "Přidáno",
      "vypis_usertriteat":      "Ušetříte až",
      "vypis_osoba":             "osoba",

      "jazyk_title2":             "Potvrďte správný výběr regionu",
      "jazyk_potvrdit":           "Potvrdit",

      "slidy_preskocit":          "Přeskočit",
      "slidy_dalej":              "Dále",
      "slidy_zobrazitponuky":     "Zobrazit nabídky",





      "slidy_nadpis1":             "Exkluzivní nabídky na levné letenky a ubytování každý den přímo ve vašem mobilu!",      
      "slidy_nadpis1_2":           "Vítejte v aplikaci Cestujeme levně! S námi ušetříte stovky eur na dovolené bez cestovky!",      
      "slidy_nadpis1_3":           "Ukázková nabídka:",      
      "slidy_nadpis2":             "Kompletní informace přehledně na jednom místě",      
      "slidy_nadpis3":             "Okamžitá upozornění na nové nabídky",      
      "slidy_nadpis4":             "Aplikace ověřena uživateli",      
      "slidy_nadpis5":             "Získejte plný přístup ihned!",      
     
      "slidy_text1":              "<p>❌ Běžná cena: <s>2500 Kč</s><br> ✅ Naše cena: <b>505 Kč</b><br><br> 💸 Ušetříte v průměru <b>až 70%!</b></p>  <p>🇮🇹 Levný výlet do Říma:<br> ✈️ Zpáteční letenky za <b>505 Kč</b><br> 🏨 Ubytování na 3 dny za <b>1714 Kč</b><br> ✈️+🏨 Letenky + ubytování na 3 dny <b>jen za 2219 Kč!</b><br><br> 💸 Všechny ceny jsou <b>konečné!</b></p>",
      "slidy_text2":              "Nikdo jiný vám neposkytne tolik <b>kvalitních a ověřených informací</b> ke každé nabídce:<br> <br>  ✈️ <b>Levné letenky</b> - přímo s odkazem na rezervaci<br> 🏨 <b>Výhodné a ověřené ubytování</b> - s odkazem na rezervaci<br> 💸 <b>Bez skrytých poplatků</b> –  letenky i ubytování si rezervujete napřímo za nejnižší ceny, u nás neplatíte nic navíc<br> 📅 <b>Více termínů za stejnou cenu</b> - stačí kliknout a rezervovat<br> 🧳 <b>Informace o zavazadlech</b> - přesné rozměry a váha povoleného zavazadla<br> 🚌 <b>Doprava z letiště</b> - detailní návod, jak se dostat do centra<br> 📝 <b>Praktické tipy</b> - doporučení z první ruky<br> 🗺️ <b>Ukázkový itinerář</b> - návrhy, co se vyplatí vidět a zažít<br> ☀️ <b>Počasí v destinaci + fotogalerie</b><br> ✨ <b>a mnoho dalšího…</b> <br><br>Nemusíte trávit hodiny hledáním letenek a ubytování, vše naleznete ihned v aplikaci <b>za pár kliknutí!</b>",
      "slidy_text3":              "🔔 <b>Zapněte si notifikace</b> a už vám neunikne žádná nová nabídka!<br> <br> O všech výhodných akcích se dozvíte <b>jako první</b> a můžete tak cestovat za ty <b>nejnižší ceny!</b>",
      "slidy_text4":              "Naše aplikace pomohla <b>tisícům cestovatelů</b> ušetřit stovky eur - přidejte se k našim spokojeným členům!<br> <br> Exkluzivní nabídky vám <b>každý den</b> přinášíme <b>již 8 let</b> - s ověřenými tipy a bez skrytých poplatků!<br> <br> <p><b> 🔍 8+ let zkušeností<br> 👍 Tisíce spokojených uživatelů </p>  ⭐ Co o nás řekli naši uživatelé:<br>",
      "slidy_text4_app":          "2. nejstahovanější aplikace v kategorii cestování",
      "slidy_text5":              "<b>Odemkněte plný přístup</b> ke všem našim nabídkám s předplatným již od <b>199 Kč za měsíc!</b> <br> <br> Platba <b>rychle a jednoduše</b> přes Apple Pay <br> <br> Čekají na vás <b>exkluzivní nabídky</b> každý den<br> <br> S námi ušetříte <b>stovky</b> eur na dovolené bez <b>cestovky!</b>",
    
      "review_1_name" : "Sofia T.",
      "review_1_text" : "Appka se super nabídkami pro cestovatele. Určitě doporučuji, velmi přehledně udělané a skvělý přístup.",
      "review_2_name" : "Silvia L.",
      "review_2_text" : "Perfektní aplikace, neskutečně dobré tipy a rady k cestování, využívám pravidelně a jsem velmi spokojená a inspirovaná.",
      "review_3_name" : "Erik K.",
      "review_3_text" : "Velmi mnoho výhodných nabídek, přehledné, ochotni pomoci, rozhodně se to vyplatí.",
      "review_4_name" : "Silvia K.",
      "review_4_text" : "Velká spokojenost. Spousta dobrých doporučení, rad, zkušenosti a odpověď na každou jednu otázku. Určitě doporučuji. Velký dík.",

      "slidy_text1_button":       "Prohlédnout nejnovější nabídky",
      "slidy_text2_button":       "Získejte přístup k ověřeným informacím již nyní!",
      "slidy_text3_button":       "Zapnout notifikace",
      "slidy_text4_button":       "Staňte se členem nyní a začněte šetřit!",
      "slidy_text5_button":       "Získat přístup již od 199 Kč!",







      "detail_termin":                  "Termín",
      "detail_letenkykupitetu":         "Letenky koupíte zde",
      "detail_trvanieletu":             "Trvání letu",
      "detail_tipnaubytovanie":         "Tip na ubytování",
      "detail_ubytovaniekupitetu":      "Ubytování koupíte zde",
      "detail_dalsieterminy":           "Další termíny",
      "detail_zobrvsetkyterminy":       "Zobrazit všechny termíny",
      "detail_vsetkyaktterminy":        "Všechny aktuální termíny",
      "detail_blizsieinfo":              "Podrobnější informace",
      "detail_tipyprecest":              "Praktické tipy pro cestovatele",
      "detail_pocasiepocaspobytu":       "Počasí na místě během pobytu",
      "detail_datazminroka":             "(Data jsou z minulého roku)",
      "detail_viacodest":                "Více o destinaci",
      "detail_zobrcelypopis":            "Zobrazit celý popis",

      "infodetailnopaymenttext":         "<p>🔒Pro zobrazení všech informací si předplaťte <b>PREMIUM verzi</b> a odemkněte si <b>přístup ke všem nabídkám:</b></p> <hr> <p>Každá nabídka obsahuje <b>kvalitní a ověřené informace:</b></p>✈️ <b>Levné letenky</b> - přímo s odkazem na rezervaci<br> 🏨 <b>Výhodné a ověřené ubytování</b> - s odkazem na rezervaci<br> 💸 <b>Bez skrytých poplatků</b> – letenky i ubytování si rezervujete napřímo za nejnižší ceny, u nás neplatíte nic navíc<br> 📅 <b>Více termínů za stejnou cenu</b> - stačí kliknout a rezervovat<br> 🧳 <b>Informace o zavazadlech</b> - přesné rozměry a váha povoleného zavazadla<br> 🚌 <b>Doprava z letiště</b> - detailní návod, jak se dostat do centra<br> 📝 <b>Praktické tipy</b> - doporučení z první ruky<br> 🗺️ <b>Ukázkový itinerář</b> - návrhy, co se vyplatí vidět a zažít<br> ☀️ <b>Počasí v destinaci + fotogalerie</b><br> ✨ <b>a mnoho dalšího…</b><br>  <br><hr> Jak vypadá <b>plný přístup</b> na ukázku? Klepněte na odemčené nabídky ve spodním menu.<br> <br> Nezmeškejte tuto příležitost, čekají na vás <b>exkluzivní nabídky</b> každý den!<br> <br> Odemkněte si přístup <b>rychle a jednoduše</b> přes Apple Pay:",
        
      "infopage":            "Děkujeme, že jste součástí komunity <b>Cestujeme levně PREMIUM!</b><br> <br> Jako náš PREMIUM člen máte přístup ke <b>všem exkluzivním nabídkám</b> a užitečným informacím, které vám pomohou ušetřit stovky eur na dovolené bez cestovky.<br> <br> Co vám přináší naše PREMIUM členství:<br> <br> ✈️ <b>Každý den nové nabídky</b> za exkluzivní ceny<br> 🌍 <b>Levné letenky a ubytování</b> v oblíbených destinacích<br> 🗺️ <b>Praktické tipy</b> a doporučení z první ruky<br> 📱 <b>Kompletní informace</b> přehledně na jednom místě<br> 🔔 <b>Okamžitá upozornění</b> na nové nabídky<br> 💸 <b>Až 70% úspory</b> oproti běžným cenám letenek<br> <br> <br> ⭐ <b>Spokojenost našich členů</b> je pro nás prioritou! Pokud využíváte výhod naší aplikace a pomohla vám ušetřit na cestování, budeme velmi rádi za recenzi na App Store nebo Google Play.<br> <br> <b>Děkujeme</b> za vaši důvěru a přejeme vám skvělé zážitky na vašich cestách!",
      
      "button_predplatit_detail":      "Předplatit a získat přístup ihned!"


     }''');

  /* HU */
  var strings_hu = json.decode('''{

      "ukazka_leteniek_z":      "Repülőjegyek előnézete", 
      "ukazka_ubytovania_z":    "Szállás előnézete", 

      "flight_duration":      "óra", 
      "ukazkovy_itinerar":      "Minta útiterv", 

      "appbar_title":           "Olcsón utazunk", 
      "appbar_title2":          "Olcsó nyaralási ajánlat",

       "button_predplatit":      "Feliratkozás",
       "nahlasit_chybu":         "Hiba jelentése",

      "settings_aplikacia":     "Beállítások",
      "settings_notifikacie":   "Értesítések",
      "settings_zapnute":       "Be",
      "settings_vypnute":       "Ki",
      "settings_vyberregionu":  "Régió kiválasztása",
      "settings_oaplikaci":     "Hogyan működik az alkalmazás?",
      "settings_informacie":    "Információk",
      "settings_ochranaos":     "Személyes adatok védelme",
      "settings_gdpr":          "Felhasználási feltételek",

      "payment_small_text":             "Előfizetést az alábbi gombokra kattintva vásárolhat. Választhat a havi előfizetés (3 990 Ft/hó) és a féléves előfizetés (17 990 Ft/félév - átszámítva 2 998 Ft/hó) között. Az előfizetések automatikusan megújulnak, és bármikor lemondhatók a Google Play/App Store beállításaiban.",


      "payment_sub_thanks":             "Köszönjük, hogy a közösség tagja vagy <b>Olcsón utazunk PREMIUM!</b>",
      "payment_sub_text1":              "Minden exkluzív ajánlatunkhoz teljes hozzáférést kap! Amit PREMIUM tagságunk hoz neked:<br> <br> ✈️ <b>Minden nap</b> új ajánlatok exkluzív árakon<br> 🌍 <b>Olcsó repülőjegyek</b> és szállások népszerű úti célokra<br> 🗺️ <b>Gyakorlati tippek</b> és ajánlások első kézből<br> 📱 <b>Teljes információ</b> egyértelműen egy helyen<br> 🔔 <b>Azonnali értesítések</b> az új ajánlatokról<br> 💸 <b>Akár 70% megtakarítás</b> a normál jegyárakhoz képest <br><br>Az alábbi gombra kattintva közvetlenül kezelheti előfizetését a App Store beállításaiban:",
       "payment_sub_stepredplatitelom":  "Sikeresen előfizettél",
      "payment_sub_obnovisa":           "Megújítás",
      "payment_sub_expiruje":           "Az előfizetés ig érvényes",
      "payment_sub_spravovat":          "Előfizetések kezelése",
     
      "payment_no_title":             "Teljes hozzáférést kap a PREMIUM verzióhoz!",
      "payment_no_text1":             "🔓 <b>Feloldja meg az összes ajánlatunkat,</b> és használja ki az <b>exkluzív árak</b>, előnyeit, amelyeket sehol máshol nem talál meg. Minden egyszerűen <b>néhány kattintással</b> a mobilodon!<br> <hr> <br> ✈️ <b>Minden nap</b> új ajánlatok exkluzív árakon<br> 🌍 <b>Olcsó repülőjegyek és szállások</b> népszerű úti célokra<br> 📱 <b>Teljes információ</b> egyértelműen egy helyen<br> 🔔 <b>Azonnali értesítések</b> az új ajánlatokról<br> 👍 <b>Több ezer elégedett</b> felhasználó ellenőrizte<br> 🔍 <b>Sok éves tapasztalat</b> olcsó jegyekkel <br> 💸 <b>Nincsenek rejtett díjak</b> - előfizetését bármikor lemondhatja<br> 💳 <b>Gyors és biztonságos fizetés</b> az Apple Pay/Google Pay segítségével <hr>",
      "payment_no_restore":           "Korábbi vásárlások visszaállítása", 
      
      "payment_product1_title":       "Havi előfizetés",
      "payment_product1_desc":        "(50% kedvezmény a teljes árból: 7 990 Ft)",
      "payment_product2_title":       "Féléves előfizetés",
      "payment_product2_desc":        "(60% kedvezmény a teljes árból: 44 990 Ft)",
      "payment_zlavovykod":           "Kedvezményes kód",


      "nointernet_oops":                "Hoppá!",
      "nointernet_skontrolujte":        "Ellenőrizd az internetkapcsolatot",
      "nointernet_bezpripojenia":       "Nincs internetkapcsolat",

      "vypis_lenza":            "Csak",
      "vypis_pridane":          "Hozzáadva",
      "vypis_usertriteat":      "Megtakarítás akár",
      "vypis_osoba":             "fő",

      "jazyk_title2":             "Erősítsd meg a megfelelő régió kiválasztását",
      "jazyk_potvrdit":           "Megerősít",

      "slidy_preskocit":          "Kihagyás",
      "slidy_dalej":              "Tovább",
      "slidy_zobrazitponuky":     "Ajánlatok megjelenítése",






     "slidy_nadpis1":             "Exkluzív ajánlatok olcsó repülőjegyekre és szállásokra minden nap közvetlenül a mobilodon!",      
      "slidy_nadpis1_2":           "Üdvözöljük az Olcsón utazunk alkalmazásban! Nálunk több száz eurót takaríthat meg a nyaraláson utazási iroda nélkül!",      
      "slidy_nadpis1_3":           "Minta ajánlat:",      
      "slidy_nadpis2":             "Teljes információ egyértelműen egy helyen",      
      "slidy_nadpis3":             "Azonnali értesítés az új ajánlatokról",      
      "slidy_nadpis4":             "Az alkalmazást a felhasználók ellenőrizték",      
      "slidy_nadpis5":             "Szerezzen teljes hozzáférést most!",      
     
      "slidy_text1":              "<p>❌ Normál áron: <s>40 000 Ft</s><br> ✅ A mi árunk: <b>7 999 Ft</b><br><br> 💸 Átlagosan akár <b>70%-ot</b> takaríthat meg!</p>  <p>🇮🇹 Olcsó utazás Rómába:<br> ✈️ Retúr jegyek <b>7 999 Ft-ért</b><br> 🏨 3 napos szállás <b>27 800 Ft-ért</b><br> ✈️+🏨 Jegyek + szállás 3 napra mindössze <b>35 799 Ft-ért!</b><br><br> 💸 Minden ár <b>végleges!</b></p>",
      "slidy_text2":              "Senki más nem fog ennyi <b>minőségi és ellenőrzött információt</b> biztosítani minden ajánlathoz:<br> <br>  ✈️ <b>Olcsó repülőjegyek</b> - közvetlenül a foglalásra mutató linkkel<br> 🏨 <b>Megfizethető és ellenőrzött szállás</b> - a foglalás linkjével<br> 💸 <b>Nincsenek rejtett díjak</b> – közvetlenül a legalacsonyabb árakon foglal repülőjegyet és szállást, nem fizet nekünk pluszt<br> 📅 <b>Több időpont ugyanazon az áron</b> - csak kattintson és foglaljon<br> 🧳 <b>Információ a poggyászról</b> - a megengedett poggyász pontos méretei és súlya<br> 🚌 <b>Szállítás a repülőtérről</b> - részletes útmutatás a központba jutáshoz<br> 📝 <b>Gyakorlati tippek</b> - első kézből származó ajánlások<br> 🗺️ <b>Útvonalminta</b> - javaslatok, hogy mit érdemes megnézni és megtapasztalni<br> ☀️ <b>Időjárás a célállomáson + képgaléria</b><br> ✨ <b>és még sok más…</b><br><br>Nem kell órákat töltened repülőjegy- és szálláskereséssel, az alkalmazásban néhány kattintással mindent azonnal megtalálsz!",
      "slidy_text3":              "🔔 <b>Kapcsolja be az értesítéseket</b> és nem marad le új ajánlatokról!<br> <br> Minden akcióról elsőként <b>értesülhet,</b> így a legalacsonyabb <b>árakon utazhat!</b>",
      "slidy_text4":              "Alkalmazásunk <b>több ezer utazónak</b> segített több száz eurót megtakarítani – csatlakozzon elégedett tagjainkhoz!<br> <br> Exkluzív ajánlatokat kínálunk <b>minden nap 8 éve</b> - ellenőrzött tippekkel és rejtett díjak nélkül!<br> <br> <p><b> 🔍 8+ év tapasztalat<br> 👍 Több ezer elégedett felhasználó </p>  ⭐ Amit felhasználóink ​​mondtak rólunk:<br>",
      "slidy_text4_app":          "A 2. legtöbbet letöltött alkalmazás az utazási kategóriában",
      "slidy_text5":              "<b>Nyújtson teljes hozzáférést</b> minden előfizetési ajánlatunkhoz <b>2998 Ft havi-tól!</b> <br> <br> Fizetés gyors és egyszerű az Apple Pay segítségével <br> <br> <b>Exkluzív ajánlatok</b> várnak rád minden nap<br> <br> Nálunk több száz eurót takaríthat meg a nyaraláson utazási iroda nélkül!",
    
      "review_1_name" : "Sofia T.",
      "review_1_text" : "Alkalmazás nagyszerű ajánlatokkal utazók számára. Határozottan ajánlom, nagyon áttekinthető elrendezés és nagyszerű megközelítés.",
      "review_2_name" : "Silvia L.",
      "review_2_text" : "Tökéletes alkalmazás, hihetetlenül jó utazási tippek és tanácsok, rendszeresen használom, nagyon elégedett és inspirált.",
      "review_3_name" : "Erik K.",
      "review_3_text" : "Rengeteg alku, világos, segítőkész, mindenképp megéri.",
      "review_4_name" : "Silvia K.",
      "review_4_text" : "Nagy elégedettség. Sok jó ajánlás, tanács, tapasztalat és válasz minden kérdésre. határozottan ajánlom. Köszönöm szépen.",

      "slidy_text1_button":       "Tekintse meg a legújabb ajánlatokat",
      "slidy_text2_button":       "Hozzáférés az ellenőrzött információkhoz most!",
      "slidy_text3_button":       "Kapcsolja be az értesítéseket",
      "slidy_text4_button":       "Légy tag most és kezdj el spórolni!",
      "slidy_text5_button":       "Hozzáférés mindössze 2998 Ft-tól!",





      "detail_termin":                  "Időpont",
      "detail_letenkykupitetu":         "Vásárolj repülőjegyet itt",
      "detail_trvanieletu":             "Repülési idő",
      "detail_tipnaubytovanie":         "Szállás tippek",
      "detail_ubytovaniekupitetu":      "Válaszd ki a szállásodat",
      "detail_dalsieterminy":           "Egyéb időpontok",
      "detail_zobrvsetkyterminy":       "Mutasd az összes időpontot",
      "detail_vsetkyaktterminy":        "Az összes aktuális időpont",
      "detail_blizsieinfo":              "További információk",
      "detail_tipyprecest":              "Hasznos tippek az utazáshoz",
      "detail_pocasiepocaspobytu":       "Időjárás az úti célnál a tartózkodás alatt",
      "detail_datazminroka":             "(Az adatok tavalyiak)",
      "detail_viacodest":                "Több információ a célállomásról",
      "detail_zobrcelypopis":            "Teljes leírás megjelenítése",

       "infodetailnopaymenttext":         "<p>🔒Az összes információ megtekintéséhez iratkozzon fel a <b>PREMIUM verzióra,</b> és nyissa meg a <b>hozzáférést az összes ajánlathoz:</b></p> <hr> <p>Minden ajánlat <b>minőségi és ellenőrzött információkat</b> tartalmaz: </p>✈️ <b>Olcsó repülőjegyek</b> - közvetlenül a foglalásra mutató linkkel<br> 🏨 <b>Megfizethető és ellenőrzött szállás</b> - a foglalás linkjével<br> 💸 <b>Nincsenek rejtett díjak</b> – közvetlenül a legalacsonyabb árakon foglal repülőjegyet és szállást, nem fizet nekünk pluszt<br> 📅 <b>Több időpont ugyanazon az áron</b> - csak kattintson és foglaljon<br> 🧳 <b>nformáció a poggyászról</b> - a megengedett poggyász pontos méretei és súlya<br> 🚌 <b>Szállítás a repülőtérről</b> - részletes útmutatás a központba jutáshoz<br> 📝 <b>Gyakorlati tippek</b> - első kézből származó ajánlások<br> 🗺️ <b>Útvonalminta</b> - javaslatok, hogy mit érdemes megnézni és megtapasztalni<br> ☀️ <b>Időjárás a célállomáson + képgaléria</b><br> ✨ <b>és még sok más…</b><br>  <br><hr> Hogyan néz ki a <b>teljes hozzáférés</b> az előnézethez? Kattintson a feloldott menükre az alsó menüben.<br> <br> Ne hagyd ki ezt a lehetőséget, minden nap <b>exkluzív ajánlatok</b> várnak rád!<br> <br> Nyissa fel a hozzáférést <b>gyorsan és egyszerűen</b> az Apple Pay segítségével:",
        
      "infopage":            "Köszönjük, hogy a közösség tagja vagy <b>Olcsón utazunk PREMIUM!</b><br> <br> PREMIUM tagunkként <b>minden exkluzív ajánlathoz</b> és hasznos információhoz hozzáférhet, amelyek segítségével több száz eurót takaríthat meg utazási jegy nélküli nyaralása során.<br> <br> Amit PREMIUM tagságunk hoz neked:<br> <br> ✈️ <b>Minden nap</b> új ajánlatok exkluzív árakon<br> 🌍 <b>Olcsó repülőjegyek</b> és szállások népszerű úti célokra<br> 🗺️ <b>Gyakorlati tippek</b> és ajánlások első kézből<br> 📱 <b>Teljes információ</b> egyértelműen egy helyen<br> 🔔 <b>Azonnali értesítések</b> az új ajánlatokról<br> 💸 <b>Akár 70% megtakarítás</b> a normál jegyárakhoz képest<br> <br> <br> ⭐ <b>A tagok elégedettsége</b> számunkra elsődleges! Ha használja alkalmazásunk előnyeit, és az utazási költséget takarít meg, nagyon örülnénk, ha véleményt írna az App Store-ról vagy a Google Playről.<br> <br> <b>Köszönjük</b> a bizalmat, és jó élményeket kívánunk utazásaihoz!",
      
      "button_predplatit_detail":      "Iratkozz fel és érd el most!"
  
   }''');

  /* PL */
  var strings_pl = json.decode('''{

      "ukazka_leteniek_z":      "Podgląd biletów lotniczych od", 
      "ukazka_ubytovania_z":    "Podgląd noclegów od", 

      "flight_duration":      "godz.", 
      "ukazkovy_itinerar":      "Przykładowy plan podróży", 


      "appbar_title":           "Podróżujemy tanio", 
      "appbar_title2":          "Wakacje bez biura podróży",

       "button_predplatit":      "Subskrybuj",
       "nahlasit_chybu":         "Zgłoś błąd",

      "settings_aplikacia":     "Ustawienia aplikacji",
      "settings_notifikacie":   "Powiadomienia",
      "settings_zapnute":       "Włączone",
      "settings_vypnute":       "Wyłączone",
      "settings_vyberregionu":  "Wybór regionu",
      "settings_oaplikaci":     "Jak działa aplikacja?",
      "settings_informacie":    "Informacje",
      "settings_ochranaos":     "Ochrona danych osobowych",
      "settings_gdpr":          "Warunki użytkowania",

      "payment_small_text":             "Subskrypcję można zakupić, klikając poniższe przyciski. Do wyboru jest subskrypcja miesięczna (49,99 zł/miesiąc) lub półroczna (199,99 zł/pół roku - w przeliczeniu 33,33 zł/miesiąc). Subskrypcje odnawiają się automatycznie i można je anulować w dowolnym momencie w ustawieniach App Store.",


      "payment_sub_thanks":             "Dziękujemy, że jesteś częścią społeczności <b>Podróżujemy tanio PREMIUM!<//b>",
      "payment_sub_text1":              "Masz <b>pełny dostęp</b> do wszystkich naszych ekskluzywnych ofert! Co daje członkostwo PREMIUM:<br> <br> ✈️ <b>Codziennie nowe oferty</b> w ekskluzywnych cenach<br> 🌍 <b>Tanie loty i noclegi</b> w popularnych kierunkach<br> 🗺️ <b>Praktyczne wskazówki i rekomendacje</b> z pierwszej ręki<br> 📱 <b>Kompletne informacje</b> przejrzyście w jednym miejscu<br> 🔔 <b>Natychmiastowe powiadomienia</b> o nowych ofertach<br> 💸 <b>Do 70% oszczędności</b> w porównaniu do normalnych cen biletów<br><br>Możesz <b>zarządzać swoją subskrypcją</b> bezpośrednio w ustawieniach Google Play/App Store, klikając poniższy przycisk:",
      "payment_sub_stepredplatitelom":  "Jesteś subskrybentem!",
      "payment_sub_obnovisa":           "Odnowa",
      "payment_sub_expiruje":           "Subskrypcja ważna do",
      "payment_sub_spravovat":          "Zarządzanie subskrypcjami",
      
      "payment_no_title":             "Uzyskaj pełny dostęp do wersji PREMIUM!",
      "payment_no_text1":             "🔓 <b>Odblokuj wszystkie nasze oferty</b> i skorzystaj z <b>ekskluzywnych cen</b>, których nie znajdziesz nigdzie indziej. Wszystko <b>za pomocą kilku kliknięć</b> na telefonie komórkowym!<br> <hr> <br> ✈️ <b>Codziennie nowe oferty</b> w ekskluzywnych cenach<br> 🌍 <b>Tanie loty i noclegi</b> w popularnych kierunkach<br> 📱 <b>Kompletne informacje</b> przejrzyście w jednym miejscu<br> 🔔 <b>Natychmiastowe powiadomienia</b> o nowych ofertach<br> 👍 <b>Sprawdzone</b> przez tysiące zadowolonych użytkowników<br> 🔍 <b>Wieloletnie doświadczenie</b> z tanimi biletami<br> 💸 <b>Żadnych ukrytych opłat</b> - w każdej chwili możesz zrezygnować z subskrypcji<br> 💳 <b>Szybka i bezpieczna płatność</b> za pośrednictwem Apple Pay/Google Pay <hr>",
      "payment_no_restore":           "Przywróć poprzednie zakupy",   
      
      "payment_product1_title":       "Miesięczna subskrypcja",
      "payment_product1_desc":        "(rabat 50% z 99,99 zł)",
      "payment_product2_title":       "Półroczna subskrypcja",
      "payment_product2_desc":        "(rabat 60% z 479,99 zł)",
      "payment_zlavovykod":           "Kod rabatowy",


      "nointernet_oops":                "Ups!",
      "nointernet_skontrolujte":        "Sprawdź swoje połączenie internetowe",
      "nointernet_bezpripojenia":       "Brak połączenia z internetem",

      "vypis_lenza":            "Tylko za",
      "vypis_pridane":          "Dodane",
      "vypis_usertriteat":      "Zaoszczędź do",
      "vypis_osoba":             "osoba",

      "jazyk_title2":             "Potwierdź poprawny wybór regionu",
      "jazyk_potvrdit":           "Potwierdź",

      "slidy_preskocit":          "Pomiń",
      "slidy_dalej":              "Dalej",
      "slidy_zobrazitponuky":     "Pokaż oferty",

     
     
      "slidy_nadpis1":             "Ekskluzywne oferty tanich lotów i zakwaterowania codziennie bezpośrednio w telefonie komórkowym!",      
      "slidy_nadpis1_2":           "Witamy w aplikacji Podróżujemy tanio! Z nami zaoszczędzisz setki euro na wakacjach bez biura podróży!",      
      "slidy_nadpis1_3":           "Przykładowa oferta:",      
      "slidy_nadpis2":             "Kompletne informacje w przejrzysty sposób w jednym miejscu",      
      "slidy_nadpis3":             "Natychmiastowe powiadomienia o nowych ofertach",      
      "slidy_nadpis4":             "Aplikacja zweryfikowana przez użytkowników",      
      "slidy_nadpis5":             "Uzyskaj pełny dostęp już teraz!",      
     
      "slidy_text1":              "<p>❌ Cena regularna: <s>400 zł</s><br> ✅ Nasza cena: <b>86 zł</b><br><br> 💸 Oszczędzasz średnio <b>do 70%!</b></p>  <p>🇮🇹 Tania wycieczka do Rzymu:<br> ✈️ Bilety powrotne w cenie <b>86 zł</b><br> 🏨 Nocleg na 3 dni w cenie <b>293 zł</b><br> ✈️+🏨 Bilety lotnicze + nocleg na 3 dni za jedyne <b>379 zł!</b><br><br> 💸 Wszystkie ceny są <b>ostateczne!</b></p>",      
      "slidy_text2":              "Nikt inny nie zapewni Ci tak <b>wysokiej jakości i zweryfikowanych informacji</b> na temat każdej oferty:<br> <br>  ✈️ <b>Tanie loty</b> - bezpośrednio z linkiem do rezerwacji<br> 🏨 <b>Niedrogie i sprawdzone noclegi </b> - z linkiem do rezerwacji<br> 💸 <b>Żadnych ukrytych opłat</b> – rezerwujesz loty i noclegi bezpośrednio w najniższych cenach, u nas nie płacisz dodatkowo<br> 📅 <b>Wiele terminów w tej samej cenie</b> - wystarczy kliknąć i zarezerwować<br> 🧳 <b>Informacje o bagażu</b> - dokładne wymiary i waga dozwolonego bagażu<br> 🚌 <b>Transport z lotniska</b> - szczegółowa instrukcja jak dojechać do centrum<br> 📝 <b>Praktyczne wskazówki</b> - rekomendacje z pierwszej ręki<br> 🗺️ <b>Przykładowy plan podróży</b> - propozycje tego, co warto zobaczyć i przeżyć<br> ☀️ <b>Pogoda w miejscu docelowym + galeria zdjęć</b><br> ✨ <b>i wiele więcej…</b><br><br>Nie musisz tracić godzin na szukanie lotów i noclegów, wszystko znajdziesz od razu w aplikacji <b>za pomocą kilku kliknięć!</b>",      
      "slidy_text3":              "🔔 <b>Włącz powiadomienia,</b> a nie przegapisz żadnej nowej oferty!<br> <br> Będziesz <b>pierwszą osobą,</b> która dowie się o wszystkich ofertach specjalnych, dzięki czemu będziesz mógł podróżować po <b>najniższych cenach!</b>",     
      "slidy_text4":              "Nasza aplikacja pomogła <b>tysiącom podróżnych</b> zaoszczędzić setki euro - dołącz do naszych zadowolonych członków!<br> <br> <b>Od 8 lat codziennie</b> dostarczamy Ci ekskluzywne oferty - ze zweryfikowanymi typami i bez ukrytych opłat!<br> <br> <p><b> 🔍 Ponad 8 lat doświadczenia<br> 👍 Tysiące zadowolonych użytkowników </p>  ⭐ Co powiedzieli o nas nasi użytkownicy:<br>",
      "slidy_text4_app":          "Druga najczęściej pobierana aplikacja w kategorii podróże",     
      "slidy_text5":              "<b>Odblokuj pełen dostęp</b> do wszystkich naszych ofert abonamentowych już od <b>33,33 zł miesięcznie!</b> <br> <br><b>Szybka i łatwa</b> płatność za pośrednictwem Apple Pay <br> <br> <b>Ekskluzywne oferty</b> czekają na Ciebie każdego dnia<br> <br> Dzięki nam <b>oszczędzisz setki euro</b> na wakacjach <b>bez biura podróży!</b>",
    
      "review_1_name" : "Sofia T.",
      "review_1_text" : "Aplikacja ze świetnymi ofertami dla podróżnych. Zdecydowanie polecam, bardzo przejrzyście ułożone i świetne podejście.",
      "review_2_name" : "Silvia L.",
      "review_2_text" : "Doskonała aplikacja, niesamowicie dobre wskazówki i rady podróżnicze, korzystam regularnie i jestem bardzo zadowolona i zainspirowana.",
      "review_3_name" : "Erik K.",
      "review_3_text" : "Dużo okazji, jasne, chętne do pomocy, zdecydowanie warto.",
      "review_4_name" : "Silvia K.",
      "review_4_text" : "Wielka satysfakcja. Mnóstwo dobrych rekomendacji, porad, doświadczeń i odpowiedzi na każde pytanie. Zdecydowanie polecam. Wielkie dzięki",

      "slidy_text1_button":       "Zobacz najnowsze oferty",
      "slidy_text2_button":       "Uzyskaj dostęp do zweryfikowanych informacji już teraz!",
      "slidy_text3_button":       "Włącz powiadomienia",
      "slidy_text4_button":       "Zostań członkiem już teraz i zacznij oszczędzać!",
      "slidy_text5_button":       "Uzyskaj dostęp już od 33,33 zł!",







      "detail_termin":                  "Termin",
      "detail_letenkykupitetu":         "Bilety lotnicze kupisz tutaj",
      "detail_trvanieletu":             "Czas trwania lotu",
      "detail_tipnaubytovanie":         "Porada dotycząca zakwaterowania",
      "detail_ubytovaniekupitetu":      "Zakwaterowanie kupisz tutaj",
      "detail_dalsieterminy":           "Kolejne terminy",
      "detail_zobrvsetkyterminy":       "Pokaż wszystkie terminy",
      "detail_vsetkyaktterminy":        "Wszystkie aktualne terminy",
      "detail_blizsieinfo":              "Więcej informacji",
      "detail_tipyprecest":              "Praktyczne wskazówki dla podróżnych",
      "detail_pocasiepocaspobytu":       "Pogoda w miejscu pobytu",
      "detail_datazminroka":             "(Dane są z zeszłego roku)",
      "detail_viacodest":                "Więcej o miejscu docelowym",
      "detail_zobrcelypopis":            "Pokaż cały opis",

       "infodetailnopaymenttext":         "<p>🔒Aby zobaczyć wszystkie informacje, zapisz się na <b>wersję PREMIUM</b> i odblokuj dostęp <b>do wszystkich ofert:</b></p> <hr> <p>Każda oferta zawiera <b>jakościowe i sprawdzone informacje:</b></p>✈️ <b>Tanie loty</b> - bezpośrednio z linkiem do rezerwacji<br> 🏨 <b>Niedrogie i sprawdzone noclegi</b> - z linkiem do rezerwacji<br> 💸 <b>Żadnych ukrytych opłat</b> – rezerwujesz loty i noclegi bezpośrednio w najniższych cenach, u nas nie płacisz dodatkowo<br> 📅 <b>Wiele terminów w tej samej cenie</b> - wystarczy kliknąć i zarezerwować<br> 🧳 <b> Informacje o bagażu</b> - dokładne wymiary i waga dozwolonego bagażu<br> 🚌 <b>Transport z lotniska</b> - szczegółowa instrukcja jak dojechać do centrum<br> 📝 <b>Praktyczne wskazówki</b> - rekomendacje z pierwszej ręki<br> 🗺️ <b>Przykładowy plan podróży</b> - propozycje tego, co warto zobaczyć i przeżyć<br> ☀️ <b>Pogoda w miejscu docelowym + galeria zdjęć</b><br> ✨ <b>i wiele więcej…</b><br>  <br><hr> Jak wygląda <b>pełny dostęp</b> demo? Kliknij odblokowane menu w dolnym menu.<br> <br> Nie przegap tej okazji, <b>ekskluzywne oferty</b> czekają na Ciebie <b>każdego dnia!</b><br> <br> Odblokuj dostęp <b>szybko i łatwo</b> za pośrednictwem Apple Pay:",
        
      "infopage":            "Dziękujemy, że jesteś częścią społeczności <b>Podróżujemy tanio PREMIUM!</b><br> <br> Jako nasz członek PREMIUM masz dostęp do <b>wszystkich ekskluzywnych ofert</b> i przydatnych informacji, które pomogą Ci zaoszczędzić setki euro na wakacjach bez biletu.<br> <br> Co daje członkostwo PREMIUM:<br> <br> ✈️ <b>Codziennie nowe oferty</b> w ekskluzywnych cenach<br> 🌍 <b>Tanie loty i noclegi</b> w popularnych kierunkach<br> 🗺️ <b>Praktyczne wskazówki i rekomendacje</b> z pierwszej ręki<br> 📱 <b>Kompletne informacje</b> przejrzyście w jednym miejscu<br> 🔔 <b>Natychmiastowe powiadomienia</b> o nowych ofertach<br> 💸 <b>Do 70% oszczędności</b> w porównaniu do normalnych cen biletów<br> <br> <br> ⭐ <b>Zadowolenie naszych członków</b> jest dla nas priorytetem! Jeśli korzystasz z dobrodziejstw naszej aplikacji i dzięki niej zaoszczędziłeś pieniądze na podróżach, będzie nam bardzo miło, jeśli zobaczysz recenzję w App Store lub Google Play.<br> <br> <b>Dziękujemy</b> za zaufanie i życzymy wspaniałych wrażeń z podróży!",
      
      "button_predplatit_detail":      "Zapisz się i uzyskaj dostęp już teraz!"
  
   }''');

  /* EN */
  var strings_en = json.decode('''{

      "ukazka_leteniek_z":      "Preview of flight tickets from", 
      "ukazka_ubytovania_z":    "Preview of accommodation from", 

      "flight_duration":      "hrs", 
      "ukazkovy_itinerar":      "Sample itinerary", 

      "appbar_title":           "We travel cheaply", 
      "appbar_title2":          "Budget vacation offers",

       "button_predplatit":      "Subscribe",
       "nahlasit_chybu":         "Report a bug",

      "settings_aplikacia":     "App settings",
      "settings_notifikacie":   "Notifications",
      "settings_zapnute":       "Enabled",
      "settings_vypnute":       "Disabled",
      "settings_vyberregionu":  "Region selection",
      "settings_oaplikaci":     "How does the app work?",
      "settings_informacie":    "Information",
      "settings_ochranaos":     "Privacy Policy",
      "settings_gdpr":          "Terms of Use",


      "payment_small_text":             "You can purchase a subscription by clicking on the buttons below. You can choose between a monthly subscription (9,99€/month) and a semi-annual subscription (47,99€/semi-annually - converted to 7,99€/month). Subscriptions renew automatically and can be cancelled at any time in the App Store settings.",


      "payment_sub_thanks":             "Thank you for being part of the <b>We travel cheaply PREMIUM</b> community!",
      "payment_sub_text1":              "You have <b>full access</b> to all our exclusive offers! What our PREMIUM membership brings you:<br> <br> ✈️ <b>New offers every day</b> at exclusive prices<br> 🌍 <b>Cheap flights and accommodation</b> in popular destinations<br> 🗺️ <b>Practical tips</b> and first-hand recommendations<br> 📱 <b>Complete information</b> clearly in one place<br> 🔔 <b>Instant notifications</b> of new offers<br> 💸 <b>Up to 70% savings</b> compared to regular flight prices <br><br>You can <b>manage your subscription</b> directly in the App Store settings by clicking the button below:",
       "payment_sub_stepredplatitelom":  "You are subscribed!",
      "payment_sub_obnovisa":           "Renews",
      "payment_sub_expiruje":           "Subscribed until",
      "payment_sub_spravovat":          "Manage subscription",
     
      "payment_no_title":             "Get full access to the PREMIUM version!",
      "payment_no_text1":             "🔓 <b>Unlock all our offers</b> and take advantage of <b>exclusive prices</b> you won't find anywhere else. All with <b>just a few clicks</b> on your mobile!<br> <hr> <br> ✈️ <b>New offers every day</b> at exclusive prices<br> 🌍 <b>Cheap flights and accommodation</b> in popular destinations<br> 📱 <b>Complete information</b> clearly in one place<br> 🔔 <b>Instant notifications</b> of new offers<br> 👍 <b>Verified</b> by thousands of satisfied users<br> 🔍 <b>Many years of experience</b> with cheap flights<br> 💸 <b>No hidden fees</b> - you can cancel your subscription at any time<br> 💳 <b>Fast and secure payment</b> via Apple Pay/Google Pay <hr>",
      "payment_no_restore":           "Restore previous purchases",    
      
      "payment_product1_title":       "Monthly Subscription",
      "payment_product1_desc":        "(50% off from 19,99€)",
      "payment_product2_title":       "Half-year Subscription",
      "payment_product2_desc":        "(60% off from 119,99€)",
      "payment_zlavovykod":           "Discount code",


      "nointernet_oops":                "Ooops!",
      "nointernet_skontrolujte":        "Check your internet connection",
      "nointernet_bezpripojenia":       "No internet connection",

      "vypis_lenza":            "Only for",
      "vypis_pridane":          "Added",
      "vypis_usertriteat":      "Save up to",
      "vypis_osoba":             "person",

      "jazyk_title2":             "Confirm the correct selection of the region",
      "jazyk_potvrdit":           "Confirm",

      "slidy_preskocit":          "Skip",
      "slidy_dalej":              "Next",
      "slidy_zobrazitponuky":     "Show offers",

     
     "slidy_nadpis1":             "Exclusive deals on cheap flights and accommodation every day directly on your smartphone!",      
      "slidy_nadpis1_2":           "Welcome to the We travel cheaply app! With us you will save hundreds of euros on a vacation without a travel agency!",      
      "slidy_nadpis1_3":           "Sample offer:",      
      "slidy_nadpis2":             "Complete information clearly in one place",      
      "slidy_nadpis3":             "Instant notifications for new offers",      
      "slidy_nadpis4":             "Application verified by users",      
      "slidy_nadpis5":             "Get full access now!",      
     
      "slidy_text1":              "<p>❌ Regular price: <s>100€</s><br> ✅ Our price: <b>20€</b><br><br> 💸 You will save on average <b>up to 70%!</b></p>  <p>🇮🇹 Cheap trip to Rome:<br> ✈️ Return flights for <b>20€</b><br> 🏨 Accommodation for 3 days for <b>68€</b><br> ✈️+🏨 Flights + accommodation for 3 days <b>for only 88€!</b><br><br> 💸 All prices are <b>final!</b></p>",
      "slidy_text2":              "No one else will provide you with so much <b>quality and verified information</b> about each offer:<br> <br>  ✈️ <b>Cheap flights</b> - directly with a link to the reservation<br> 🏨 <b>Affordable and verified accommodation</b> - with a link to the reservation<br> 💸 <b>No hidden fees</b> – lyou book flights and accommodation directly at the lowest prices, you don't pay anything extra with us<br> 📅 <b>Multiple dates for the same price</b> - just click and book<br> 🧳 <b>Luggage information</b> - exact dimensions and weight of allowed luggage<br> 🚌 <b>Airport transportation</b> - detailed instructions on how to get to the center<br> 📝 <b>Practical tips</b> - first-hand recommendations<br> 🗺️ <b>Sample itinerary</b> - suggestions for what is worth seeing and experiencing<br> ☀️ <b>Weather in the destination + photo gallery</b><br> ✨ <b> and much more…</b> <br><br>You don't have to spend hours searching for flights and accommodation, you can find everything right away in the app <b>with just a few clicks!</b>",
      "slidy_text3":              "🔔 <b>Turn on notifications</b> and you won't miss any new offers!<br> <br> You will be <b>the first to know</b> about all the great deals and you can travel at the <b>lowest prices!</b>",
      "slidy_text4":              "Our app has helped <b>thousands of travelers</b> save hundreds of euros - join our satisfied members!<br> <br> We have been bringing you exclusive offers <b>every day for 8 years</b> - with proven tips and no hidden fees!<br> <br> <p><b> 🔍 8+ years of experience<br> 👍 Thousands of satisfied users </p>  ⭐ What our users said about us:<br>",
      "slidy_text4_app":          "2nd most downloaded app in the travel category",
      "slidy_text5":              "<b>Unlock full access</b> to all our offers with a subscription starting from <b>€7.99 per month!</b> <br> <br> Pay  <b>quickly and easily</b> via Apple Pay <br> <br> <b>Exclusive offers</b> await you every day<br> <br> With us you will save <b>hundreds of euros</b> on a vacation <b>without a travel agency!</b>",
    
      "review_1_name" : "Sofia T.",
      "review_1_text" : "An app with great deals for travelers. I definitely recommend it, very clearly organized and great approach.",
      "review_2_name" : "Silvia L.",
      "review_2_text" : "Perfect app, incredibly good tips and advice for traveling, I use it regularly and am very satisfied and inspired.",
      "review_3_name" : "Erik K.",
      "review_3_text" : "Lots of great deals, clear, willing to help, definitely worth it.",
      "review_4_name" : "Silvia K.",
      "review_4_text" : "Great satisfaction. Lots of good recommendations, advice, experience and answers to every question. I definitely recommend it. Many thanks.",

      "slidy_text1_button":       "See the latest offers",
      "slidy_text2_button":       "Get access to verified information now!",
      "slidy_text3_button":       "Turn on notifications",
      "slidy_text4_button":       "Become a member now and start saving!",
      "slidy_text5_button":       "Get access from just €7.99!",





      "detail_termin":                  "Date",
      "detail_letenkykupitetu":         "Buy flights here",
      "detail_trvanieletu":             "Flight duration",
      "detail_tipnaubytovanie":         "Accommodation tip",
      "detail_ubytovaniekupitetu":      "Buy accommodation here",
      "detail_dalsieterminy":           "Other dates",
      "detail_zobrvsetkyterminy":       "Show all dates",
      "detail_vsetkyaktterminy":        "All current dates",
      "detail_blizsieinfo":              "More information",
      "detail_tipyprecest":              "Practical tips for travelers",
      "detail_pocasiepocaspobytu":       "Weather at the destination during the stay",
      "detail_datazminroka":             "(The data is from last year)",
      "detail_viacodest":                "More about the destination",
      "detail_zobrcelypopis":            "Show full description",


      "infodetailnopaymenttext":         "<p>🔒To view all information, subscribe to the <b>PREMIUM version</b> and unlock <b>access to all offers:</b></p> <hr> <p>Each offer contains <b>high-quality and verified information:</b></p>✈️ <b>Cheap flights</b> - directly with a link to the reservation<br> 🏨 <b>Affordable and verified accommodation</b> - with a link to the reservation<br> 💸 <b>No hidden fees</b> – you book flights and accommodation directly at the lowest prices, you don't pay anything extra with us<br> 📅 <b>Multiple dates for the same price</b> - just click and book<br> 🧳 <b>Luggage information</b> - exact dimensions and weight of allowed luggage<br> 🚌 <b>Airport transportation</b> - detailed instructions on how to get to the center<br> 📝 <b>Practical tips</b> - first-hand recommendations<br> 🗺️ <b>Sample itinerary</b> - suggestions for what is worth seeing and experiencing<br> ☀️ <b>Weather in the destination + photo gallery</b><br> ✨ <b>and much more…</b><br>  <br><hr> What does <b>full access</b> to the preview look like? Click on the unlocked offers in the menu below.<br> <br> Don't miss this opportunity, <b>exclusive offers</b> await you every day!<br> <br> Unlock your access <b>quickly and easily</b> via Apple Pay:",
        
      "infopage":            "Thank you for being part of the <b>We travel cheaply PREMIUM</b> community!<br> <br> As our PREMIUM member you have access to <b>all exclusive offers</b> and useful information that will help you save hundreds of euros on your vacation without a travel package.<br> <br> What our PREMIUM membership brings you:<br> <br> ✈️ <b>New offers every day</b> at exclusive prices<br> 🌍 <b>Cheap flights and accommodation</b> in popular destinations<br> 🗺️ <b>Practical tips</b> and first-hand recommendations<br> 📱 <b>Complete information</b> clearly in one place<br> 🔔 <b>Instant notifications</b> of new offers<br> 💸 <b>Up to 70% savings</b> compared to regular flight prices<br> <br> <br> ⭐ <b>Our members' satisfaction</b> is our priority! If you are enjoying the benefits of our app and it has helped you save money on your travels, we would be very happy if you leave a review on the App Store or Google Play.<br> <br> <b>Thank you</b> for your trust and we wish you great experiences on your travels!",
      
      "button_predplatit_detail":      "Subscribe and get access immediately!"
 
   }''');

  /* AT */
  var strings_at = json.decode('''{

      "ukazka_leteniek_z":      "Vorschau auf Flugtickets ab", 
      "ukazka_ubytovania_z":    "Vorschau auf Unterkünfte ab", 

      "flight_duration":      "Std.", 
      "ukazkovy_itinerar":      "Beispielhafter Reiseplan", 


      "appbar_title":           "Wir reisen günstig", 
      "appbar_title2":          "Günstige Urlaubsangebote",

       "button_predplatit":      "Abonnieren",
       "nahlasit_chybu":         "Fehler melden",

      "settings_aplikacia":     "App-Einstellungen",
      "settings_notifikacie":   "Benachrichtigungen",
      "settings_zapnute":       "Aktiviert",
      "settings_vypnute":       "Deaktiviert",
      "settings_vyberregionu":  "Auswahl der Region",
      "settings_oaplikaci":     "Wie funktioniert die App?",
      "settings_informacie":    "Informationen",
      "settings_ochranaos":     "Datenschutzrichtlinien",
      "settings_gdpr":          "Nutzungsbedingungen",


      "payment_small_text":             "Sie können ein Abonnement erwerben, indem Sie auf die Schaltflächen unten klicken. Sie können zwischen einem monatlichen Abonnement (9,99€/Monat) und einem halbjährlichen Abonnement (47,99€/halbjährlich - umgerechnet 7,99€/Monat) wählen. Die Abonnements verlängern sich automatisch und können jederzeit in den Einstellungen von App Store gekündigt werden.",


      "payment_sub_thanks":             "Vielen Dank, dass Sie Teil der <b>Wir reisen günstig PREMIUM</b> Community sind!",
      "payment_sub_text1":              "Sie haben <b>vollen Zugriff</b> auf alle unsere exklusiven Angebote! Was Ihnen unsere PREMIUM-Mitgliedschaft bringt:<br> <br> ✈️ <b>Jeden Tag neue Angebote</b> zu exklusiven Preisen<br> 🌍 <b>Günstige Flüge und Unterkünfte</b> in beliebten Reisezielen<br> 🗺️ <b>Praktische Tipps</b> und Empfehlungen aus erster Hand<br> 📱 <b>Vollständige Informationen</b> übersichtlich an einem Ort<br> 🔔 <b>Sofortige Benachrichtigungen</b> über neue Angebote<br> 💸 <b>Bis zu 70 % Ersparnis</b> gegenüber regulären Ticketpreisen<br><br>Sie können Ihr Abonnement direkt in den Google Play/App Store Einstellungen verwalten, indem Sie auf die Schaltfläche unten klicken:",
       "payment_sub_stepredplatitelom":  "Sie sind ein Abonnent!",
      "payment_sub_obnovisa":           "Verlängert",
      "payment_sub_expiruje":           "Abonniert bis",
      "payment_sub_spravovat":          "Verwalten von Abonnements",
     
      "payment_no_title":             "Erhalten Sie vollen Zugriff auf die PREMIUM-Version!",
      "payment_no_text1":             "🔓 <b>Schalten Sie</b> alle unsere Angebote frei und profitieren Sie von <b>exklusiven Preisen</b>, die Sie sonst nirgendwo finden. Alles mit nur <b>wenigen Klicks</b> auf Ihrem Handy!<br> <hr> <br> ✈️ <b>Jeden Tag neue Angebote</b> zu exklusiven Preisen<br> 🌍 <b>Günstige Flüge und Unterkünfte</b> in beliebten Reisezielen<br> 📱 <b>Vollständige Informationen</b> übersichtlich an einem Ort<br> 🔔 <b>Sofortige Benachrichtigungen</b> über neue Angebote<br> 👍 <b>Von Tausenden zufriedenen</b> Benutzern bestätigt<br> 🔍 <b>Langjährige Erfahrung</b> mit günstigen Tickets<br> 💸 <b>Keine versteckten Gebühren</b> - Sie können Ihr Abonnement jederzeit kündigen<br> 💳 <b>Schnelle und sichere Zahlung</b> über Apple Pay/Google Pay <hr>",
      "payment_no_restore":           "Frühere Einkäufe wiederherstellen",    
      
      "payment_product1_title":       "Monatsabonnement",
      "payment_product1_desc":        "(50% Rabatt von 19,99€)",
      "payment_product2_title":       "Halbjahresabonnement",
      "payment_product2_desc":        "(60% Rabatt von 119,99€)",
      "payment_zlavovykod":           "Rabattcode",


      "nointernet_oops":                "Hoppla!",
      "nointernet_skontrolujte":        "Überprüfen Sie Ihre Internetverbindung",
      "nointernet_bezpripojenia":       "Keine Internetverbindung",

      "vypis_lenza":            "Nur für",
      "vypis_pridane":          "Hinzugefügt",
      "vypis_usertriteat":      "Sparen Sie bis zu",
      "vypis_osoba":             "Person",

      "jazyk_title2":             "Bestätigen Sie die richtige Auswahl der Region",
      "jazyk_potvrdit":           "Bestätigen",

      "slidy_preskocit":          "Überspringen",
      "slidy_dalej":              "Weiter",
      "slidy_zobrazitponuky":     "Angebote anzeigen",

    
    

    
      "slidy_nadpis1":             "Exklusive Angebote für günstige Flüge und Unterkünfte jeden Tag direkt auf Ihrem Handy!",      
      "slidy_nadpis1_2":           "Willkommen in der App Wir reisen günstig! Mit uns sparen Sie im Urlaub ohne Reisebüro Hunderte Euro!",      
      "slidy_nadpis1_3":           "Beispielangebot:",      
      "slidy_nadpis2":             "Vollständige Informationen übersichtlich an einem Ort",      
      "slidy_nadpis3":             "Sofortige Benachrichtigungen über neue Angebote",      
      "slidy_nadpis4":             "Von Benutzern überprüfte App",      
      "slidy_nadpis5":             "Erhalten Sie jetzt vollen Zugriff!",      
     
      "slidy_text1":              "<p>❌ Regulärer Preis: <s>100€</s><br> ✅ Unser Preis: <b>20€</b><br><br> 💸 Sie sparen im Schnitt <b>bis zu 70%!</b></p>  <p>🇮🇹 Günstige Reise nach Rom:<br> ✈️ Flugtickets hin und zurück für <b>20€</b><br> 🏨 Unterkunft für 3 Tage für <b>68€</b><br> ✈️+🏨 Flüge + Unterkunft für 3 Tage <b>für nur 88€!</b><br><br> 💸 Alle Preise sind <b>Endpreise!</b></p>",
      "slidy_text2":              "Niemand sonst bietet Ihnen so viele <b>hochwertige und geprüfte Informationen</b> zu jedem Angebot:<br> <br>  ✈️ <b>Günstige Flüge</b> - direkt mit Link zur Reservierung<br> 🏨 <b>Erschwingliche und geprüfte Unterkunft</b> - mit Link zur Reservierung<br> 💸 <b>Keine versteckten Gebühren</b> – Sie buchen Flüge und Unterkünfte direkt zu den niedrigsten Preisen, Sie zahlen bei uns nichts extra<br> 📅 <b>Mehrere Termine zum gleichen Preis</b> - einfach anklicken und buchen<br> 🧳 <b>Informationen zum Gepäck</b> - genaue Maße und Gewicht des erlaubten Gepäcks<br> 🚌 <b>Transport vom Flughafen</b> - detaillierte Anweisungen zur Anreise ins Zentrum<br> 📝 <b>Praxistipps </b> - Empfehlungen aus erster Hand<br> 🗺️ <b>Beispiel-Reiseverlauf</b> - Vorschläge, was es wert ist, gesehen und erlebt zu werden<br> ☀️ <b>Wetter am Reiseziel + Fotogalerie</b><br> ✨ <b>und noch viel mehr…</b><br><br>Sie müssen nicht stundenlang nach Flügen und Unterkünften suchen, sondern können <b>mit wenigen Klicks</b> alles sofort in der Anwendung finden!",
      "slidy_text3":              "🔔 <b>Aktivieren Sie Benachrichtigungen</b> und Sie verpassen kein neues Angebot!<br> <br> Sie erfahren <b>als Erster</b> von allen Sonderangeboten und können so zu den <b>günstigsten Preisen reisen!</b>",
      "slidy_text4":              "Unsere App hat <b>Tausenden von Reisenden</b> geholfen, Hunderte von Euro zu sparen – schließen Sie sich unseren zufriedenen Mitgliedern an!<br> <br> <b>Seit 8 Jahren</b> bringen wir Ihnen <b>täglich</b> exklusive Angebote – mit geprüften Tipps und ohne versteckte Gebühren!<br> <br> <p><b> 🔍 8+ Jahre Erfahrung<br> 👍 Tausende zufriedene Benutzer </p>  ⭐ Was unsere Benutzer über uns gesagt haben:<br>",
      "slidy_text4_app":          "Zweitbeste App in der Kategorie „Reisen“.",
      "slidy_text5":              "<b>Sichern Sie sich vollen Zugriff</b> auf alle unsere Angebote mit einem Abonnement ab <b>7,99€ pro Monat!</b> <br> <br> <b>Schnelle und einfache Zahlung</b> per Apple Pay <br> <br> Täglich erwarten Sie <b>exklusive Angebote</b><br> <br> Mit uns sparen Sie im Urlaub <b>ohne Reisebüro</b> Hunderte Euro!",
    
      "review_1_name" : "Sofia T.",
      "review_1_text" : "App mit tollen Angeboten für Reisende. Ich kann es auf jeden Fall empfehlen, sehr übersichtlich und ein toller Ansatz.",
      "review_2_name" : "Silvia L.",
      "review_2_text" : "Perfekte Anwendung, unglaublich gute Reisetipps und Ratschläge, ich nutze es regelmäßig und bin sehr zufrieden und inspiriert.",
      "review_3_name" : "Erik K.",
      "review_3_text" : "Viele Schnäppchen, übersichtlich, hilfsbereit, es lohnt sich auf jeden Fall.",
      "review_4_name" : "Silvia K.",
      "review_4_text" : "Große Zufriedenheit. Viele gute Empfehlungen, Ratschläge, Erfahrungen und Antworten auf jede einzelne Frage. Ich kann es auf jeden Fall empfehlen. Vielen Dank.",

      "slidy_text1_button":       "Sehen Sie sich die neuesten Angebote an",
      "slidy_text2_button":       "Erhalten Sie jetzt Zugang zu verifizierten Informationen!",
      "slidy_text3_button":       "Aktivieren Sie Benachrichtigungen",
      "slidy_text4_button":       "Jetzt Mitglied werden und mit dem Sparen beginnen!",
      "slidy_text5_button":       "Erhalten Sie Zugang ab 7,99€!",





      "detail_termin":                  "Termin",
      "detail_letenkykupitetu":         "Flugtickets hier kaufen",
      "detail_trvanieletu":             "Flugdauer",
      "detail_tipnaubytovanie":         "Tipp für Unterkunft",
      "detail_ubytovaniekupitetu":      "Unterkunft hier kaufen",
      "detail_dalsieterminy":           "Weitere Termine",
      "detail_zobrvsetkyterminy":       "Alle Termine anzeigen",
      "detail_vsetkyaktterminy":        "Alle aktuellen Termine",
      "detail_blizsieinfo":              "Nähere Informationen",
      "detail_tipyprecest":              "Praktische Tipps für Reisende",
      "detail_pocasiepocaspobytu":       "Wetter am Zielort während des Aufenthalts",
      "detail_datazminroka":             "(Diese Daten sind aus dem letzten Jahr)",
      "detail_viacodest":                "Mehr über die Destination",
      "detail_zobrcelypopis":            "Vollständige Beschreibung anzeigen",


       "infodetailnopaymenttext":         "<p>🔒Um alle Informationen anzuzeigen, abonnieren Sie die <b>PREMIUM-Version</b> und schalten Sie den <b>Zugriff auf alle Angebote</b> frei: </p> <hr> <p>Jedes Angebot enthält <b>hochwertige und geprüfte Informationen:</b></p>✈️ <b>Günstige Flüge</b> - direkt mit Link zur Reservierung<br> 🏨 <b>Erschwingliche und geprüfte Unterkunft</b> - mit Link zur Reservierung<br> 💸 <b>Keine versteckten Gebühren</b> – Sie buchen Flüge und Unterkünfte direkt zu den niedrigsten Preisen, Sie zahlen bei uns nichts extra<br> 📅 <b>Mehrere Termine zum gleichen Preis</b> - einfach anklicken und buchen<br> 🧳 <b>Informationen zum Gepäck</b> - genaue Maße und Gewicht des erlaubten Gepäcks<br> 🚌 <b>Transport vom Flughafen</b> - detaillierte Anweisungen zur Anreise ins Zentrum<br> 📝 <b>Praxistipps</b> - Empfehlungen aus erster Hand<br> 🗺️ <b>Beispiel-Reiseverlauf</b> - Vorschläge, was es wert ist, gesehen und erlebt zu werden<br> ☀️ <b>Wetter am Reiseziel + Fotogalerie</b><br> ✨ <b>und noch viel mehr…</b><br>  <br><hr> Wie sieht der <b>vollständige Demozugang</b> aus? Klicken Sie im unteren Menü auf die entsperrten Menüs.<br> <br> Lassen Sie sich diese Gelegenheit nicht entgehen, es warten täglich <b>exklusive Angebote</b> auf Sie!<br> <br> Den Zugang <b>über Apple Pay freischalten:",
        
      "infopage":            "Vielen Dank, dass Sie Teil der <b>Wir reisen günstig PREMIUM</b> Community sind!<br> <br> Als unser PREMIUM-Mitglied haben Sie Zugriff auf <b>alle exklusiven Angebote</b> und nützlichen Informationen, mit denen Sie im Urlaub ohne Fahrschein Hunderte Euro sparen können.<br> <br> Was Ihnen unsere PREMIUM-Mitgliedschaft bringt:<br> <br> ✈️ <b>Jeden Tag neue Angebote</b> zu exklusiven Preisen<br> 🌍 <b>Günstige Flüge und Unterkünfte</b> in beliebten Reisezielen<br> 🗺️ <b>Praktische Tipps</b> und Empfehlungen aus erster Hand<br> 📱 <b>Vollständige Informationen</b> übersichtlich an einem Ort<br> 🔔 <b>Sofortige Benachrichtigungen</b> über neue Angebote<br> 💸 <b>Bis zu 70 % Ersparnis</b> gegenüber regulären Ticketpreisen<br> <br> <br> ⭐ <b>Die Zufriedenheit unserer Mitglieder</b> liegt uns am Herzen! Wenn Sie die Vorteile unserer Anwendung nutzen und dadurch Reisekosten sparen konnten, würden wir uns sehr über eine Bewertung im App Store oder bei App Store freuen.<br> <br> <b>Wir danken Ihnen</b> für Ihr Vertrauen und wünschen Ihnen tolle Erlebnisse auf Ihren Reisen!",
      
      "button_predplatit_detail":      "Jetzt abonnieren und Zugang erhalten!"
 
 
  }''');

  returnString(String lang, String type) {
    //print(selectedValue);
    if (lang == "sk") {
      return strings_sk[type];
    }
    if (lang == "cz") {
      return strings_cz[type];
    }
    if (lang == "hu") {
      return strings_hu[type];
    }
    if (lang == "pl") {
      return strings_pl[type];
    }
    if (lang == "en") {
      return strings_en[type];
    }
    if (lang == "at") {
      return strings_at[type];
    }
  }
}
/**
 * use:
 * lang().returnLanguage("header_title");
 */
