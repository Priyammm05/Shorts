// ignore_for_file: must_call_super

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shorts/view/screens/auth/login_screen.dart';
import 'package:shorts/view/widgets/glitch.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "images/shorts-logo.png",
              height: size.height * 0.3,
            ),
          ),
          const SizedBox(height: 35),
          GlitchEffect(
            child: const Text(
              'SHORTS',
              style: TextStyle(
                fontSize: 55,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
