import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f3/components/my_drawer.dart';
import 'package:f3/components/no_user.dart';
import 'package:f3/components/text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection('users');

  // Edit field
  Future<void> editField(String field) async {
    String newvalue = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.deepOrange),
        ),
        content: TextField(
          autofocus: false,
          style: const TextStyle(color: Colors.deepOrange),
          decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: const TextStyle(color: Colors.grey)),
          onChanged: (value) {
            newvalue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.deepOrange),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(newvalue),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.deepOrange),
            ),
          ),
        ],
      ),
    );

    if (newvalue.trim().isNotEmpty) {
      await userCollection.doc(currentUser!.email).update({field: newvalue});
    }
  }

  @override
  Widget build(BuildContext context) {
    if(currentUser==null||currentUser!.isAnonymous){
      return NoUser();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.logout,color: Colors.white,),
        onPressed: ()async{
          await FirebaseAuth.instance.signOut();
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        },
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.deepOrange,
        title: const Center(
          child: Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ListView(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 72,
                      color: Colors.deepOrange,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        currentUser!.email.toString(),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      'My Details',
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    MyTextBox(
                      text: userData['username'],
                      sectionName: 'User Name',
                      onPressed: () => editField('username'),
                    ),
                    MyTextBox(
                      text: userData['phonenumber'],
                      sectionName: 'Phone number',
                      onPressed: () => editField('phonenumber'),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Previous Orders',
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(height: 10),

                    // StreamBuilder to fetch previous orders
                    StreamBuilder<QuerySnapshot>(
                      stream: userCollection
                          .doc(currentUser!.email)
                          .collection('previous_orders')
                          .snapshots(), // Assuming 'previous_orders' is a subcollection
                      builder: (context, orderSnapshot) {
                        if (orderSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (orderSnapshot.hasError) {
                          return Center(
                            child: Text('Error: ${orderSnapshot.error}'),
                          );
                        }
                        if (!orderSnapshot.hasData ||
                            orderSnapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('No previous orders found'),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final order = orderSnapshot.data!.docs[index];
                            final orderData =
                            order.data() as Map<String, dynamic>;
                            final List<dynamic> items =
                                orderData['items'] ?? [];

                            final Timestamp timestamp =
                                orderData['date'] ?? Timestamp.now();
                            final DateTime date = timestamp.toDate();
                            final String formattedDate =
                                '${date.day}-${date.month}-${date.year}';
                            final String foramttedTime =
                                '${date.hour}:${date.minute.toString().padLeft(2,'0')}';

                            return Padding(
                              padding: const EdgeInsets.all(12),
                              child: Material(
                                borderRadius: BorderRadius.circular(12),
                                elevation: 4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: ExpansionTile(
                                    collapsedIconColor: Colors.white,
                                    title: Text('Order #$index'),
                                    subtitle: Text(
                                      'Total Price: \$${orderData['totalPrice']?.toString() ?? 'N/A'}\n'
                                          'Date: $formattedDate\n'
                                          'Time: $foramttedTime',
                                    ),
                                    backgroundColor: Colors.grey,
                                    collapsedBackgroundColor: Colors.grey[350],
                                    children: items.map((item) {
                                      return ListTile(
                                        title: Text(
                                            item['Name'] ?? 'UN named product'),
                                        subtitle: Text(
                                            'price: ${item['price']?.toString() ?? 'N\A'}'),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
