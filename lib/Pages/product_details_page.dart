import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f3/Pages/products_page.dart';
import 'package:f3/components/main_wrapper.dart';
import 'package:f3/components/prodcut_details_text.dart';
import 'package:f3/components/text_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/cart_model.dart';
import '../components/language_constants.dart';

class ProductDetailsPage extends StatefulWidget {
  final DocumentSnapshot product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Map<String, String> _categoryImages = {};
  List<String> _preparationOptions = []; // To store preparation options
  Map<String, bool> _selectedPreparationOptions = {}; // To track selected options

  // Fetch category images from Firestore
  Future<void> _fetchCategories() async {
    final categoriesSnapshot = await FirebaseFirestore.instance.collection('categories').get();

    setState(() {
      _categoryImages = {
        for (var doc in categoriesSnapshot.docs) doc['name']: doc['imageUrl'] ?? '',
      };
    });
  }

  // Fetch preparation options from Firestore
  Future<void> _fetchPreparationOptions() async {
    final preparationSnapshot = await FirebaseFirestore.instance.collection('preparationOptions').get();

    setState(() {
      _preparationOptions = preparationSnapshot.docs.map((doc) => doc['name'] as String).toList();
      // Initialize selected preparation options
      for (var option in _preparationOptions) {
        _selectedPreparationOptions[option] = false; // Set all to false initially
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Fetch category images when the widget initializes
    _fetchPreparationOptions(); // Fetch preparation options
  }

  @override
  Widget build(BuildContext context) {
    final String category = widget.product['category'] ?? 'Unknown';
    final String? categoryImageUrl = _categoryImages[category];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.home, color: Colors.white),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainWrapper()));
        },
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView(
              children: [
                // The food image
                categoryImageUrl != null && categoryImageUrl.isNotEmpty
                    ? Image.network(
                  categoryImageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child; // Image is loaded
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 250); // Fallback for errors
                  },
                )
                    : const Icon(Icons.image_not_supported, size: 250), // Fallback for missing image

                const SizedBox(height: 5),
                // Product Name
                ProductDetailsText(text: '${widget.product['Name'] ?? 'No Name'}', sectionName: 'Product Name'),

                // Food description
                ProductDetailsText(text: '${widget.product['description'] ?? 'No description available'}', sectionName: 'Description'),

                // Food category
                ProductDetailsText(text: '$category', sectionName: 'Category'),

                // Price
                ProductDetailsText(text: '${widget.product['price'] ?? 'No price available'}', sectionName: 'Price'),

                // Weight
                ProductDetailsText(text: '${widget.product['weight'] ?? 'No weight available'}', sectionName: 'Weight'),

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Consumer<CartModel>(
                    builder: (context, cart, child) {
                      return GestureDetector(
                        onTap: () {
                          cart.addItem({
                            'Name': widget.product['Name'],
                            'price': widget.product['price'],
                            'imageUrl': widget.product['imageUrl'],
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(translation(context).itemadded),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'EGP ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    widget.product['price']?.toString() ?? 'N/A',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
