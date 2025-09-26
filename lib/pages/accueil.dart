import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:promata/pages/conversion_et_transfere.dart';
import 'package:promata/pages/partenaires/partenaires.dart';
import 'package:promata/pages/points.dart';
import 'package:promata/pages/profile/profile.dart';
import 'package:promata/utils/requete.dart';
import 'package:promata/utils/service_requete.dart';
import 'package:promata/widgets/depenses/depenses.dart';
import 'Compte/Compte.dart';
import 'faq/faqs.dart';
import 'package:http/http.dart' as http;
import 'formulaire/formulaire.dart';
import 'historique/historique.dart';
import 'notifications/notification.dart';

class Accueil extends StatefulWidget {
  //

  //
  const Accueil({super.key});

  @override
  _Accueil createState() => _Accueil();
}

class _Accueil extends State<Accueil> {
  int userPoints = 1250;
  final PageController _promoController = PageController(viewportFraction: 0.8);
  int _currentPromoIndex = 0;
  //
  var box = GetStorage();
  //
  Map client = {};
  //
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  final List<Promotion> promotions = [
    Promotion(
      title: "Réduction Café",
      description: "Obtenez 20% sur votre prochain café",
      pointsCost: 100,
      imagePath: "assets/coffee-shop-1.png",
    ),
    Promotion(
      title: "Menu Gratuit",
      description: "Échangez 500 points pour un menu complet",
      pointsCost: 500,
      imagePath: "assets/restaurant-menu-.png",
    ),
    Promotion(
      title: "Bon d'achat",
      description: "10€ de réduction pour 1000 points",
      pointsCost: 1000,
      imagePath: "assets/coffee-shop-2.png",
    ),
  ];

