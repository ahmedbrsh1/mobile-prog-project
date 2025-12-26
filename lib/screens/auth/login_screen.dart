import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message ?? 'Login failed';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email to reset password.'),
        ),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent! Check your inbox.'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to send reset email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Welcome",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Please enter your data to continue",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 50),

              // Inputs
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email Address"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),

              const SizedBox(height: 20),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: _forgotPassword,
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              const Text(
                "By connecting your account confirm that you agree with our Term and Condition",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9775FA),
                  ),
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text("New here? Create an account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
