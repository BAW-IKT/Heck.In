import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Confirm"),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("first_time_launch", "false");
            
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WebViewPage()),
            );
          },
        ),
      ),
    );
  }
}