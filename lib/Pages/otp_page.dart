//
// import 'package:f3/Pages/products_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../components/MyButton.dart';
// import '../components/MyTextField.dart';
//
//
// class OtpPage extends StatefulWidget {
//   const OtpPage({super.key, required this.verificationid});
//   final String  verificationid;
//
//   @override
//   State<OtpPage> createState() => _OtpPageState();
// }
//
// class _OtpPageState extends State<OtpPage> {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   String? verifid;
//   void displayMessage(String message) {
//     showDialog(
//       context: contextt,
//       builder: (context) => AlertDialog(
//         title: Text(message),
//       ),
//     );
//   }
//
//
//
//
//
//
//   final otpController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       backgroundColor: Colors.white,
//       body:
//       SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: ListView(
//               children:  [
//                 Column(
//                   children: [
//                     Image.asset('images/A.png'),
//                     Mytextfield(
//                         controller: otpController,
//                         icon: Icons.face,
//                         hintText: 'Enter Received OTP',
//                         obscureText: false),
//                     Mybutton(
//                         color: Colors.deepOrange,
//                         icon: null,
//                         onTap: ()async{
//                           try{
//                              final cred = PhoneAuthProvider.credential(
//                                  verificationId: widget.verificationid,
//                                  smsCode: otpController.text);
//
//                              await FirebaseAuth.instance.signInWithCredential(cred);
//                              if(auth.currentUser!=null){
//                                Navigator.push(
//                                    context,
//                                    MaterialPageRoute(builder: (context)=>const ProductsPage())
//                                );
//                              }
//
//                           }catch(e){
//                             displayMessage(e.toString());
//                           }
//                         },
//                         text: 'Sign in',
//                         IconColor: Colors.white,
//                         TextColor: Colors.white),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//
//
//     );
//   }
// }
