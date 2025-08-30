import 'dart:async';

import 'package:get/get.dart';

class ReclamationController extends GetxController with StateMixin<List> {
  //
  Future<void> checkTicket(String partenaire) async {
    change([], status: RxStatus.loading());
    Timer(const Duration(seconds: 2), () {
      List services = [];
      if (partenaire == "Vodacom") {
        services = [
          {
            "service": "M-pesa",
            "logo": "assets/M-pesa-logo.png",
            "details": "Achat forfait, crédit et Transfère",
            "points": 20,
          },
          {
            "service": "Fitness",
            "logo": "assets/fitness.png",
            "details": "Bien etre",
            "points": 10,
          },
          {
            "service": "Health",
            "logo": "assets/health.jpg",
            "details": "Service de santé",
            "points": 10,
          },
          {
            "service": "Modem",
            "logo": "assets/modem.png",
            "details": "En vente en promotion",
            "points": 100,
          },
          {
            "service": "iPhone 15",
            "logo": "assets/iPhone-15.png",
            "details": "En vente en promotion",
            "points": 200,
          },
        ];
      } else if (partenaire == "Airtel") {
        services = [
          {
            "service": "Airtel Money",
            "logo": "assets/airtelmoney.png",
            "details": "Paiement factures, transfert et achat crédits",
            "points": 20,
          },
          {
            "service": "Streaming Pack",
            "logo": "assets/airtelstream.jpeg",
            "details": "Forfaits vidéo YouTube & Netflix",
            "points": 15,
          },
          {
            "service": "Smartphone Android",
            "logo": "assets/androidphone.jpg",
            "details": "En promotion via Airtel Shop",
            "points": 80,
          },
          {
            "service": "Recharge Bonus",
            "logo": "assets/airtelmoney.png",
            "details": "Recharge spéciale avec bonus internet",
            "points": 10,
          },
          {
            "service": "Box Wi-Fi",
            "logo": "assets/modem.png",
            "details": "Offre Box 4G LTE",
            "points": 100,
          },
        ];
      } else if (partenaire == "Orange") {
        services = [
          {
            "service": "Orange Money",
            "logo": "assets/orangemoney.jpeg",
            "details": "Paiement services et transferts",
            "points": 20,
          },
          {
            "service": "Forfait Night",
            "logo": "assets/orangemoney.jpeg",
            "details": "Internet illimité la nuit",
            "points": 15,
          },
          {
            "service": "Modem Orange Flybox",
            "logo": "assets/modem.png",
            "details": "Connexion haut débit",
            "points": 100,
          },
          {
            "service": "Orange Bank",
            "logo": "assets/orangemoney.jpeg",
            "details": "Service bancaire mobile (bientôt)",
            "points": 25,
          },
          {
            "service": "iPhone SE",
            "logo": "assets/iPhone-15.png",
            "details": "Promo limitée",
            "points": 180,
          },
        ];
      } else if (partenaire == "Africell") {
        services = [
          {
            "service": "Afrimoney",
            "logo": "assets/afrimoney.png",
            "details": "Transfert, paiements, et achat forfait",
            "points": 20,
          },
          {
            "service": "Forfait Illimité",
            "logo": "assets/illimite.png",
            "details": "Appels & data illimités journaliers",
            "points": 12,
          },
          {
            "service": "Smart TV",
            "logo": "assets/smart_tv.png",
            "details": "Disponible en boutique Africell",
            "points": 150,
          },
          {
            "service": "Recharge Bonus",
            "logo": "assets/bonus_africell.png",
            "details": "Recharge avec bonus voix + data",
            "points": 10,
          },
          {
            "service": "Ecouteurs Bluetooth",
            "logo": "assets/earbuds.png",
            "details": "Cadeau avec certaines recharges",
            "points": 50,
          },
        ];
      } else if (partenaire == "Dream Cosmetics") {
        services = [
          {
            "service": "Crème BelleVie",
            "logo": "assets/bellevue.png",
            "details": "Soin du visage & éclaircissement",
            "points": 30,
          },
          {
            "service": "Savon Makari",
            "logo": "assets/exclusive-exmakari.png",
            "details": "Éclaircissant naturel",
            "points": 20,
          },
          {
            "service": "Sérum Fair & White",
            "logo": "assets/lotion.png",
            "details": "Anti-taches, peau uniforme",
            "points": 35,
          },
          {
            "service": "Parfum local",
            "logo": "assets/parfum.png",
            "details": "Parfum artisanal RDC",
            "points": 15,
          },
        ];
      } else if (partenaire == "Pains Victoire") {
        services = [];
      } else if (partenaire == "Prince Pharma") {
        services = [
          {
            "service": "Paracétamol 500mg",
            "logo": "assets/paracetamol.jpg",
            "details": "Disponible chez Pharmacie Lelo",
            "points": 5,
          },
          {
            "service": "Test rapide malaria",
            "logo": "assets/testrapide.jpg",
            "details": "Service LabCheck à domicile",
            "points": 25,
          },
          {
            "service": "Kit premiers soins",
            "logo": "assets/premiersoin.jpg",
            "details": "En promo chez AfriPharma",
            "points": 40,
          },
          {
            "service": "Vitamine C 1000mg",
            "logo": "assets/vitamine-c.jpg",
            "details": "Système immunitaire renforcé",
            "points": 10,
          },
        ];
      } else {
        services = [];
      }
      change(services, status: RxStatus.success());
    });
  }

  //
  Future<void> videTicket() async {
    change([], status: RxStatus.empty());
  }
}
