import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f3/components/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Pages/product_details_page.dart';
import '../Provider/cart_model.dart';

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
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
    return StreamBuilder<QuerySnapshot>(
      stream:
      FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return  Center(child: Text(translation(context).noproductsavalibel));
        }

        final products = snapshot.data!.docs;

        return GridView.builder(
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio:
            0.5, // Adjust this based on your layout needs
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final String category = product['category'];
            final String? categoryImageUrl = _categoryImages[category];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.deepOrange,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsPage(
                        product: product,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: categoryImageUrl != null &&
                          categoryImageUrl.isNotEmpty
                          ? Image.network(
                        categoryImageUrl,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                          : const Icon(
                        Icons.image_not_supported,
                        size: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name
                          Row(
                            children: [
                              Text(
                                translation(context).productName,
                                style: TextStyle(color: Colors.white),
                              ),
                              Flexible(
                                child: Text(
                                  product['Name'] ?? 'Unknown',
                                  style: const TextStyle(
                                      color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Product Weight
                          Row(
                            children: [
                              Text(
                                translation(context).weight,
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                product['weight']?.toString() ?? 'N/A',
                                style:
                                const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Product Price
                          Row(
                            children: [
                              Text(
                                translation(context).price,
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                product['price']?.toString() ?? 'N/A',
                                style:
                                const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Consumer<CartModel>(
                            builder:(context,cart,child) {
                              return GestureDetector(
                                onTap: () {
                                  cart.addItem({
                                    'Name': product['Name'],
                                    'price': product['price'],
                                    'imageUrl': product['imageUrl']
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(translation(context).itemadded),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(12)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'EGP ',
                                            style: TextStyle(
                                                color: Colors.deepOrange),
                                          ),
                                          Text(
                                            product['price']
                                                ?.toString() ??
                                                'N/A',
                                            style: const TextStyle(
                                                color: Colors.deepOrange),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
