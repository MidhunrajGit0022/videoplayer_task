import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:videoplayer/features/auth/auth_controller.dart/authentication_controller.dart';
import 'package:videoplayer/firebase_options.dart';
import 'package:videoplayer/routes/route_pages.dart';
import 'package:videoplayer/themes/theme.dart';
import 'package:videoplayer/themes/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationController()));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await FlutterDownloader.initialize(debug: true);
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ThemeController themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: pages,
      theme: Themes().lightTheme,
      darkTheme: Themes().darktheme,
      themeMode: ThemeMode.system,
      home: const CircularProgressIndicator(),
    );
  }
}
