import 'package:f3/Pages/register_page.dart';
import 'package:f3/components/MyButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NoUser extends StatefulWidget {
  const NoUser({super.key});

  @override
  State<NoUser> createState() => _NoUserState();
}

class _NoUserState extends State<NoUser> {
  @override
  Widget build(BuildContext context) {
   final currentuser=FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Center(
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sign up to accses more features',style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange
                ),),
                SizedBox(height: 10,),
                Mybutton(
                    color: Colors.deepOrange,
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
                    },
                    text: 'Signup',
                    IconColor: Colors.white,
                    TextColor: Colors.white
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}
