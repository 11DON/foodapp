// import 'package:f3/Pages/products_page.dart';
// import 'package:f3/Pages/loyalty_points.dart';
// import 'package:f3/Pages/my_cart_page.dart';
// import 'package:f3/Pages/profile_page.dart';
// import 'package:f3/Pages/settings_page.dart';
// import 'package:f3/components/My_Drawer_tile.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import 'navigation_bar.dart';
// import '../Pages/profle_page.dart';
//
// class MyDrawer extends StatelessWidget {
//   const MyDrawer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       shadowColor: Colors.deepOrange,
//       backgroundColor: Colors.white70,
//       child: Column(
//         children: [
//           const Padding(padding: EdgeInsets.only(top: 100.0)),
//           const Image(
//             image: AssetImage('images/A.png'),
//             width: 100,
//             height: 100,
//           ),
//           const Padding(
//             padding: EdgeInsets.all(25.0),
//             child: Divider(
//               height: 10,
//               color: Colors.white30,
//             ),
//           ),
//           MyDrawerTile(
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => const HomePage()));
//               },
//               text: 'H O M E',
//               icon: Icons.home),
//           MyDrawerTile(
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => const ProfilePage()));
//               },
//               text: 'P R O F I L E',
//               icon: Icons.face),
//           MyDrawerTile(
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => const LoyaltyPoints()));
//               },
//               text: 'L O Y A L T Y P O I N T S',
//               icon: Icons.loyalty),
//           MyDrawerTile(
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => const MyCartPage()));
//               },
//               text: 'C A R T',
//               icon: Icons.shopping_cart),
//           MyDrawerTile(
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => const SettingsPage()));
//               },
//               text: 'S E T T I N G S',
//               icon: Icons.settings),
//           MyDrawerTile(
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => const MyNavigationBar()));
//               },
//               text: 'newhome',
//               icon: Icons.settings),
//           const Spacer(),
//           MyDrawerTile(
//               onTap: () async {
//                 await FirebaseAuth.instance.signOut();
//                 Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//               },
//               text: 'L O G O U T ',
//               icon: Icons.logout),
//           const SizedBox(
//             height: 25,
//           )
//         ],
//       ),
//     );
//   }
// }
