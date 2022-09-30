import 'package:demo_sns_app/firebase_options.dart';
import 'package:demo_sns_app/view/start_up/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'わが子の成長チェックリスト',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
