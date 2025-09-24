import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:promata/utils/requete.dart';
import 'package:http/http.dart' as http;

class Historique extends StatefulWidget {
  const Historique({super.key});

  @override
  _Historique createState() => _Historique();
}

class _Historique extends State<Historique> {
  //

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Conversation> _filteredConversations = [];
  //
  Requete requete = Requete();
  //
  var box = GetStorage();
  //
  Map client = {};

  @override
  void initState() {
    //
    client = box.read("client") ?? {};
    //
    super.initState();
    //_filteredConversations = conversations;
  }

  // void _filterConversations(String query) {
  //   setState(() {
  //     _filteredConversations =
  //         conversations.where((conv) {
  //           return conv.name.toLowerCase().contains(query.toLowerCase());
  //         }).toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            !isSearching
                ? const Text('Historique des actions')
                : TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Rechercher une action...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.black),
                  //onChanged: _filterConversations,
                ),
        actions: [
          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  isSearching = false;
                  _searchController.clear();
                  //_filteredConversations = conversations;
                });
              },
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: FutureBuilder(
        future: getAllUtilisateurs(client['telephone']),
        builder: (c, t) {
          if (t.hasData) {
            //
            List _filteredConversations = t.data as List;
            //
            return ListView.builder(
              itemCount: _filteredConversations.length,
              itemBuilder: (context, index) {
                final conversation = _filteredConversations[index];
                return ListTile(
                  leading: CircleAvatar(
                    //backgroundImage: AssetImage(conversation.avatar, ),
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CachedNetworkImage(
                        imageUrl:
                            "${Requete.url}/api/Entreprise/logo/${conversation['idEntreprise']}?v=${DateTime.now().millisecondsSinceEpoch}",
                        placeholder:
                            (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  title: Text(
                    conversation['nom'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text.rich(
                    TextSpan(
                      text: "${conversation['nomCategorie']}\n",
                      children: [
                        TextSpan(
                          text: "${conversation['date']} ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
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
                        '${conversation['valeur']} Pts',
                        style: TextStyle(
                          color: true ? Colors.teal : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),

                      //if (conversation.unread)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          //color: Colors.teal,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            true
                                ? "assets/HugeiconsArrowMoveUpLeft.svg"
                                : "assets/HugeiconsArrowMoveDownRight.svg",
                            width: 30,
                            height: 30,
                            color: Colors.teal,
                          ),
                          /*
                        child: Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      */
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Action lorsqu'on clique sur une conversation
                    _showActionDetails(context, conversation);
                  },
                );
              },
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
    );
  }

  Future<List> getAllUtilisateurs(String telephone) async {
    //
    print("Téléphone: ${client['telephone']}");
    //
    http.Response response = await requete.postEs(
      "api/transactions/client/2mois",
      client['telephone'],
    );
    //
    if (response.statusCode == 200 || response.statusCode == 201) {
      //
      print("SUCCES: ${response.statusCode}");
      print("SUCCES: ${response.body}");
      return jsonDecode(response.body);
    } else {
      print("ERREUR: ${response.statusCode}");
      print("ERREUR: ${response.body}");
      return [];
    }
  }

  //
  void _showActionDetails(BuildContext context, Map data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            // image: DecorationImage(
                            //   image: ExactAssetImage(data.avatar),
                            //   fit: BoxFit.contain,
                            // ),
                          ),
                          //idCategorie
                          child: CachedNetworkImage(
                            imageUrl:
                                "${Requete.url}/api/Entreprise/logo/${data['idEntreprise']}?v=${DateTime.now().millisecondsSinceEpoch}",
                            placeholder:
                                (context, url) => CircularProgressIndicator(),
                            errorWidget:
                                (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['nomCategorie'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                data['nomCategorie'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(),
                      ],
                    ),
                    SizedBox(height: 24),
                    _buildDetailRow(Icons.store, 'Entreprise', data['nom']),
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Date et Heure',
                      data['nomCategorie'],
                    ),
                    //_buildDetailRow(Icons.credit_card, 'Montant', '45,00 €'),
                    _buildDetailRow(
                      Icons.stars,
                      'Points gagnés',
                      '${data['valeur']} pts',
                    ),
                    _buildDetailRow(Icons.location_on, 'Lieu', 'Kinshasa, RDC'),
                    _buildDetailRow(
                      Icons.receipt,
                      'Référence',
                      '${data['id']}',
                    ),
                    SizedBox(height: 24),
                    Divider(),
                  ],
                ),
              ),
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

class Conversation {
  final String name;
  final String lastMessage;
  final double points;
  final String time;
  final String avatar;
  final bool unread;

  Conversation({
    required this.name,
    required this.lastMessage,
    required this.points,
    required this.time,
    required this.avatar,
    required this.unread,
  });
}
