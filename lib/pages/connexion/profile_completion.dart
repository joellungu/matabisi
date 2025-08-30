import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:promata/pages/connexion/connexion.dart';
import 'package:promata/utils/requete.dart';
import 'package:http/http.dart' as http;

class ProfileCompletionScreen extends StatefulWidget {
  String telephone;
  String nom;
  ProfileCompletionScreen(this.nom, this.telephone);
  //
  @override
  _ProfileCompletionScreenState createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  //
  Requete requete = Requete();
  //
  var box = GetStorage();

  DateTime? _selectedDate;
  bool _isLoading = false;

  void _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simuler l'enregistrement
      int response = await enregistrement(
        _phoneController.text,
        _nameController.text,
      );
      //
      if (response == 1) {
        setState(() => _isLoading = false);
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => SuccessScreen()));
      } else {
        setState(() => _isLoading = false);
        Get.snackbar("Erreur", "Nous n'avons pas pu créer votre compte");
      }
      //
    }
  }

  Future<int> enregistrement(String phoneNumber, String nom) async {
    http.Response response = await requete.postE("api/Client/clients", {
      "telephone": phoneNumber,
      "nom": nom,
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      //
      Map client = jsonDecode(response.body);
      box.write('client', client);
      print("Succès: ${response.statusCode}");
      print("Succès: ${response.body}");
      return 1;
    } else {
      //
      print("Succès: ${response.statusCode}");
      print("Succès: ${response.body}");
      return 2;
    }
  }

  @override
  void initState() {
    //
    _nameController.text = widget.nom;
    _phoneController.text = widget.telephone;
    //
    super.initState();
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complétez votre profil'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Photo de profil
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          // Ajouter la logique pour changer la photo
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Champ nom complet
              _buildFormField(
                controller: _nameController,
                label: 'Nom complet',
                icon: "HugeiconsUser02 (1).svg",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Champ téléphone (pré-rempli)
              _buildFormField(
                controller: _phoneController..text = phoneNumber!,
                label: 'Téléphone',
                icon: "HugeiconsSmartPhone01.svg",
                enabled: false,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),

              // Champ date de naissance
              SizedBox(height: 30),

              // Bouton de soumission
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _submitProfile,
                  child:
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            'TERMINER L\'INSCRIPTION',
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
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String icon,
    TextInputType? keyboardType,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Container(
          height: 30,
          width: 30,
          //color: Colors.yellow,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            "assets/$icon",
            width: 30,
            height: 30,
            color: Colors.blue,
          ),
        ),
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      enabled: enabled,
      validator: validator,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
