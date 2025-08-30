import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../widgets/partenaire.dart';
import '../../widgets/reclamation/reclamation.dart';

class CodeEntryPage extends StatefulWidget {
  @override
  _CodeEntryPageState createState() => _CodeEntryPageState();
}

class _CodeEntryPageState extends State<CodeEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  String? selectedPartner;
  //
  Map companie = {};

  final List<String> partners = ['Orange', 'Airtel', 'Vodacom'];

  void _submit() {
    //
    if (_formKey.currentState!.validate()) {
      // Simuler une validation de code ici

      //
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        //showDragHandle: true,
        builder: (c) {
          return Container(
            height: Get.height,
            width: Get.width,
            child: ConversationScreen(),
          );
        },
      );
      //

      _codeController.clear();
      setState(() {
        selectedPartner = null;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Veuillez saisir votre code.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RECLAMATION',
          style: TextStyle(
            //color: Colors.white,
          ),
        ),
        centerTitle: true,
        //backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Veuillez sectionner un partenaire !',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              // SizedBox(height: 20),
              // TextFormField(
              //   controller: _codeController,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //   ),
              //   decoration: InputDecoration(
              //     labelText: 'Code reçu',
              //     border: OutlineInputBorder(),
              //     prefixIcon: Icon(Icons.confirmation_number),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Veuillez entrer un code';
              //     }
              //     return null;
              //   },
              // ),
              SizedBox(height: 15),
              Container(
                height: 55,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey, width: 0.9),
                ),
                child: Obx(
                  () => ListTile(
                    onTap: () {
                      //
                      _submit();
                    },
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: ExactAssetImage(partenaire['logo'] ?? ''),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    title: Text(partenaire['nom'] ?? ''),
                    trailing: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
              Expanded(flex: 9, child: Reclamation()),
            ],
          ),
        ),
      ),
    );
  }
}
