import 'package:checklist_child_grow_up/firebase_options.dart';
import 'package:checklist_child_grow_up/view/start_up/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
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
      title: '0~3歳までの成長のチェックリスト',
      theme: ThemeData(
       colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.orange[700])
        ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
