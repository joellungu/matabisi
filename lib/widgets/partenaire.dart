import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:promata/main.dart';
import 'package:promata/utils/requete.dart';
import 'package:promata/widgets/reclamation/reclamation_controller.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List _filteredConversations = [];
  //
  ReclamationController reclamationController = Get.find();
  //
  var box = GetStorage();
  //

  @override
  void initState() {
    super.initState();
    //
    _filteredConversations = box.read("entreprises") ?? [];
  }

  void _filterConversations(String query) {
    setState(() {
      // _filteredConversations =
      //     conversations.where((conv) {
      //       return conv.name.toLowerCase().contains(query.toLowerCase());
      //     }).toList();
    });
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
                  onChanged: _filterConversations,
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
      body: ListView.builder(
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
                      "${Requete.url}/api/Entreprise/logo/${conversation['id']}",
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            title: Text(
              conversation['nom'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            //subtitle: Text(conversation.lastMessage),
            //
            onTap: () {
              // Action lorsqu'on clique sur une conversation
              //
              partenaire.value = {
                "id": conversation['id'],
                "nom": conversation['nom'],
                "logo": conversation['id'],
              };
              reclamationController.checkTicket(conversation['nom']);
              //
              Get.back();
              print('Conversation sélectionnée: ${conversation['nom']}');
            },
          );
        },
      ),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action pour créer une nouvelle conversation
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      */
    );
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
