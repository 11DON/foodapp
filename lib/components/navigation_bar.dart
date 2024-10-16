import 'package:f3/Pages/categories.dart';
import 'package:flutter/material.dart';
import 'package:f3/Pages/products_page.dart';
import 'package:f3/Pages/my_cart_page.dart';
import 'package:f3/Pages/profile_page.dart';
import 'package:f3/Pages/settings_page.dart';

import '../Pages/profle_page.dart';
import 'my_navigation_bar.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    ProductsPage(),
    MyCartPage(),
    SettingsPage(),
    ProflePage(),
    Categories()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: myNavigationBar(_selectedIndex, _navigateBottomBar),
    );
  }
}
