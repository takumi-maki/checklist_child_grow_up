import 'package:demo_sns_app/view/screen.dart';
import 'package:demo_sns_app/view/start_up/login_page.dart';
import 'package:flutter/material.dart';

import 'time_line/time_line_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        ),
      home: const LoginPage(),
    );
  }
}
