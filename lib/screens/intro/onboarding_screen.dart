import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9775FA), // خلفية بنفسجية
      body: PageView(
        controller: _controller,
        children: [
          // الشاشة 1: اللوجو فقط
          const Center(child: Icon(Icons.flash_on, size: 100, color: Colors.white)), 
          
          // الشاشة 2: الصورة والنصوص (كما في التصميم)
          Container(
            color: const Color(0xFF9775FA),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Image.network("https://i.imgur.com/CGCyp1d.png", fit: BoxFit.cover)), // صورة تعبيرية
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      const Text("Look Good, Feel Good", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const Text("Create your individual & unique style and look amazing everyday.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200]), child: const Text("Men", style: TextStyle(color: Colors.grey)))),
                          const SizedBox(width: 10),
                          Expanded(child: ElevatedButton(onPressed: () => Navigator.pushReplacementNamed(context, '/login'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9775FA)), child: const Text("Women", style: TextStyle(color: Colors.white)))),
                        ],
                      ),
                      TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/login'), child: const Text("Skip", style: TextStyle(color: Colors.grey)))
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}