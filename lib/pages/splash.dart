import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:promata/utils/requete.dart';
import 'package:http/http.dart' as http;

import 'accueil.dart';
import 'connexion/connexion.dart';

class Splash extends StatelessWidget {
  //
  var box = GetStorage();
  Requete requete = Requete();
  //
  Splash() {
    //
    getall();
  }
  //
  getall() async {
    //
    List l = await getAllEntreprise();
    ();
    if (l.isEmpty || l.isNotEmpty) {
      Map client = box.read('client') ?? {};
      print("Client: $client");
      //
      if (client.isEmpty) {
        Get.offAll(Connexion());
      } else {
        Get.offAll(Accueil());
      }
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    return Scaffold();
  }

  //
  Future<List> getAllEntreprise() async {
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
