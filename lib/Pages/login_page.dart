import 'package:f3/Pages/admin_page.dart';
import 'package:f3/Pages/products_page.dart';
import 'package:f3/Pages/register_page.dart';
import 'package:f3/components/MyButton.dart';
import 'package:f3/components/MyTextField.dart';
import 'package:f3/components/language_constants.dart';
import 'package:f3/components/main_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn() async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (context.mounted) {
        Navigator.pop(context); // Pop loading circle
      }

      User? user = userCredential.user;

      if (user != null) {
        if (user.email == 'foodappowner8@gmail.com') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminPage()),
          );
        } else if (user.emailVerified) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const MainWrapper()));
        } else {
          displayMessage('Please verify your email', Colors.red);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const LoginPage()));
        }
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Pop loading circle
      }
      displayMessage('Invalid email or password: ${e.message}', Colors.red);
    }
  }

  // Sign in as a guest
  Future<void> signInAsGuest() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Check if there's already a logged-in user (anonymous or authenticated)
    if (currentUser != null) {
      if (currentUser.isAnonymous) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainWrapper()),
        );
      } else {
        displayMessage('You are already logged in with an authenticated account.', Colors.orange);
      }
    } else {
      // If no user is logged in, create a new anonymous user
      try {
        await FirebaseAuth.instance.signInAnonymously();

        // Save the anonymous user state
        await rememberAnonymousUser();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainWrapper()),
        );
      } catch (e) {
        displayMessage('Error signing in as guest: ${e.toString()}', Colors.red);
      }
    }
  }

// Method to save anonymous user state
  Future<void> rememberAnonymousUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAnonymousUser', true);
  }

  // Log out the current user
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      displayMessage('Logged out successfully.', Colors.green);
    } catch (e) {
      displayMessage('Error logging out: ${e.toString()}', Colors.red);
    }
  }

  // Display message
  void displayMessage(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 100, 50, 50),
            child: ListView(
              children: [
                Column(
                  children: [
                    // Logo
                    Image.asset(
                      'images/A.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 40),
                    // Email text field
                    Mytextfield(
                        controller: emailController,
                        icon: CupertinoIcons.profile_circled,
                        hintText: translation(context).loginemail,
                        obscureText: false),
                    const SizedBox(height: 20),
                    // Password text field
                    Mytextfield(
                        controller: passwordController,
                        icon: Icons.lock,
                        hintText: translation(context).loginpassword,
                        obscureText: true),
                    const SizedBox(height: 20),
                    // Forgot password
                    GestureDetector(
                      child: Text(
                        translation(context).forgotpassword,
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Sign in button
                    Mybutton(
                        color: Colors.deepOrange,
                        icon: null,
                        onTap: signIn,
                        text: translation(context).signin,
                        IconColor: Colors.white,
                        TextColor: Colors.white),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          translation(context).or,
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Button to navigate to register page
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Row(
                            children: [
                              Text(
                                translation(context).newuser,
                                style: TextStyle(
                                    color: Colors.deepOrange, fontSize: 18),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RegisterPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  translation(context).signup,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Logging in as guest
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            translation(context).orcontinueas,
                            style: TextStyle(
                                color: Colors.deepOrange, fontSize: 18),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: signInAsGuest,
                            child: Text(
                              translation(context).guest,
                              style: TextStyle(color: Colors.blue, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
