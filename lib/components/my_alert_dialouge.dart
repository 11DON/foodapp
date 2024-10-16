import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f3/Pages/my_map.dart';
import 'package:f3/Provider/cart_model.dart';
import 'package:f3/components/payment_method.dart';
import 'package:f3/components/total_price.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Pages/checkout_page.dart';
import '../paymob_manager/paymob_manager.dart';

class MyAlertDialog extends StatefulWidget {
  const MyAlertDialog({super.key});

  @override
  State<MyAlertDialog> createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  String _selectedPaymentMethod = 'Cash';
  LatLng? _selectedLocation;
  String _confirmedAddress = '';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return AlertDialog(
      title: const Text(
        'Checkout:',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Await the address and location returned from the map
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeliveryLocationMap()),
                );

                if (result != null && result is Map) {
                  setState(() {
                    _confirmedAddress = result['address']; // Set the confirmed address
                    _selectedLocation = result['location']; // Set the confirmed location
                  });
                }
              },
              child: Text('Select Location'),
            ),
            // Display the confirmed address
            if (_confirmedAddress.isNotEmpty)
              Text(
                'Confirmed Location: $_confirmedAddress',
                style: TextStyle(color: Colors.green),
              ),
            const SizedBox(height: 10),
            const Text('Select payment method:'),
            PaymentMethod(
              onPaymentMethodChanged: (method) {
                setState(() {
                  _selectedPaymentMethod = method;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final total = Total(cartModel: cart).calculateTotalPrice();
            if (_confirmedAddress.isNotEmpty && _selectedLocation != null) {
              // Save order in Firestore
              try {
                final currentUser = FirebaseAuth.instance.currentUser;
                String userId = 'anonymous_${DateTime.now().millisecondsSinceEpoch}';
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('previous_orders')
                    .add({
                  'items': cart.cartItems,
                  'totalPrice': total,
                  'address': _confirmedAddress,
                  'location': {
                    'latitude': _selectedLocation!.latitude,
                    'longitude': _selectedLocation!.longitude,
                  },
                  'date': Timestamp.now(),
                  'paymentMethod': _selectedPaymentMethod,
                });

                if (_selectedPaymentMethod == 'Cash') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        totalprice: total,
                        items: cart.cartItems,
                        address: _confirmedAddress,
                        date: Timestamp.now(),
                      ),
                    ),
                  );
                } else if (_selectedPaymentMethod == 'Card') {
                  await _pay(total, context);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error saving order')));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select a location and confirm the address'),
                ),
              );
            }
          },
          child: const Text(
            'Confirm order',
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pay(double total, BuildContext context) async {
    try {
      final paymentKey = await PaymobManager().getPaymentKey(
          total.toInt(),
          "EGP");
      await launchUrl(Uri.parse(
          "https://accept.paymob.com/api/acceptance/iframes/871112?payment_token=$paymentKey"));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment error: $e')),
      );
    }
  }
}
