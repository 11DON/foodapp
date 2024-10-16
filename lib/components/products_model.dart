import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String imageUrl; // Add this if you have an image URL field
  final double price;
  final String description; // If you have a description field

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
  });

  factory Product.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'],
      imageUrl: data['imageUrl'],
      price: data['price'],
      description: data['description'],
    );
  }
}
