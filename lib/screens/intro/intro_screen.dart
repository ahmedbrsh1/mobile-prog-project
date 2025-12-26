import 'package:flutter/material.dart';
import 'social_auth_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  String selectedGender = "Men";

  final String manImage =
      "https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?q=80&w=1887&auto=format&fit=crop";
  final String womanImage =
      "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=1320&auto=format&fit=crop";

  void _navigateToNext() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SocialAuthScreen()),
    );
  }

  void _handleGenderPress(String gender) {
    if (selectedGender == gender) {
      _navigateToNext();
    } else {
      setState(() {
        selectedGender = gender;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              key: ValueKey<String>(selectedGender),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    selectedGender == "Men" ? manImage : womanImage,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Bottom gradient
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFF9775FA).withOpacity(0.95),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Look Good, Feel Good",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Create your individual & unique style and look amazing everyday.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 30),

                // Men / Women buttons
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        label: 'menButton', // Appium can detect this
                        child: _buildButton(
                          context,
                          "Men",
                          selectedGender == "Men",
                          () => _handleGenderPress("Men"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Semantics(
                        label: 'womenButton',
                        child: _buildButton(
                          context,
                          "Women",
                          selectedGender == "Women",
                          () => _handleGenderPress("Women"),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Skip button (optional, still detected)
                Semantics(
                  label: 'skipButton',
                  child: TextButton(
                    onPressed: _navigateToNext,
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    bool isSelected,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? const Color(0xFF9775FA)
            : Colors.white.withOpacity(0.9),
        foregroundColor: isSelected ? Colors.white : Colors.grey,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
