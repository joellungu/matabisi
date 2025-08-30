import 'package:flutter/material.dart';


class DeleteAccountScreen extends StatefulWidget {
  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _understandConsequences = false;
  bool _confirmDelete = false;
  TextEditingController _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supprimer le compte'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icône d'avertissement
            Center(
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.red.shade700,
                size: 80,
              ),
            ),
            SizedBox(height: 20),

            // Titre
            Text(
              'Supprimer définitivement votre compte?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),

            // Description
            Text(
              'Cette action est irréversible. Toutes vos données seront définitivement supprimées:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),

            // Liste des conséquences
            _buildConsequenceItem('✓ Tous vos coupons et avantages seront perdus'),
            _buildConsequenceItem('✓ Votre historique de transactions disparaîtra'),
            _buildConsequenceItem('✓ Vos points de fidélité seront annulés'),
            _buildConsequenceItem('✓ Vous ne pourrez pas récupérer ce compte'),
            SizedBox(height: 20),

            // Case à cocher - Comprend les conséquences
            CheckboxListTile(
              title: Text(
                'Je comprends les conséquences de cette action',
                style: TextStyle(fontSize: 16),
              ),
              value: _understandConsequences,
              onChanged: (value) {
                setState(() {
                  _understandConsequences = value ?? false;
                });
              },
              activeColor: Theme.of(context).primaryColor,
              controlAffinity: ListTileControlAffinity.leading,
            ),

            // Case à cocher - Confirmation
            CheckboxListTile(
              title: Text(
                'Je confirme vouloir supprimer mon compte',
                style: TextStyle(fontSize: 16),
              ),
              value: _confirmDelete,
              onChanged: (value) {
                setState(() {
                  _confirmDelete = value ?? false;
                });
              },
              activeColor: Theme.of(context).primaryColor,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            SizedBox(height: 20),

            // Champ de raison (optionnel)
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: 'Raison (optionnel)',
                hintText: 'Pourquoi souhaitez-vous supprimer votre compte?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 30),

            // Bouton de suppression
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _understandConsequences && _confirmDelete
                    ? () {
                  _showFinalConfirmationDialog(context);
                }
                    : null,
                child: Text(
                  'SUPPRIMER MON COMPTE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsequenceItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 8, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  void _showFinalConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Dernière confirmation'),
        content: Text(
          'Êtes-vous absolument sûr de vouloir supprimer définitivement votre compte? Cette action ne peut pas être annulée.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _processAccountDeletion();
            },
            child: Text(
              'Supprimer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _processAccountDeletion() {
    // Ici vous ajouteriez la logique de suppression réelle
    // Après la suppression, vous pourriez rediriger vers l'écran de connexion

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compte supprimé avec succès'),
        duration: Duration(seconds: 2),
      ),
    );

    // Après un délai, rediriger
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}