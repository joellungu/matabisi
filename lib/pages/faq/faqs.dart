import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


class Faqs extends StatefulWidget {
  const Faqs({super.key});

  @override
  _Faqs createState() => _Faqs();
}

class _Faqs extends State<Faqs> {
  final List<Map> conversations = [
    {
      "question": "Comment fonctionne l'application de coupons ?",
      "answer": "L'application vous permet de découvrir, sauvegarder et utiliser des coupons de réduction auprès de nos commerçants partenaires. Il suffit de présenter le coupon en magasin ou de l'utiliser en ligne selon les conditions indiquées."
    },
    {
      "question": "L'application est-elle gratuite ?",
      "answer": "Oui, l'application est entièrement gratuite à télécharger et à utiliser. Vous ne payez que lorsque vous utilisez un coupon pour acheter un produit ou service."
    },
    {
      "question": "Comment créer un compte ?",
      "answer": "Cliquez sur 'Créer un compte' depuis l'écran d'accueil et suivez les instructions. Vous pouvez vous inscrire via email, numéro de téléphone ou en utilisant vos comptes sociaux comme Google ou Facebook."
    },
    {
      "question": "Comment réinitialiser mon mot de passe ?",
      "answer": "Allez sur la page de connexion, cliquez sur 'Mot de passe oublié' et entrez votre email. Vous recevrez un lien pour réinitialiser votre mot de passe."
    },
    {
      "question": "Comment trouver des coupons près de chez moi ?",
      "answer": "Activez la géolocalisation dans l'application ou entrez manuellement votre ville pour voir les offres disponibles dans votre zone."
    },
    {
      "question": "Puis-je utiliser plusieurs coupons simultanément ?",
      "answer": "Cela dépend des conditions de chaque coupon. Certains commerçants autorisent le cumul, d'autres non. Les détails sont indiqués dans les conditions de chaque offre."
    },
    {
      "question": "Comment savoir si un coupon a expiré ?",
      "answer": "La date d'expiration est clairement indiquée sur chaque coupon. Vous recevrez également une notification avant l'expiration des coupons sauvegardés."
    },
    {
      "question": "Que faire si un commerçant refuse mon coupon ?",
      "answer": "Contactez notre service client avec une preuve du refus (photo du coupon et du rejet). Nous vérifierons et vous proposerons une solution."
    },
    {
      "question": "Comment signaler un coupon qui ne fonctionne pas ?",
      "answer": "Dans la description du coupon, cliquez sur 'Signaler un problème' et décrivez l'issue rencontrée. Notre équipe traitera votre demande rapidement."
    },
    {
      "question": "L'application est-elle disponible sur iOS et Android ?",
      "answer": "Oui, l'application est disponible sur l'App Store pour iOS et le Play Store pour Android."
    },
    {
      "question": "Comment recevoir des notifications pour les nouveaux coupons ?",
      "answer": "Activez les notifications dans les paramètres de l'application et sélectionnez vos catégories préférées pour recevoir des alertes personnalisées."
    },
    {
      "question": "Puis-je partager des coupons avec des amis ?",
      "answer": "Oui, chaque coupon dispose d'une option de partage par email, SMS ou sur les réseaux sociaux."
    },
    {
      "question": "Comment contacter le service client ?",
      "answer": "Allez dans 'Paramètres' > 'Aide' > 'Contactez-nous'. Vous pouvez nous joindre par chat, email ou téléphone aux heures d'ouverture."
    },
    {
      "question": "Les coupons en ligne comment fonctionnent-ils ?",
      "answer": "Pour les coupons en ligne, copiez le code promotionnel au moment du paiement ou cliquez sur le lien qui vous redirigera vers le site partenaire avec le code déjà appliqué."
    },
    {
      "question": "Comment supprimer mon compte ?",
      "answer": "Dans les paramètres du compte, sélectionnez 'Supprimer mon compte'. Attention : cette action est irréversible."
    },
    {
      "question": "L'application propose-t-elle des coupons alimentaires ?",
      "answer": "Oui, nous proposons des coupons dans diverses catégories dont l'alimentation. Utilisez les filtres pour trouver les offres qui vous intéressent."
    },
    {
      "question": "Puis-je utiliser un coupon plusieurs fois ?",
      "answer": "Sauf mention contraire ('usage multiple'), chaque coupon n'est utilisable qu'une seule fois par utilisateur."
    },
    {
      "question": "Comment sont sélectionnés les commerçants partenaires ?",
      "answer": "Nous collaborons avec des enseignes sérieuses après vérification de leur fiabilité. Vous pouvez suggérer des commerçants via notre formulaire en ligne."
    },
    {
      "question": "Existe-t-il un programme de parrainage ?",
      "answer": "Oui, vous gagnez des avantages en parrainant vos amis. Consultez la section 'Parrainage' dans l'application pour plus de détails."
    },
    {
      "question": "Comment mettre à jour l'application ?",
      "answer": "Les mises à jour se font automatiquement depuis l'App Store ou Play Store. Vous pouvez aussi les déclencher manuellement dans les paramètres de votre magasin d'applications."
    }
  ];

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Map> _filteredConversations = [];

  @override
  void initState() {
    super.initState();
    _filteredConversations = conversations;
  }

  void _filterConversations(String query) {
    setState(() {
      _filteredConversations = conversations.where((conv) {
        return conv['question'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? const Text('Foire aux questions')
            : TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Rechercher une question...',
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
        padding: EdgeInsets.all(15),
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
                child: SvgPicture.asset(
                  "assets/HugeiconsMessageQuestion.svg",
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            title: Text(
              conversation['question'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${conversation['answer']}\n",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            onTap: () {
              // Action lorsqu'on clique sur une conversation
              showModalBottomSheet(
                  context: context,
                  useSafeArea: true,
                  isScrollControlled: true,
                  //showDragHandle: true,
                  builder: (c){
                    return Container(
                      height: Get.height / 2,
                      width: Get.width,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                        Text(
                          conversation['question'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text("${conversation['answer']}\n",
                          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                        )
                        ],
                      ),
                    );
                  });
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
