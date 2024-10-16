import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:f3/components/MyTextField.dart';
import 'package:f3/components/admin_drawer.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController instockController = TextEditingController();
  final ImagePicker _picker = ImagePicker();


  String? selectedCategory;
  File? _selectedImage;
  String? _imageUrl;
  String? selectedFoodType;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images/${DateTime.now().microsecondsSinceEpoch}');
      await storageRef.putFile(image);

      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading image :$e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const AdminDrawer(),
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        final products = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ListTile(
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.deepOrange, width: 6),
                                  borderRadius: BorderRadius.circular(12)),
                              title: Text(product['Name']),
                              subtitle: Text(product['description']),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.deepOrange,
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('products')
                                      .doc(product.id)
                                      .delete();
                                },
                              ),
                              onTap: () {
                                nameController.text = product['Name'];
                                priceController.text =
                                    product['price'].toString();
                                amountController.text =
                                    product['amount'].toString();
                                descriptionController.text =
                                    product['description'];
                                instockController.text =
                                    product['in stock'].toString();
                                weightController.text =
                                    product['weight'].toString();
                                // Set the selectedCategory to the current category of the product
                                selectedCategory = product['category'];
                                selectedFoodType=product['foodType'];
                                _imageUrl = product['imageUrl'];

                                // Show the edit dialog
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    // Create a local variable to track selected category in the dialog
                                    String? localSelectedCategory =
                                        selectedCategory;
                                      String? localSelectedFoodType=selectedFoodType;
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          title: const Text('Edit Product'),
                                          content: SizedBox(
                                            height: 300,
                                            width: 300,
                                            child: ListView(
                                              children: [
                                                Mytextfield(
                                                  controller: nameController,
                                                  icon: Icons.title,
                                                  hintText: 'Add Name',
                                                  obscureText: false,
                                                ),
                                                const SizedBox(height: 10,),
                                                Mytextfield(
                                                  controller: priceController,
                                                  icon: Icons.monetization_on,
                                                  hintText: 'Add Price',
                                                  obscureText: false,
                                                ),
                                                const SizedBox(height: 10,),
                                                Mytextfield(
                                                  controller:
                                                      amountController,
                                                  icon: Icons
                                                      .format_list_numbered,
                                                  hintText: 'Add Amount',
                                                  obscureText: false,
                                                ),
                                                const SizedBox(height: 10,),
                                                Mytextfield(
                                                  controller:
                                                      descriptionController,
                                                  icon: Icons.description,
                                                  hintText: 'Add Description',
                                                  obscureText: false,
                                                ),
                                                const SizedBox(height: 10,),
                                                Mytextfield(
                                                  controller:
                                                      instockController,
                                                  icon: Icons.check_box,
                                                  hintText:
                                                      'In Stock (true/false)',
                                                  obscureText: false,
                                                ),
                                                const SizedBox(height: 10,),
                                                Mytextfield(
                                                  controller:
                                                      weightController,
                                                  icon: Icons.scale,
                                                  hintText: 'Weight (KG)',
                                                  obscureText: false,
                                                ),
                                                const SizedBox(height: 10,),
                                                ElevatedButton(
                                                    onPressed: _pickImage,
                                                    child:
                                                        const Text('pick image')),
                                                if (_selectedImage != null)
                                                  Image.file(
                                                    _selectedImage!,
                                                    height: 100,
                                                  ),
                                                if (_imageUrl != null)
                                                  Image.network(
                                                    _imageUrl!,
                                                    height: 100,
                                                  ),
                                                // Category dropdown
                                                StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'categories')
                                                      .snapshots(),
                                                  builder:
                                                      (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return const CircularProgressIndicator();
                                                    }
                                                    final categories =
                                                        snapshot.data!.docs;

                                                    return DropdownButton<
                                                        String>(
                                                      hint: const Text(
                                                          'Select Category'),
                                                      value:
                                                          localSelectedCategory, // Set local state as the value
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          localSelectedCategory =
                                                              newValue!;
                                                        });
                                                      },
                                                      items: categories
                                                          .map((category) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: category[
                                                              'name'],
                                                          child: Text(
                                                              category[
                                                                  'name']),
                                                        );
                                                      }).toList(),
                                                    );
                                                  },
                                                ),
                                                StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore.instance
                                                      .collection('foodTypes')
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return const CircularProgressIndicator();
                                                    }
                                                    final foodTypes = snapshot.data!.docs;

                                                    return DropdownButton<String>(
                                                      hint: const Text('Select Food Type'),
                                                      value: localSelectedFoodType,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          localSelectedFoodType = newValue!;
                                                        });
                                                      },
                                                      items: foodTypes.map((type) {
                                                        return DropdownMenuItem<String>(
                                                          value: type['name'],
                                                          child: Text(type['name']),
                                                        );
                                                      }).toList(),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                if (_selectedImage != null) {
                                                  _imageUrl =
                                                      await _uploadImage(
                                                          _selectedImage!);
                                                }
                                                // Save the changes, including the selected category
                                                FirebaseFirestore.instance
                                                    .collection('products')
                                                    .doc(product.id)
                                                    .update({
                                                  'Name': nameController.text,
                                                  'price': double.parse(
                                                      priceController.text),
                                                  'amount': int.parse(
                                                      amountController.text),
                                                  'description':
                                                      descriptionController
                                                          .text,
                                                  'in stock': instockController
                                                          .text
                                                          .toLowerCase() ==
                                                      'true',
                                                  'weight': double.parse(
                                                      weightController.text),
                                                  'category':
                                                      localSelectedCategory,
                                                  'foodType':localSelectedFoodType,
                                                  'imageUrl':
                                                      _imageUrl, // Save the locally selected category
                                                });

                                                // Update global selected category
                                                selectedCategory =
                                                    localSelectedCategory;
                                                selectedFoodType=localSelectedFoodType;

                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    nameController.clear();
                    priceController.clear();
                    amountController.clear();
                    weightController.clear();
                    instockController.clear();
                    descriptionController.clear();
                    selectedCategory = null;
                    selectedFoodType = null;
                    _selectedImage = null;
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        scrollable: true,
                        title: const Text('Add Product'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(labelText: 'Name'),
                              ),
                              TextField(
                                controller: priceController,
                                decoration:
                                    const InputDecoration(labelText: 'Price (EGP)'),
                              ),
                              TextField(
                                controller: amountController,
                                decoration:
                                    const InputDecoration(labelText: 'Amount'),
                              ),
                              TextField(
                                controller: descriptionController,
                                decoration:
                                    const InputDecoration(labelText: 'Description'),
                              ),
                              TextField(
                                controller: instockController,
                                decoration: const InputDecoration(
                                    labelText: 'In Stock (true/false)'),
                              ),
                              TextField(
                                controller: weightController,
                                decoration:
                                    const InputDecoration(labelText: 'Weight'),
                              ),
                              ElevatedButton(
                                onPressed: _pickImage,
                                child: const Text('Pick Image'),
                              ),
                              if (_selectedImage != null)
                                Image.file(
                                  _selectedImage!,
                                  height: 100,
                                ),
                              // Category dropdown when adding new product
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('categories')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }
                                  final categories = snapshot.data!.docs;

                                  return DropdownButton<String>(
                                    hint: const Text('Select Type'),
                                    value: selectedCategory,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedCategory = newValue!;
                                      });
                                    },
                                    items: categories.map((category) {
                                      return DropdownMenuItem<String>(
                                        value: category['name'],
                                        child: Text(category['name']),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('foodType') // Collection for food types
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }
                                  final foodTypes = snapshot.data!.docs;

                                  return DropdownButton<String>(
                                    hint: const Text('Select Food Type'),
                                    value: selectedFoodType,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedFoodType = newValue!;
                                      });
                                    },
                                    items: foodTypes.map((type) {
                                      String imageUrl = type['parentImage']; // Get the image URL

                                      return DropdownMenuItem<String>(
                                        value: type['name'],
                                        child: Text(type['name']),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              String? imageUrl;
                              if (_selectedImage != null) {
                                imageUrl = await _uploadImage(_selectedImage!);
                              }
                              FirebaseFirestore.instance
                                  .collection('products')
                                  .add({
                                'Name': nameController.text,
                                'price': double.parse(priceController.text),
                                'amount': int.parse(amountController.text),
                                'description': descriptionController.text,
                                'in stock':
                                    instockController.text.toLowerCase() ==
                                        'true',
                                'weight': double.parse(weightController.text),
                                'category': selectedCategory,
                                'foodType':selectedFoodType,
                                'imageUrl': imageUrl,
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
