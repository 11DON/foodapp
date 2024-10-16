import 'package:f3/Pages/admin_page.dart';
import 'package:f3/components/main_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show loading indicator while checking the auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // User is logged in
          if (snapshot.hasData) {
            User? user = snapshot.data;
            // Check if the logged-in user is the admin
            if (user != null && user.email == 'foodappowner8@gmail.com') {
              return const AdminPage();
            } else {
              return const MainWrapper();
            }
          } else {
            // No user is logged in, sign in anonymously
            _signInAnonymously();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  // Function to handle anonymous sign-in
  Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      // Handle any sign-in errors here if needed
      debugPrint('Error signing in anonymously: $e');
    }
  }
}
