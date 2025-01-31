import 'dart:async' show Future;
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/*
import '../include/URL.dart';

Future<List<ReceptyVypis>> fetchAlbum(http.Client client, int page) async {
  final response = await client.get(Uri.parse(url_ponuky + "?page=" + page.toString()));

  inspect(jsonDecode(response.body));
  return compute(parseVypis, response.body);
}
*/
// A function that converts a response body into a List<ReceptyVypis>.
List<ReceptyVypis> parseVypis(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ReceptyVypis>((json) => ReceptyVypis.fromJson(json)).toList();
}

class ReceptyVypis {
  String nid,
      imageUrl,
      krajina,
      pridane,
      odletMonth,
      nazov_destinacie,
      obojsmerny_let,
      letenkyPHP,
      blizsie_info_php,
      letecka_spol_logo,
      fotka_lietadla,
      banner,
      galeria_destinacia,
      viac_o_destinaci,
      prakticke_tipy_pre_cestovatelov,
      vsetky_aktual_terminy_text,
      vsetky_aktual_terminy_nadpis_tlac,
      vsetky_aktual_terminy_odkaz,
      dalsie_terminy,
      galeria_ubytovanie,
      screen_ubytovania,
      tip_na_ubyt_nadpis_tlacidla,
      tip_na_ubyt_nazov,
      tip_na_ubytovanie,
      tip_na_ubyt_odkaz,
      cas_letu,
      textovy_popis_ponuky,
      letenky_len_za,
      title,
      kal_inych_letov_nazov,
      kal_inych_letov_nadpis_tlacidla,
      nazov_letiska_odletu,
      nazov_letiska_priletu,
      kal_inych_letov_Odkaz,
      text_usetrite_az,
      ubytovanie_len_za,
      usetrite_az,
      x_dnovy_pobyt,
      free,
      nazov_letiska_priletu_suradnice,
      nazov_letiska_odletu_suradnice,
      pocasiedata,
      datumdetail,
      kalendar_inych_letov_text,
      banner_preplik,
      banner_type,
      banner_text,
      banner_url,
      ukazkovy_itinerar;


  ReceptyVypis({
    required this.nid,
    required this.title,
    required this.imageUrl,
    required this.odletMonth,
    required this.krajina,
    required this.pridane,
    required this.nazov_destinacie,
    required this.obojsmerny_let,
    required this.letenkyPHP,
    required this.blizsie_info_php,
    required this.letecka_spol_logo,
    required this.banner,
    required this.fotka_lietadla,
    required this.viac_o_destinaci,
    required this.galeria_destinacia,
    required this.prakticke_tipy_pre_cestovatelov,
    required this.vsetky_aktual_terminy_odkaz,
    required this.vsetky_aktual_terminy_nadpis_tlac,
    required this.vsetky_aktual_terminy_text,
    required this.galeria_ubytovanie,
    required this.dalsie_terminy,
    required this.screen_ubytovania,
    required this.tip_na_ubytovanie,
    required this.tip_na_ubyt_odkaz,
    required this.tip_na_ubyt_nadpis_tlacidla,
    required this.tip_na_ubyt_nazov,
    required this.cas_letu,
    required this.textovy_popis_ponuky,
    required this.letenky_len_za,
    required this.nazov_letiska_odletu,
    required this.nazov_letiska_priletu,
    required this.text_usetrite_az,
    required this.ubytovanie_len_za,
    required this.usetrite_az,
    required this.x_dnovy_pobyt,
    required this.kalendar_inych_letov_text,
    required this.kal_inych_letov_Odkaz,
    required this.kal_inych_letov_nadpis_tlacidla,
    required this.kal_inych_letov_nazov,
    required this.free,
    required this.nazov_letiska_odletu_suradnice,
    required this.nazov_letiska_priletu_suradnice,
    required this.pocasiedata,
    required this.datumdetail,
    required this.ukazkovy_itinerar,
    required this.banner_preplik,
    required this.banner_type,
    required this.banner_text,
    required this.banner_url,
  });

  factory ReceptyVypis.fromJson(Map<String, dynamic> json) {
    return ReceptyVypis(
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
      nazov_letiska_odletu_suradnice: json['nazov_letiska_odletu_suradnice'] as String,
      nazov_letiska_priletu_suradnice: json['nazov_letiska_priletu_suradnice'] as String,
      pocasiedata: json['pocasiedata'] as String,
      datumdetail: json['datumdetail'] as String,
      ukazkovy_itinerar: json['ukazkovy_itinerar'] as String,
      banner_preplik: json['banner_preplik'] as String,
      banner_type: json['banner_type'] as String,
      banner_text: json['banner_text'] as String,
      banner_url: json['banner_url'] as String,
    );
  }
}

// favorites

// nacitat recepty z uložiska
loadData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('favoriteslistt') ?? '';
}

// ADD & REMOVE TO FAVORITES AND SAVE
Future<void> addRemoveToFavorites(String nid) async {
  List<String>? favoriteDataList = [];

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  favoriteDataList = prefs.getStringList('favoriteslistt');

  // add to list
  if (favoriteDataList != null) {
    if (!favoriteDataList!.contains(nid)) {
      favoriteDataList.add(nid);
    } else {
      favoriteDataList.remove(nid);
    }

    // add list to shared preferences
    await prefs.setStringList('favoriteslistt', favoriteDataList);
  } else {
    //firt time load
    List<String> favoriteDataList = [];
    favoriteDataList.add(nid);
    await prefs.setStringList('favoriteslistt', favoriteDataList);
  }
}
