import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:promata/utils/requete.dart';
import 'package:http/http.dart' as http;

class Points extends StatelessWidget {
  //
  String telephone;
  Requete requete = Requete();
  //
  Points(this.telephone);
  //
  var box = GetStorage();
  //
  @override
  Widget build(BuildContext context) {
    //
    Map compte = box.read("compte") ?? {};
    //
    return FutureBuilder(
      future: getAllCours(telephone),
      builder: (c, t) {
        if (t.hasData) {
          //
          Map cours = t.data as Map;
          int userPoints = cours['soldePoints'];
          //
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vos points',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                userPoints.toString(),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          );
        } else if (t.hasError) {
          return Container(
            alignment: Alignment.center,
            height: 35,
            child: Text("Erreur: ${t.error}"),
          );
        }
        return SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  //
  Future<Map> getAllCours(String telephone) async {
    //
    Map cours = {};
    //
    http.Response response = await requete.getE("api/Compte/client/$telephone");
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
    Map cs = box.read("compte") ?? {};
    if (cours.isNotEmpty) {
      cs = cours;
    }
    //
    //cs.addAll(cours);
    //
    box.write('compte', cs);
    return cs;
  }
}
