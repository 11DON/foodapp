import 'package:flutter/material.dart';
import 'package:f3/Pages/products_page.dart';
import 'package:f3/Pages/my_cart_page.dart';
import 'package:f3/Pages/profile_page.dart';
import 'package:f3/Pages/settings_page.dart';

Widget myNavigationBar(int selectedIndex, Function(int) onTap) {
  return BottomNavigationBar(selectedItemColor: Colors.deepOrange,
    currentIndex: selectedIndex,
    onTap: onTap,
    type: BottomNavigationBarType.fixed,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
      BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Products'),
      BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'My Cart'),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
    ],
  );
}
