import 'dart:async';
import 'dart:io';

import 'package:aichat/components/HideKeyboard.dart';
import 'package:aichat/page/AppOpenPage.dart';
import 'package:aichat/page/purchase_controller.dart';
import 'package:aichat/stores/AIChatStore.dart';
import 'package:aichat/utils/Chatgpt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {});
  await Purchases.configure(PurchasesConfiguration((Platform.isAndroid)
      ? "goog_PBPFtsvocEdpZRFRiKUDycxqcWn"
      : "appl_WnmVuMzzpAdeNeZIsDlQpGsyQuN"));
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'hello@binarybox.co.in', password: 'Rutvik@9061');
  } catch (_) {}
  await dotenv.load(fileName: ".env");
  final PurchaseController _controller = Get.put(PurchaseController());

  await GetStorage.init();
  await ChatGPT.initChatGPT();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AIChatStore(),
      child: const MyApp(),
    ),
  );
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        home: const SplashPage(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

Future<void> configLoading() async {
  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.none
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..displayDuration = const Duration(milliseconds: 1000)
    ..userInteractions = false;
}
