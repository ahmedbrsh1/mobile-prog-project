import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  String? _error;

  Future<void> _signUp() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // 1. Create user in Firebase Auth
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      final User? user = userCredential.user;
      if (user == null)
        throw FirebaseAuthException(
          code: 'USER_NULL',
          message: 'User creation failed',
        );

      // 2. Store minimal user data in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Sign Up",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),

            // Username field (ignored for testing)
            TextFormField(
              controller: _usernameController,
              key: const Key('usernameField'),
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 20),

            // Email field with key
            TextFormField(
              controller: _emailController,
              key: const Key('emailField'),
              decoration: const InputDecoration(labelText: "Email Address"),
            ),
            const SizedBox(height: 20),

            // Password field with key
            TextFormField(
              controller: _passwordController,
              key: const Key('passwordField'),
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),

            const SizedBox(height: 10),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            const Spacer(),

            // Sign Up button with key
            SizedBox(
              width: double.infinity,
              height: 50,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      key: const Key('signupButton'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9775FA),
                      ),
                      onPressed: _signUp,
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
