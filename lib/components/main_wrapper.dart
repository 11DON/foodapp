import 'package:f3/Pages/categories.dart';
import 'package:f3/Pages/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:f3/Pages/products_page.dart';
import 'package:f3/Pages/my_cart_page.dart';
import 'package:f3/Pages/profile_page.dart';
import 'package:f3/Pages/settings_page.dart';

import '../Pages/profle_page.dart';
import '../components/my_navigation_bar.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper>  {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    Categories(),
    ProductsPage(),
    MyCartPage(),
    SettingsPage(),
    ProfilePage(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: myNavigationBar(_selectedIndex, _navigateBottomBar),
    );
  }
}
