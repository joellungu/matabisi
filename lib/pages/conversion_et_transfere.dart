import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:promata/utils/requete.dart';
import 'package:http/http.dart' as http;

class PointsToMoneyPage extends StatefulWidget {
  Map entreprise;
  PointsToMoneyPage({super.key, required this.entreprise});

  @override
  State<PointsToMoneyPage> createState() => _PointsToMoneyPageState();
}

class _PointsToMoneyPageState extends State<PointsToMoneyPage> {
  int userPoints = 1250; // Exemple : points actuels de l'utilisateur
  final TextEditingController pointsCtrl = TextEditingController();

  double usdRate = 0.01; // 10 points = 0.1 USD → 1 point = 0.01 USD

  String? errorMessage;
  //
  var box = GetStorage();

  double calculateUSD(int points) {
    return points * usdRate;
  }

  void convertPoints() {
    final pointsToConvert = int.tryParse(pointsCtrl.text) ?? 0;
    if (pointsToConvert <= 0) {
      setState(
        () => errorMessage = "Veuillez saisir un nombre de points valide.",
      );
      return;
    }

    if (pointsToConvert > userPoints) {
      setState(
        () =>
            errorMessage =
                "Solde insuffisant. Vous n'avez que $userPoints points.",
      );
      return;
    }

    final amountUSD = calculateUSD(pointsToConvert);

    // TODO: Envoyer la demande de conversion au backend / Mobile Money
    debugPrint("Conversion réussie: $pointsToConvert points → $amountUSD USD");

    setState(() {
      userPoints -= pointsToConvert;
      errorMessage = null;
      pointsCtrl.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Conversion réussie : $amountUSD USD transféré via Mobile Money.",
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //
    Map user = box.read('client') ?? {};
    //
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              //backgroundImage: AssetImage(conversation.avatar, ),
              backgroundColor: Colors.white,
              radius: 25,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  // image: DecorationImage(
                  //   image: NetworkImage(
                  //     "${Requete.url}/api/Entreprise/logo/${conversation['id']}",
                  //   ),
                  //   fit: BoxFit.contain,
                  // ),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      "${Requete.url}/api/Entreprise/logo/${widget.entreprise['id']}?v=${DateTime.now().millisecondsSinceEpoch}",
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Text("${widget.entreprise['nom']}"),
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Carte du solde
            CreditCardWidget(
              cle: '${user['telephone']}${widget.entreprise['id']}',
            ),
            const SizedBox(height: 24),

            // Saisie des points
            TextField(
              controller: pointsCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: "Points à convertir",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                prefixIcon: const Icon(Icons.stars, color: Colors.blueAccent),
                errorText: errorMessage,
              ),
            ),
            const SizedBox(height: 16),

            // Affichage montant équivalent
            if (pointsCtrl.text.isNotEmpty)
              Builder(
                builder: (_) {
                  final points = int.tryParse(pointsCtrl.text) ?? 0;
                  return Text(
                    "Montant à recevoir : ${calculateUSD(points).toStringAsFixed(2)} USD",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),

            // Bouton convertir
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: convertPoints,
                icon: const Icon(Icons.monetization_on),
                label: const Text(
                  "Convertir et transférer",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreditCardWidget extends StatelessWidget {
  final String cle;

  const CreditCardWidget({super.key, required this.cle});

  Future<Map<String, dynamic>> fetchCredit(String cle) async {
    final response = await http.get(
      Uri.parse("${Requete.url}/api/Compte/points/$cle"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors du chargement du crédit");
    }
  }

  Widget _buildPointItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchCredit(cle),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Erreur: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData) {
          return const Center(child: Text("Aucune donnée"));
        }

        final data = snapshot.data!;
        final int points = data["points"] ?? 0.0;
        final double solde =
            (points * 0.01).toDouble(); // Exemple: 1$ = 100 pts

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [
          //       Theme.of(context).colorScheme.primary,
          //       Colors.blue.shade700,
          //     ],
          //   ),
          //   borderRadius: BorderRadius.circular(20),
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.blue.shade200,
          //       blurRadius: 20,
          //       offset: const Offset(0, 10),
          //     ),
          //   ],
          // ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const Text(
                    "Votre solde actuel",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$points points",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Équivalent : $solde USD",
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
