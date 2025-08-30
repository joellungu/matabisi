import 'package:flutter/material.dart';

class SpendPointsPage extends StatelessWidget {
  const SpendPointsPage({Key? key}) : super(key: key);

  final List<_OptionItem> options = const [
    _OptionItem(
      emoji: "🎁",
      title: "Bons de réduction",
      subtitle: "Échange tes points contre des remises",
    ),
    _OptionItem(
      emoji: "🏪",
      title: "Coupons partenaires",
      subtitle: "Utilise tes points chez nos partenaires",
    ),
    _OptionItem(
      emoji: "🎟️",
      title: "Tickets événementiels",
      subtitle: "Assiste à des événements avec tes points",
    ),
    _OptionItem(
      emoji: "🎫",
      title: "Cartes cadeaux",
      subtitle: "Reçois une carte à dépenser",
    ),
    _OptionItem(
      emoji: "🤝",
      title: "Transfert à un ami",
      subtitle: "Offre des points à un proche",
    ),
    _OptionItem(
      emoji: "🎰",
      title: "Tombolas / Jeux",
      subtitle: "Participe avec tes points",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎯 Utiliser mes points')),
      backgroundColor: Colors.transparent,
      body: ListView.separated(
        padding: const EdgeInsets.all(10.0),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = options[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 1,
            child: ListTile(
              leading: Text(item.emoji, style: const TextStyle(fontSize: 28)),
              title: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item.subtitle),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('👉 ${item.title} sélectionné')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _OptionItem {
  final String emoji;
  final String title;
  final String subtitle;

  const _OptionItem({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });
}
