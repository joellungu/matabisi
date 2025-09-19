import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool _isEditing = false;
  //
  var box = GetStorage();
  //
  Map client = {};

  @override
  void initState() {
    //
    client = box.read("client") ?? {};
    print('Client: $client');
    //
    _nameController = TextEditingController(text: "${client['nom']}");
    _phoneController = TextEditingController(text: "${client['telephone']}");
    //
    super.initState();
  }

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
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Profil mis à jour')));
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
              edit: true,
              controller: _nameController,
            ),
            Divider(),
            _buildInfoTile(
              icon: "HugeiconsSmartPhone01.svg",
              label: 'Téléphone',
              value: _phoneController.text,
              edit: false,
              controller: _phoneController,
            ),
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
    required bool edit,
  }) {
    return ListTile(
      leading: SvgPicture.asset(
        "assets/$icon",
        width: 30,
        height: 30,
        color: Colors.blue,
      ),
      title: Text(label),
      subtitle:
          _isEditing && edit
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
    _phoneController.dispose();
    super.dispose();
  }
}