  @override
  void initState() {
    //
    client = box.read("client") ?? {};
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    Map client = box.read('client') ?? {};
    //
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    // backgroundImage: AssetImage(
                    //   'assets/avatar.png',
                    // ), // Ton avatar ou logo
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${client['nom']}',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  Text(
                    '${client['telephone']}',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: SvgPicture.asset(
                "assets/HugeiconsProfile.svg",
                width: 30,
                height: 30,
              ),
              title: Text('Infos personnels'),
              onTap: () {
                Get.to(ProfileScreen());
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                "assets/HugeiconsNotification03 (1).svg",
                width: 30,
                height: 30,
              ),
              title: Text('Notifications'),
              onTap: () {
                Get.to(NotificationSettingsScreen());
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                "assets/HugeiconsClock01.svg",
                width: 30,
                height: 30,
              ),
              title: Text('Historique'),
              onTap: () {
                //
                Get.to(Historique());
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                "assets/HugeiconsAgreement01.svg",
                width: 30,
                height: 30,
              ),
              title: Text('Partenaires'),
              onTap: () {
                Get.to(Partenaires());
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                "assets/HugeiconsMessageQuestion.svg",
                width: 30,
                height: 30,
              ),
              title: Text('FAQ'),
              onTap: () {
                //
                Get.to(Faqs());
              },
            ),
            /*
            ListTile(
              leading: SvgPicture.asset(
                "assets/HugeiconsSettings02.svg",
                width: 30,
                height: 30,
              ),
              title: Text('Paramètres'),
              onTap: () {},
            ),
            */
            Divider(),
            ListTile(
              leading: SvgPicture.asset(
                "assets/HugeiconsUser02 (1).svg",
                width: 30,
                height: 30,
              ),
              title: Text('Compte'),
              onTap: () {
                Get.to(DeleteAccountScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red.shade700),
              title: Text(
                'Déconnexion',
                style: TextStyle(color: Colors.red.shade700),
              ),
              onTap: () {
                // Action de déconnexion
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // En-tête avec points et bouton profil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    //height: 35,
                    //width: 50,
                    alignment: Alignment.center,
                    child: Points(client['telephone']),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/HugeiconsMenu11.svg",
                      width: 30,
                      height: 30,
                    ),
                    onPressed: () {
                      // Naviguer vers le profil
                      _openDrawer();
                    },
                  ),
                ],
              ),
            ),
            // Slider des promotions
            FutureBuilder(
              future: getAllPubs(),
              builder: (c, t) {
                if (t.hasData) {
                  List publicites = t.data as List;
                  //
                  return Column(
                    children: [
                      SizedBox(
                        height: 270,
                        child: PageView.builder(
                          controller: _promoController,
                          itemCount: publicites.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPromoIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return _buildPromoCard(publicites[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          publicites.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  _currentPromoIndex == index
                                      ? Colors.blue
                                      : Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (t.hasError) {
                  return Container();
                }
                return Center(
                  child: Container(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),

            // Boutons principaux
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // Action pour réclamer des points
                          Get.to(CodeEntryPage());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'RECLAMER DES POINTS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            SvgPicture.asset(
                              "assets/HugeiconsArrowMoveUpLeft.svg",
                              width: 30,
                              height: 30,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // Action pour réclamer des points
                          //Get.to(CodeEntryPage());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'INSERER CODE PRODUIT',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            SvgPicture.asset(
                              "assets/HugeiconsArrowMoveUpLeft.svg",
                              width: 30,
                              height: 30,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // Action pour dépenser des points
                          showModalBottomSheet(
                            context: context,
                            //showDragHandle: true,
                            isScrollControlled: true,
                            builder: (c) {
                              //
                              return Container(
                                padding: EdgeInsets.all(20),
                                height: Get.height / 1.1,
                                child: Scaffold(
                                  appBar: AppBar(
                                    backgroundColor: Colors.transparent,
                                    title: const Text(
                                      '💰 Convertir mes points',
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  body: FutureBuilder(
                                    future: ServiceRequete.getAllEntreprise(),
                                    builder: (c, t) {
                                      if (t.hasData) {
                                        //
                                        List _filteredConversations =
                                            t.data as List;
                                        //
                                        return ListView.builder(
                                          itemCount:
                                              _filteredConversations.length,
                                          itemBuilder: (context, index) {
                                            final conversation =
                                                _filteredConversations[index];
                                            return ListTile(
                                              leading: CircleAvatar(
                                                //backgroundImage: AssetImage(conversation.avatar, ),
                                                backgroundColor: Colors.white,
                                                radius: 25,
                                                child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          25,
                                                        ),
                                                    // image: DecorationImage(
                                                    //   image: NetworkImage(
                                                    //     "${Requete.url}/api/Entreprise/logo/${conversation['id']}",
                                                    //   ),
                                                    //   fit: BoxFit.contain,
                                                    // ),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "${Requete.url}/api/Entreprise/logo/${conversation['id']}?v=${DateTime.now().millisecondsSinceEpoch}",
                                                    placeholder:
                                                        (context, url) =>
                                                            CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                conversation['nom'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              //
                                              onTap: () {
                                                // Action lorsqu'on clique sur une conversation
                                                Get.to(
                                                  PointsToMoneyPage(
                                                    entreprise: conversation,
                                                  ),
                                                );
                                                //
                                              },
                                            );
                                          },
                                        );
                                      } else if (t.hasError) {
                                        //
                                        return Container();
                                      }

                                      return Center(
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                  ),
                                  //child: SpendPointsPage(),
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'DEPENSER MES POINTS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            SvgPicture.asset(
                              "assets/HugeiconsArrowMoveDownRight.svg",
                              width: 30,
                              height: 30,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List> getAllPubs() async {
    //
    List publicites = [];
    //
    final res = await http.get(Uri.parse("${Requete.url}/publicites"));
    if (res.statusCode == 200) {
      //setState(() {
      publicites = jsonDecode(res.body);
      //});
    }
    return publicites;
  }

  Widget _buildPromoCard(Map promo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "${Requete.url}/publicites/${promo["id"]}/image",
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promo["titre"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    promo["description"],
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.credit_score,
                  //       color: Colors.amber[700],
                  //       size: 20,
                  //     ),
                  //     const SizedBox(width: 5),
                  //     Text(
                  //       "${promo.pointsCost} points",
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.amber[700],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Promotion {
  final String title;
  final String description;
  final int pointsCost;
  final String imagePath;

  Promotion({
    required this.title,
    required this.description,
    required this.pointsCost,
    required this.imagePath,
  });
}
