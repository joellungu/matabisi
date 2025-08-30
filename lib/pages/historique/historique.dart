import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class Historique extends StatefulWidget {
  const Historique({super.key});

  @override
  _Historique createState() => _Historique();
}

class _Historique extends State<Historique> {
  final List<Conversation> conversations = [
    Conversation(
      name: 'Vodacom',
      points: 30,
      lastMessage: 'Achat crédit.',
      time: '10:30',
      avatar: 'assets/Vodacom-1.png',
      unread: true,
    ),
    Conversation(
      name: 'Orange',
      points: 10,
      lastMessage: 'Activation tout réseaux.',
      time: 'Hier',
      avatar: 'assets/Orange-S.A.-Logo.png',
      unread: false,
    ),
    Conversation(
      name: 'Airtel',
      points: 20,
      lastMessage: 'Activation appel nuit',
      time: 'Hier',
      avatar: 'assets/Airtel_logo-02.png',
      unread: true,
    ),
    Conversation(
      name: 'Mayonnaise Mayo',
      points: 70,
      lastMessage: '3 bouteils une reduction.',
      time: '20/04',
      avatar: 'assets/EXC_0272.jpg',
      unread: false,
    ),
    Conversation(
      name: 'Guillette',
      points: 50,
      lastMessage: 'Un packet pour 10',
      time: '19/04',
      avatar: 'assets/Gillette-Logo.png',
      unread: false,
    ),
  ];

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Conversation> _filteredConversations = [];

  @override
  void initState() {
    super.initState();
    _filteredConversations = conversations;
  }

  void _filterConversations(String query) {
    setState(() {
      _filteredConversations = conversations.where((conv) {
        return conv.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
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
                  image: DecorationImage(image: ExactAssetImage(conversation.avatar),
                  fit: BoxFit.contain
                  )
                ),
              ),
            ),
            title: Text(
              conversation.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text.rich(TextSpan(
              text: "${conversation.lastMessage}\n",
              children: [
                TextSpan(text: "01-08-2025 ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.teal,
                  )
                ),
                /*
                TextSpan(text: '${conversation.points}Pt',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue,
                    )
                ),
                */
              ]
            )),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Text(
                  '${conversation.points}Pt',
                  style: TextStyle(
                    color: conversation.unread
                        ? Colors.teal
                        : Colors.grey[600],
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
                        conversation.unread ? "assets/HugeiconsArrowMoveUpLeft.svg":
                        "assets/HugeiconsArrowMoveDownRight.svg",
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
      ),
    );
  }

  //
  void _showActionDetails(BuildContext context, Conversation data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                      )),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(image: ExactAssetImage(data.avatar),
                                fit: BoxFit.contain
                            )
                        ),

                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            data.lastMessage,
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
                _buildDetailRow(Icons.store, 'Marque', data.name),
                _buildDetailRow(Icons.calendar_today, 'Date et Heure',
                    '15 Juin 2023 • 14:30'),
                _buildDetailRow(Icons.credit_card, 'Montant', '45,00 €'),
                _buildDetailRow(Icons.stars, 'Points gagnés', '120 pts'),
                _buildDetailRow(Icons.location_on, 'Lieu', 'Kinshasa, RDC'),
                _buildDetailRow(
                    Icons.receipt, 'Référence', 'TX-7894561230'),
                SizedBox(height: 24),
                Divider(),
                SizedBox(height: 16),
                Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Achat d\'accessoires pour iPhone dans la boutique officielle Apple. Promotion spéciale été 2023 avec points bonus.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 24),

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
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
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