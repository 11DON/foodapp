import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f3/Pages/checkout_page.dart';
import 'package:f3/Pages/products_page.dart';
import 'package:f3/Provider/cart_model.dart';
import 'package:f3/components/my_alert_dialouge.dart';
import 'package:f3/components/my_drawer.dart';
import 'package:f3/components/payment_method.dart';
import 'package:f3/components/total_price.dart';
import 'package:f3/paymob_manager/paymob_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/my_navigation_bar.dart';
import 'my_map.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({super.key});

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  // Function to calculate the total price of items in the cart
  double calculateTotalPrice(CartModel cart) {
    double totalPrice = 0;
    for (var item in cart.cartItems ?? []) {
      totalPrice += item['price'] ?? 0;
    }
    return totalPrice;
  }

  String _selectedPaymentMethod = 'Cash';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    return Scaffold(
      body: cart.cartItems.isEmpty
          ? const Center(
        child: Text('No Items in cart'),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartItems.length,
              itemBuilder: (context, index) {
                final product = cart.cartItems[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepOrange, width: 3),
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: product['imageUrl'] != null
                          ? Image.network(product['imageUrl'], width: 50)
                          : const Icon(Icons.image),
                      title: Text(product['Name']),
                      subtitle: Text('Price: \$${product['price']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            cart.cartItems.removeAt(index); // Remove item
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Add the Checkout button with total price at the bottom
          Container(
            child: ListTile(
              title: Text(
                  'Total: EGP ${calculateTotalPrice(cart).toStringAsFixed(2)}'),
              trailing: ElevatedButton(
                onPressed: () {
                  showDialog(context: context, builder: (context)=>MyAlertDialog());
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange),
                child: const Text(
                  'Checkout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


}
