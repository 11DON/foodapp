import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f3/Pages/product_details_page.dart';
import 'package:f3/Pages/products_page.dart';
import 'package:f3/components/new_product_grid.dart';
import 'package:f3/components/searchable_widget.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  // Map to hold food type images
  Map<String, String> _foodTypeImages = {};
  List<String> _allFoodTypes = [];

  // Use a Set to avoid duplicates
  Set<String> _productNames = {};
  Map<String, DocumentSnapshot> _productsMap = {}; // Map to hold products

  // Fetch food types and their associated images
  Future<void> _fetchFoodTypes() async {
    try {
      final foodTypesSnapshot = await FirebaseFirestore.instance.collection('foodType').get();
      print('Fetched food types: ${foodTypesSnapshot.docs.length} documents');

      // Map food type name to its image URL
      setState(() {
        _foodTypeImages = {
          for (var doc in foodTypesSnapshot.docs) doc['name']: doc['parentImage'] ?? ''
        };
        _allFoodTypes = _foodTypeImages.keys.toList();
      });
    } catch (e) {
      print('Error fetching food types: $e');
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final productsSnapshot = await FirebaseFirestore.instance.collection('products').get();
      print('Fetched products: ${productsSnapshot.docs.length} documents');
      setState(() {
        for (var doc in productsSnapshot.docs) {
          String productName = doc['Name'];
          _productNames.add(productName); // Add product names to the set
          _productsMap[productName] = doc; // Map product names to their DocumentSnapshots
        }
        _allFoodTypes.addAll(_productNames); // Add products to the food types
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchFoodTypes();
    _fetchProducts(); // Fetch food types and products once when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              SearchableList(
                items: _allFoodTypes,
                getItemText: (item) => item,
                onItemTap: (item) {
                  // Check if the tapped item is a food type or a product
                  if (_foodTypeImages.containsKey(item)) {
                    // Navigate to NewProductGrid for the food type
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewProductGrid(foodType: item),
                      ),
                    );
                  } else if (_productsMap.containsKey(item)) {
                    // Navigate to ProductDetailsPage with the product details
                    final product = _productsMap[item];
                    if (product != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(product: product),
                        ),
                      );
                    }
                  }
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _foodTypeImages.length,
                  itemBuilder: (context, index) {
                    String foodType = _foodTypeImages.keys.elementAt(index);
                    String imageUrl = _foodTypeImages[foodType]!;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewProductGrid(foodType: foodType),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                imageUrl,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(child: Icon(Icons.error)); // Placeholder for error
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  foodType,
                                  style: const TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
