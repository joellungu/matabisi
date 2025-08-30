import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:promata/pages/accueil.dart';
import 'package:promata/widgets/reclamation/reclamation_controller.dart';
import 'package:promata/widgets/reclamation/scanner.dart';

class Reclamation extends GetView<ReclamationController> {
  //

  //
  bool isSearching = false;
  //
  Reclamation() {
    //
    controller.videTicket();
  }
  @override
  Widget build(BuildContext context) {
    //
    return controller.obx(
      (d) {
        List services = d as List;
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(services.length, (s) {
                  Map service = services[s];
                  return ListTile(
                    leading: CircleAvatar(
                      //backgroundImage: AssetImage(conversation.avatar, ),
                      backgroundColor: Colors.transparent,
                      radius: 25,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: ExactAssetImage(service['logo']),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      service['service'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text.rich(
                      TextSpan(
                        text: "${service['details']}\n",
                        children: [
                          // TextSpan(
                          //   text: "${service['points']}",
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.teal,
                          //   ),
                          // ),
                          /*
                TextSpan(text: '${conversation.points}Pt',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue,
                    )
                ),
                */
                        ],
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${service['points']}Pt',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        //if (conversation.unread)
                        //   Container(
                        //     margin: const EdgeInsets.only(top: 4),
                        //     width: 16,
                        //     height: 16,
                        //     decoration: const BoxDecoration(
                        //       //color: Colors.teal,
                        //       shape: BoxShape.circle,
                        //     ),
                        //     child: Center(
                        //       child: SvgPicture.asset(
                        //         service.unread
                        //             ? "assets/HugeiconsArrowMoveUpLeft.svg"
                        //             : "assets/HugeiconsArrowMoveDownRight.svg",
                        //         width: 30,
                        //         height: 30,
                        //         color: Colors.teal,
                        //       ),
                        //       /*
                        //   child: Text(
                        //   '1',
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 10,
                        //   ),
                        // ),
                        // */
                        //     ),
                        //   ),
                      ],
                    ),
                    onTap: () {
                      // Action lorsqu'on clique sur une conversation
                      //_showActionDetails(context, conversation);
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        builder: (c) {
                          //
                          return Container(
                            padding: EdgeInsets.all(20),
                            height: 400,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Mode de reclamation",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: ExactAssetImage(service['logo']),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    service['service'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text.rich(
                                    TextSpan(
                                      text: "${service['details']}",
                                      children: [],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    //
                                    Get.back();
                                    //
                                    final TextEditingController
                                    _promoController = TextEditingController();
                                    //
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          backgroundColor: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.card_giftcard,
                                                  size: 48,
                                                  color: Colors.deepPurple,
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  '🎁 Entrez votre code promo',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.deepPurple,
                                                  ),
                                                ),
                                                const SizedBox(height: 15),
                                                TextField(
                                                  controller: _promoController,
                                                  decoration: InputDecoration(
                                                    hintText: 'Ex: BON2025',
                                                    filled: true,
                                                    fillColor: Colors.grey[100],
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    prefixIcon: Icon(
                                                      Icons.percent,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextButton(
                                                        onPressed:
                                                            () =>
                                                                Navigator.of(
                                                                  context,
                                                                ).pop(),
                                                        child: Text(
                                                          'Annuler',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.blue,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          String code =
                                                              _promoController
                                                                  .text
                                                                  .trim();
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                          // TODO: ajoute ici ton code de traitement du code promo
                                                          print(
                                                            "Code promo entré: $code",
                                                          );
                                                          //
                                                          Get.snackbar(
                                                            "Succès",
                                                            "Vous avez réçu ${service['points']}Pt",
                                                            backgroundColor:
                                                                Colors.green,
                                                            colorText:
                                                                Colors.white,
                                                          );
                                                          Get.offAll(Accueil());
                                                          //
                                                        },
                                                        child: Text(
                                                          'Valider',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'SAISIR LE CODE',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      SvgPicture.asset(
                                        "assets/HugeiconsPen01.svg",
                                        width: 30,
                                        height: 30,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    //
                                    Get.back();
                                    //
                                    Get.to(QRScannerPage(service));
                                    //
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'SCANNER LE QR-CODE',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      SvgPicture.asset(
                                        "assets/HugeiconsQrCode (1).svg",
                                        width: 30,
                                        height: 30,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ),
          ),
        );
      },
      onEmpty: Container(),
      onError: (e) {
        return Container();
      },
      onLoading: Center(
        child: Container(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  //
  Widget _buildDetailRow(var icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
