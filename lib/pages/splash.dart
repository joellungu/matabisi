import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:promata/utils/requete.dart';
import 'package:http/http.dart' as http;
import 'package:promata/utils/service_requete.dart';

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
    List l = await ServiceRequete.getAllEntreprise();
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
}
