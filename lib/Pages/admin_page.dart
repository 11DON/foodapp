import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f3/components/admin_drawer.dart';
import 'package:flutter/material.dart';


class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin page'
        ),
      ),
      drawer: const AdminDrawer(
      ),
      backgroundColor: Colors.white70,
      body: 
      Center(
        child: 
        SafeArea(
          child: 
          Padding(
            padding: const EdgeInsets.all(12),
            child: 
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No products available'));
                }

                final products = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.deepOrange, width: 6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(product['Name']),
                        subtitle: Text(product['description']),
                        trailing: product['imageUrl'] != null
                            ? Image.network(
                          product['imageUrl'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                            : null, // Handle cases where imageUrl is null
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      )
    );
  }
}
