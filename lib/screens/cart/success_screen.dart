import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF9775FA), size: 100),
            const SizedBox(height: 20),
            const Text("Order Confirmed!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false), child: const Text("Continue Shopping"))
          ],
        ),
      ),
    );
  }
}