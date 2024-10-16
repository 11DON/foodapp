import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f3/Pages/my_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/cart_model.dart';

class LoyaltyPoints extends StatefulWidget {
  const LoyaltyPoints({super.key});

  @override
  State<LoyaltyPoints> createState() => _LoyaltyPointsState();
}

class _LoyaltyPointsState extends State<LoyaltyPoints> {
  Map<String, String> _categoryImages = {};
  final List<Map<String, dynamic>> _cartItems = []; // Hold cart items

  Future<void> _fetchCategories() async {
    final categoriesSnapshot =
    await FirebaseFirestore.instance.collection('categories').get();

    setState(() {
      _categoryImages = {
        for (var doc in categoriesSnapshot.docs)
          doc['name']: doc['imageUrl'] ?? ''
      };
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Fetch categories once when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartModel>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Pass cartItems to MyCartPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyCartPage(),
            ),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text('Loyalty Points'),
      ),

    );
  }
}
