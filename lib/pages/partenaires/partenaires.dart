import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:promata/utils/requete.dart';

class Partenaires extends StatefulWidget {
  const Partenaires({super.key});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<Partenaires> {
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Conversation> _filteredConversations = [];
  //
  Requete requete = Requete();
  //

  @override
  void initState() {
    super.initState();
    //  _filteredConversations = conversations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            !isSearching
                ? const Text('Partenaires')
                : TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Rechercher une partenaires...',
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
        future: getAllUtilisateurs(),
        builder: (c, t) {
          if (t.hasData) {
            //
            List listEnt = t.data as List;
            return ListView.builder(
              itemCount: listEnt.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> e = listEnt[index];
                print("Entreprise: $e");
                return ListTile(
                  onTap: () {
                    //
                  },
                  leading: CircleAvatar(
                    key: UniqueKey(),
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: NetworkImage(
                      "${Requete.url}/api/Entreprise/logo/${e['id']}",
                    ),
                  ),
                  title: Text(
                    e['nom'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    "${e['secteur']} • ${e['email']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Colors.green,
                    ),
                  ),
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

  Future<List> getAllUtilisateurs() async {
    //
    //
    http.Response response = await requete.getE("api/Entreprise");
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
}

class Conversation {
  final String name;
  final String lastMessage;
  final String time;
  final String avatar;
  final bool unread;

  Conversation({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatar,
    required this.unread,
  });
}
