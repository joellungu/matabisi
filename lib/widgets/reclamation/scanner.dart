import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:promata/pages/accueil.dart';
import 'package:promata/utils/requete.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:http/http.dart' as http;

class QRScannerPage extends StatefulWidget {
  Map? service;
  QRScannerPage(this.service, {Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedData;
  Requete requete = Requete();
  var box = GetStorage();

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner QR Code')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                scannedData ?? 'Scannez un QR code',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller?.toggleFlash();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            child: const Text("Activer/Désactiver Flash"),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera(); // Stop scan after first detection

      scannedData = scanData.code;
      Map client = box.read("client") ?? {};
      //
      print("Client: $client");
      //
      Map e = {
        "codeUnique": scannedData,
        "idEntreprise": "",
        "nomCategorie": widget.service!['nom'],
        "idClient": client['id'],
      };
      //
      getAllEntreprise(e);
      //
      setState(() {});
      // Tu peux ici naviguer, sauvegarder ou traiter la donnée scannée
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  //
  Future<void> getAllEntreprise(Map t) async {
    //
    List cours = [];
    //
    http.Response response = await requete.postE("api/transactions", t);
    //
    if (response.statusCode == 200 || response.statusCode == 201) {
      //
      print('Data rep succès: $t');
      print('Data rep succès: ${response.statusCode}');
      print('Data rep succès: ${response.body}');
      //
      //box.write("cours", response.body);
      //
      cours = jsonDecode(response.body);
      //

      //
      //return {"status": "Ok", "message": response.body};
      //
      // Get.snackbar(
      //   "Succès",
      //   "${response.body} ${widget.service!['points']}Pt",
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );
      Get.offAll(Accueil());
      //
    } else {
      print('Data rep Erreur: $t');
      print('Data rep Erreur: ${response.statusCode}');
      print('Data rep Erreur: ${response.body}');
      //
      // Get.snackbar(
      //   "Erreur",
      //   response.body,
      //   backgroundColor: Colors.red.shade700,
      //   colorText: Colors.white,
      // );
      //return {"status": "Err", "message": response.body};
    }

    //
    // List cs = box.read("entreprises") ?? [];
    // if (cours.isNotEmpty) {
    //   cs = cours;
    // }
    //
    //cs.addAll(cours);
    //
    // box.write('entreprises', cs);
    // return cs;
  }
}
