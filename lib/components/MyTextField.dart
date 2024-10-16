import 'package:flutter/material.dart';

class Mytextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData icon;
  const Mytextfield(
      {super.key,
      required this.controller,
      required this.icon,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.deepOrange),
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepOrange),
            borderRadius: BorderRadius.circular(12)),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.deepOrange.withOpacity(0.4),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.deepOrange,
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepOrange),
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
