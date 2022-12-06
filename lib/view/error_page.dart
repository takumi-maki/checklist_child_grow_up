import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0,
        centerTitle: true, systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Icon(Icons.error_outline_rounded, color: Colors.black54),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(text),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
