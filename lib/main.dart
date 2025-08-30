import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:promata/pages/splash.dart';
import 'package:promata/widgets/reclamation/reclamation_controller.dart';

RxMap partenaire = {}.obs;

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  //
  ReclamationController reclamationController = Get.put(
    ReclamationController(),
  );
  //
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ProMata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: Splash(),
    );
  }
}
