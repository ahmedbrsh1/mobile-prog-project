import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // الانتظار 3 ثواني ثم تنفيذ القرار
    Timer(const Duration(seconds: 3), () {
      _checkUserLogin();
    });
  }

  void _checkUserLogin() {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // 1. لو المستخدم مسجل دخول ==> روح للصفحة الرئيسية فوراً
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // 2. لو المستخدم جديد ==> روح لصفحة البداية (Intro - الرجل)
      // (كانت المشكلة هنا أنه يذهب للوجين مباشرة)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IntroScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9775FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // اللوجو
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.flash_on_rounded, // أيقونة اللوجو
                size: 50,
                color: Color(0xFF9775FA),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Laza",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}