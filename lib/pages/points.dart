import 'dart:convert';
import 'dart:ffi';

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
    //int compte = box.read("compte") ?? 0;
    //
    return FutureBuilder(
      future: getAllCours(telephone),
      builder: (c, t) {
        if (t.hasData) {
          //
          int userPoints = t.data as int;
          //int userPoints = cours['soldePoints'] ?? 0;
          //
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vos points cumullés',
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
  Future<int> getAllCours(String telephone) async {
    //
    int points = 0;
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
      points = jsonDecode(response.body);
    } else {
      print('Erreur: ${response.statusCode}');
      print('Erreur: ${response.body}');
    }

    //
    int cs = box.read("compte") ?? 0;
    if (points != null) {
      cs = points;
    }
    //
    //cs.addAll(cours);
    //
    box.write('compte', cs);
    return cs;
  }
}
