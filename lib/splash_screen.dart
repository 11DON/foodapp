import 'dart:async';
import 'package:f3/Auth.dart';
import 'package:f3/components/main_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      _checkAuthStatus();

    });
  }

  Future<void> _checkAuthStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    // If no user is logged in, log in anonymously
    if (user == null) {
      try {
        await FirebaseAuth.instance.signInAnonymously();
        user = FirebaseAuth.instance.currentUser; // Update user variable after login
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging in anonymously: $e')),
        );
        // Optionally navigate to AuthPage if there is an error
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
        return; // Exit early if there's an error
      }
    }

    // Navigate to MainWrapper if the user is logged in
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainWrapper()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/A.png',
                    scale: 1,
                  ),
                  const Text(
                    'Fresh from Farm to Fork',
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'AguafinaScript',
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
