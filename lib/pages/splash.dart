import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'accueil.dart';
import 'connexion/connexion.dart';

class Splash extends StatelessWidget {
  //
  var box = GetStorage();
  //
  Splash() {
    //
    Timer(const Duration(seconds: 2), () {
      //Connexion
      Map client = box.read('client') ?? {};
      print("Client: $client");
      //
      if (client.isEmpty) {
        Get.offAll(Connexion());
      } else {
        Get.offAll(Accueil());
      }
      //Accueil
    });
  }
  @override
  Widget build(BuildContext context) {
    //
    return Scaffold();
  }

  //
}
