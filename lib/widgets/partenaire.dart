import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:promata/main.dart';
import 'package:promata/widgets/reclamation/reclamation_controller.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final List<Conversation> conversations = [
    Conversation(
      name: 'Vodacom',
      lastMessage: 'Achat crédit.',
      time: '10:30',
      avatar: 'assets/Vodacom-1.png',
      unread: true,
    ),
    Conversation(
      name: 'Orange',
      lastMessage: 'Activation tout réseaux.',
      time: 'Hier',
      avatar: 'assets/Orange-S.A.-Logo.png',
      unread: false,
    ),
    Conversation(
      name: 'Airtel',
      lastMessage: 'Activation appel nuit',
      time: 'Hier',
      avatar: 'assets/Airtel_logo-02.png',
      unread: true,
    ),
    Conversation(
      name: 'Africell',
      lastMessage: 'Activation appel nuit',
      time: 'Hier',
      avatar: 'assets/africell_rdc_logo.jpeg',
      unread: true,
    ),
    Conversation(
      name: 'Beltexco',
      lastMessage: '3 bouteils une reduction.',
      time: '20/04',
      avatar: 'assets/beltexco.png',
      unread: false,
    ),
    Conversation(
      name: 'Prince Pharma',
      lastMessage: 'Un packet pour 10',
      time: '19/04',
      avatar: 'assets/prince-pharma-logo.png',
      unread: false,
    ),
    Conversation(
      name: 'Dream Cosmetics',
      lastMessage: 'Un packet pour 10',
      time: '19/04',
      avatar: 'assets/dreamcosmetics.jpeg',
      unread: false,
    ),
    Conversation(
      name: 'Pains Victoire',
      lastMessage: 'Un packet pour 10',
      time: '19/04',
      avatar: 'assets/painvictoire.jpeg',
      unread: false,
    ),
  ];

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Conversation> _filteredConversations = [];
  //
  ReclamationController reclamationController = Get.find();

  @override
  void initState() {
    super.initState();
    _filteredConversations = conversations;
  }

  void _filterConversations(String query) {
    setState(() {
      _filteredConversations =
          conversations.where((conv) {
            return conv.name.toLowerCase().contains(query.toLowerCase());
          }).toList();
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
                  _filteredConversations = conversations;
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
                  image: DecorationImage(
                    image: ExactAssetImage(conversation.avatar),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            title: Text(
              conversation.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            //subtitle: Text(conversation.lastMessage),
            /*
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  conversation.time,
                  style: TextStyle(
                    color: conversation.unread
                        ? Colors.teal
                        : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (conversation.unread)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            */
            onTap: () {
              // Action lorsqu'on clique sur une conversation
              //
              partenaire.value = {
                "id": 1,
                "nom": conversation.name,
                "logo": conversation.avatar,
              };
              reclamationController.checkTicket(conversation.name);
              //
              Get.back();
              print('Conversation sélectionnée: ${conversation.name}');
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
