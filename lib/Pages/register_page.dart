import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f3/Pages/login_page.dart';
import 'package:f3/components/MyButton.dart';
import 'package:f3/components/MyTextField.dart';
import 'package:f3/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? verifid;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmpassController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void signUp() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    // maker sure passwords match
    if (passwordController.text != confirmpassController.text) {
      //pop loading cirvle
      Navigator.pop(context);
      //show error message
      displayMessage("passwords don't match!", Colors.red);
      return;
    }

    //try creating the user
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      FirebaseAuth.instance.currentUser!.sendEmailVerification();

      User? user = userCredential.user;
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.email)
          .set({
        'username': userNameController.text,
        'email': emailController.text,
        'phonenumber': phoneController.text,
      });
      if (user != null) {
        await user.updateDisplayName(userNameController.text);
        await user.reload();
      }
      if (context.mounted) {
        Navigator.pop(context);
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));

      userNameController.clear();
      passwordController.clear();
      emailController.clear();
      phoneController.clear();
      confirmpassController.clear();
      displayMessage('check your inbox to verify your email', Colors.green);
    } on FirebaseAuthException {
      //pop loading circle
      if (context.mounted) {
        Navigator.pop(context);
      }
      displayMessage('Invalid Email Address', Colors.red);
      //show error to user
    }
  }

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
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ListView(
              children: [
                Column(
                  children: [
                    Image.asset('images/A.png'),
                    Mytextfield(
                        controller: userNameController,
                        icon: Icons.face,
                        hintText: 'Enter Username',
                        obscureText: false),
                    const SizedBox(
                      height: 30,
                    ),
                    Mytextfield(
                        controller: phoneController,
                        icon: Icons.phone,
                        hintText: 'Enter Phone Number',
                        obscureText: false),
                    const SizedBox(
                      height: 30,
                    ),
                    // Mybutton(
                    //     color: Colors.deepOrange,
                    //     onTap: () async {
                    //       FirebaseAuth.instance.verifyPhoneNumber(
                    //         phoneNumber: '+2'+phoneController.text,
                    //         verificationCompleted: (PhoneAuthCredential credential) {},
                    //         verificationFailed: (FirebaseAuthException e) {
                    //           setState(() {
                    //             displayMessage(e.code);
                    //           });
                    //         },
                    //         codeSent:
                    //             (verificationId, forceResendingToken) async {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => OtpPage(
                    //                   verificationid: verificationId,
                    //                 )),
                    //           );
                    //           String smsCode = 'xxxx';
                    //           PhoneAuthCredential credential =
                    //           PhoneAuthProvider.credential(
                    //               verificationId: verificationId,
                    //               smsCode: smsCode);
                    //           await auth.signInWithCredential(credential);
                    //         },
                    //         codeAutoRetrievalTimeout: (verificationId) {
                    //           displayMessage("auto Retrival timeout");
                    //         },
                    //       );
                    //     },
                    //     text: "Send OTP",
                    //     IconColor: Colors.deepOrange,
                    //     TextColor: Colors.white),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // const Text(
                    //   "or",
                    //   style: TextStyle(
                    //       color: Colors.deepOrange,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 18),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Mytextfield(
                        controller: emailController,
                        icon: Icons.email,
                        hintText: 'Enter Email',
                        obscureText: false),
                    const SizedBox(
                      height: 30,
                    ),
                    Mytextfield(
                        controller: passwordController,
                        icon: Icons.lock,
                        hintText: 'Enter password',
                        obscureText: false),
                    const SizedBox(
                      height: 30,
                    ),
                    Mytextfield(
                        controller: confirmpassController,
                        icon: Icons.face,
                        hintText: 'confirm password',
                        obscureText: false),
                    const SizedBox(
                      height: 20,
                    ),
                    Mybutton(
                        color: Colors.deepOrange,
                        onTap: signUp,
                        text: "Sign up",
                        IconColor: Colors.deepOrange,
                        TextColor: Colors.white),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already a User?',
                          style:
                              TextStyle(color: Colors.deepOrange, fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(onTap: () {}),
                              ),
                            );
                          },
                          child: const Text(
                            " log in",
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
