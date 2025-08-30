import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:promata/pages/connexion/profile_completion.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PageOtp extends StatefulWidget {
  String? phoneNumber;
  String? code;
  String? nom;
  PageOtp({super.key, required this.phoneNumber, this.nom, this.code});
  //

  @override
  State<PageOtp> createState() => _PageOtpState();
}

class _PageOtpState extends State<PageOtp> {
  String _otpCode = "";

  void _submitOtp() {
    if (_otpCode.length == widget.code) {
      // Remplace ceci par ta logique de validation
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Code OTP saisi : $_otpCode")),
      // );
      //
      //Cool // widget.user!
      Get.to(ProfileCompletionScreen(widget.nom!, widget.phoneNumber!));
      //
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Veuillez saisir le code complet. ${widget.code}"),
        ),
      );
    }
  }

  @override
  void initState() {
    //
    super.initState();
    //
  }

  gatSMS() async {
    //
    await SmsAutoFill().listenForCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vérification OTP")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              "Un code a été envoyé à ${widget.phoneNumber}",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PinFieldAutoFill(
              //decoration: BoxLooseDecoration²,// UnderlineDecoration, BoxLooseDecoration or BoxTightDecoration see https://github.com/TinoGuo/pin_input_text_field for more info,
              //currentCode: // prefill with a code
              onCodeSubmitted: (String verificationCode) {
                setState(() {
                  _otpCode = verificationCode;
                  print("code: ${widget.code} == $verificationCode");
                  //_otpCode = verificationCode;
                  if (widget.code == verificationCode) {
                    //Cool // widget.user!
                    Get.to(
                      ProfileCompletionScreen(widget.nom!, widget.phoneNumber!),
                    );
                  } else {
                    //
                    Get.snackbar("Oups", "Code incorrecte.");
                  }
                });
              }, //code submitted callback
              onCodeChanged: (String? verificationCode) {
                _otpCode = verificationCode!;
                print("code: $verificationCode");
                //setState(
                //() {
                _otpCode = verificationCode!;
                print("code: ${widget.code} == $verificationCode");
                //_otpCode = verificationCode;
                if (verificationCode.isNotEmpty) {
                  if (widget.code == verificationCode) {
                    //Cool // widget.user!
                    Get.to(
                      ProfileCompletionScreen(widget.nom!, widget.phoneNumber!),
                    );
                  } else {
                    //
                    // Timer(const Duration(seconds: 1), () {
                    //   Get.snackbar("Oups", "Code incorrecte.");
                    // });
                  }
                }
                //   },
                // );
              }, //code changed callback
              codeLength: 6, //code length, default 6
            ),
            // OtpTextField(
            //   numberOfFields: 7,
            //   borderColor: Theme.of(context).primaryColor,
            //   focusedBorderColor: Colors.black,
            //   showFieldAsBox: true,
            //   onCodeChanged: (String code) {
            //     // Optionnel : faire quelque chose à chaque changement
            //   },
            //   onSubmit: (String verificationCode) {
            //     setState(() {
            //       print("code: ${widget.code} == $verificationCode");
            //       //_otpCode = verificationCode;
            //       if (widget.code == verificationCode) {
            //         //Cool
            //         Get.to(Signup(widget.user!));
            //       } else {
            //         //
            //         Get.snackbar("Oups", "Code incorrecte.");
            //       }
            //     });
            //   },
            // ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitOtp,
              child: const Text("Valider le code"),
            ),
          ],
        ),
      ),
    );
  }
}
