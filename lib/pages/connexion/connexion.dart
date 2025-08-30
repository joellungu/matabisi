import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:promata/pages/accueil.dart';
import 'package:promata/pages/connexion/opt_page.dart';
import 'package:promata/utils/requete.dart';
import 'package:sms_autofill/sms_autofill.dart';

String? phoneNumber;
String? code;
String? nom;

class Connexion extends StatefulWidget {
  @override
  _Connexion createState() => _Connexion();
}

class _Connexion extends State<Connexion> {
  bool _isPhoneVerified = false;

  void _completePhoneVerification() {
    setState(() {
      _isPhoneVerified = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isPhoneVerified
        ? PageOtp(phoneNumber: phoneNumber, code: code, nom: nom)
        : PhoneVerificationScreen(onVerified: _completePhoneVerification);
  }
}

class PhoneVerificationScreen extends StatefulWidget {
  final VoidCallback onVerified;

  PhoneVerificationScreen({required this.onVerified});

  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  Requete requete = Requete();
  //
  bool _isLoading = false;

  void _verifyPhone() async {
    setState(() => _isLoading = true);
    //
    phoneNumber = "+243${_phoneController.text}";
    var i1 = math.Random().nextInt(10);
    var i2 = math.Random().nextInt(10);
    var i3 = math.Random().nextInt(10);
    var i4 = math.Random().nextInt(10);
    var i5 = math.Random().nextInt(10);
    var i6 = math.Random().nextInt(10);

    code = "$i1$i2$i3$i4$i5$i6";
    String signature = await SmsAutoFill().getAppSignature;
    print("Ma signature d'app : $signature");
    print("le code: $code");
    //
    // Simuler la vérification
    int i = await sendSMS(phoneNumber!, code!, signature);
    if (i == 1) {
      setState(() => _isLoading = false);
      widget.onVerified();
    } else {
      setState(() => _isLoading = false);
      Get.snackbar(
        "Erreur",
        "Un problème est survenu lors de l'authentification.",
      );
    }
    // Future.delayed(Duration(seconds: 1), () {

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Vérification du numéro'), elevation: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Text(
              'Entrez votre numéro de téléphone',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Nous enverrons un code de vérification à ce numéro',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            SizedBox(height: 40),

            // Champ téléphone
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('+243', style: TextStyle(fontSize: 16)),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '6 12 34 56 78',
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Bouton continuer
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _verifyPhone,
                child:
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                          'CONTINUER',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
            SizedBox(height: 20),

            Center(
              child: Text(
                'Des frais standards de SMS peuvent s\'appliquer',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<int> sendSMS(String phoneNumber, String code, String signature) async {
    http.Response response = await requete.postE("api/Client/login", {
      "telephone": phoneNumber,
      "code": code,
      "signature": signature,
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      //
      Map data = jsonDecode(response.body);
      nom = data['nomComplet'];
      //
      print("Succès: ${response.statusCode}");
      print("Succès: ${data['nomComplet']}");
      return 1;
    } else {
      //
      print("Succès: ${response.statusCode}");
      print("Succès: ${response.body}");
      return 2;
    }
  }
}

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 20),
            Text(
              'Inscription réussie!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Votre compte a été créé avec succès',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                // Naviguer vers l'écran principal
                Get.offAll(Accueil());
              },
              child: Text(
                'COMMENCER',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
