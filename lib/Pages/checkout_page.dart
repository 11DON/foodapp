import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f3/components/my_drawer.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  final double? totalprice;
  final List<Map<String, dynamic>>? items;
  final String? address;
  final Timestamp? date;
  const CheckoutPage(
      {super.key, this.totalprice, this.items, this.address, this.date});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepOrange,
        title: const Center(
          child: Text(
            ' Receipt',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Order Details',
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
                Text(
                  'Address :',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(widget.address.toString(),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text('Date: ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text(widget.date!.toDate().toString(),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text('Items :',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ...?widget.items?.map((item) {
                  return Column(
                    children: [
                      Text('${item['Name']}-\$${item['price']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  );
                }).toList(),
                Spacer(),
                Row(
                  children: [
                    Text(
                      'TotalPrice: \$',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(widget.totalprice!.toStringAsFixed(2),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20))
                  ],
                )
              ],
            )),
      ),
    );
  }
}
