import 'dart:ffi';

import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final String itemName;
  final Int itemPrice;
  final String imagePath;


  const ItemTile({
    super.key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
