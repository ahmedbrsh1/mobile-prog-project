import 'package:flutter/material.dart';

class SocialAuthScreen extends StatelessWidget {
  const SocialAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              "Let's Get Started",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            
            // أزرار السوشيال
            _buildSocialButton("Facebook", Colors.blue[900]!, Icons.facebook),
            const SizedBox(height: 15),
            _buildSocialButton("Twitter", Colors.blue[400]!, Icons.flutter_dash), // استخدمت ايقونة تقريبية
            const SizedBox(height: 15),
            _buildSocialButton("Google", Colors.red[600]!, Icons.g_mobiledata),

            const Spacer(),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    // الذهاب لصفحة تسجيل الدخول القديمة
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text("Signin", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9775FA))),
                )
              ],
            ),
            const SizedBox(height: 20),
            
            // زر إنشاء حساب
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9775FA), // بنفسجي
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // الذهاب لصفحة إنشاء حساب القديمة
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text("Create an Account", style: TextStyle(color: Colors.white, fontSize: 17)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}