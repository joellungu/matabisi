import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController(text: "Jean Dupont");
  TextEditingController _emailController = TextEditingController(text: "jean.dupont@example.com");
  TextEditingController _phoneController = TextEditingController(text: "+33 6 12 34 56 78");
  TextEditingController _birthdateController = TextEditingController(text: "15/03/1985");

  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informations Personnelles'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  // Sauvegarder les modifications
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profil mis à jour')),
                  );
                }
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Photo de profil
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150/075E54/FFFFFF?text=JD',
                  ),
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.tealAccent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: () {
                          // Ajouter la logique pour changer la photo
                        },
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),

            // Champs d'information
            _buildInfoTile(
              icon: "HugeiconsUser02 (1).svg",
              label: 'Nom complet',
              value: _nameController.text,
              controller: _nameController,
            ),
            Divider(),

            _buildInfoTile(
              icon: "HugeiconsMailAtSign01.svg",
              label: 'Email',
              value: _emailController.text,
              controller: _emailController,
            ),
            Divider(),

            _buildInfoTile(
              icon: "HugeiconsSmartPhone01.svg",
              label: 'Téléphone',
              value: _phoneController.text,
              controller: _phoneController,
            ),
            Divider(),

            _buildInfoTile(
              icon: "HugeiconsCalendar03 (1).svg",
              label: 'Date de naissance',
              value: _birthdateController.text,
              controller: _birthdateController,
            ),
            Divider(),

            // Section adresse
            ListTile(
              leading: SvgPicture.asset(
                "assets/HugeiconsLocation02 (2).svg",
                width: 30,
                height: 30,
                color: Colors.blue,
              ),
              title: Text('Adresse'),
              subtitle: Text('12 Rue de la Paix, Paris'),
              trailing: _isEditing ? Icon(Icons.arrow_forward_ios, size: 16) : null,
              onTap: _isEditing ? () {
                // Naviguer vers l'écran d'édition de l'adresse
              } : null,
            ),
            Divider(),
            Divider(),


          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required String icon,
    required String label,
    required String value,
    required TextEditingController controller,
  }) {
    return ListTile(
      leading: SvgPicture.asset(
        "assets/$icon",
        width: 30,
        height: 30,
        color: Colors.blue,
      ),
      title: Text(label),
      subtitle: _isEditing
          ? TextField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
        style: TextStyle(fontSize: 16),
      )
          : Text(value, style: TextStyle(fontSize: 16)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }
}