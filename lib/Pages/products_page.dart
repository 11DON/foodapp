import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f3/components/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/cart_model.dart';


class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // Map to hold category data
  Map<String, String> _categoryImages = {};
  final List<Map<String, dynamic>> _cartItems = [];
  final ScrollController _scrollController = ScrollController();

  // Function to fetch categories and their associated images
  Future<void> _fetchCategories() async {
    final categoriesSnapshot =
        await FirebaseFirestore.instance.collection('categories').get();

    // Map category name to its image URL
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
    final cart = Provider.of<CartModel>(context);
    return const Scaffold(
      backgroundColor: Colors.white,
      drawerScrimColor: Colors.deepOrange,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: ProductGrid()
        ),
      ),
    );
  }
}
