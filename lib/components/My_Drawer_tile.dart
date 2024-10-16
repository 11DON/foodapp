import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String text;
  final IconData? icon;
  final  Function()? onTap;
  const MyDrawerTile(
      {super.key, required this.onTap, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile (
      title: Text(text),
      leading: Icon(icon),
      onTap: onTap,
    );
  }
}
