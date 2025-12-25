import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat(); 

    Timer(const Duration(seconds: 3), () {
      _checkUserLogin();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkUserLogin() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
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
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * pi,
                  child: CustomPaint(
                    size: const Size(100, 100),
                    painter: AtomLogoPainter(),
                  ),
                );
              },
            ),
            // --------------------------------------

            const SizedBox(height: 30),

            const Text(
              "LAZA",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900, 
                letterSpacing: 4, 
                fontFamily: 'Arial',  
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AtomLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke   
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round; 

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    
    // نصف القطر
    final double radiusX = size.width * 0.5; // عرض الحلقة
    final double radiusY = size.height * 0.25; // ارتفاع الحلقة (بيضوي)

    for (int i = 0; i < 3; i++) {
      canvas.save();
      // تدوير الرسمة حول المركز
      canvas.translate(centerX, centerY);
      canvas.rotate((pi / 1.5) * i); // الدوران بزاوية 60 درجة (120/2)
      
      // رسم الشكل البيضاوي
      final Rect oval = Rect.fromCenter(
        center: Offset.zero, 
        width: radiusX * 2, 
        height: radiusY * 2
      );
      canvas.drawOval(oval, paint);
      
      canvas.restore();
    }

    // رسم النواة (نقطة صلبة في المنتصف)
    final Paint corePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
      
    canvas.drawCircle(Offset(centerX, centerY), 8.0, corePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // لا نحتاج لإعادة الرسم إلا عند الدوران
  }
}
