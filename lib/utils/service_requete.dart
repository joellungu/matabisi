import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:promata/utils/requete.dart';
import 'package:http/http.dart' as http;

class ServiceRequete {
  //

  //
  static Future<List> getAllEntreprise() async {
    //
    Requete requete = Requete();
    //
    var box = GetStorage();
    //
    List cours = [];
    //
    http.Response response = await requete.getE("api/Entreprise");
    //
    if (response.statusCode == 200 || response.statusCode == 201) {
      //
      print('Succès: ${response.statusCode}');
      print('Succès: ${response.body}');
      //
      //box.write("cours", response.body);
      //
      cours = jsonDecode(response.body);
    } else {
      print('Erreur: ${response.statusCode}');
      print('Erreur: ${response.body}');
    }

    //
    List cs = box.read("entreprises") ?? [];
    if (cours.isNotEmpty) {
      cs = cours;
    }
    //
    //cs.addAll(cours);
    //
    box.write('entreprises', cs);
    return cs;
  }
}
