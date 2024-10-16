import 'package:f3/Pages/add_product_page.dart';
import 'package:f3/Pages/admin_page.dart';
import 'package:f3/components/My_Drawer_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: Colors.deepOrange,
      backgroundColor: Colors.white70,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 100.0)),
          const Image(
            image: AssetImage('images/A.png'),
            width: 100,
            height: 100,
          ),
          const Padding(
            padding: EdgeInsets.all(25.0),
            child: Divider(
              height: 10,
              color: Colors.white30,
            ),
          ),
          MyDrawerTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  AdminPage()));
              },
              text: 'I N  S T O C K',
              icon: Icons.inventory),
          MyDrawerTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  AddProductPage()));
              },
              text: 'A D D  P R O D U C T',
              icon: Icons.add),
          const Spacer(),
          MyDrawerTile (
              onTap: () async{
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              },

              text: 'L O G O U T ',
              icon: Icons.logout),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }
}
