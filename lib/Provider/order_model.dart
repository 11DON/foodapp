import 'package:flutter/material.dart';

class OrderModel{
  final String address;
  final List<Map<String,dynamic>> items;
  final double totalPrice;
  final DateTime orderDate;

  OrderModel(
      this.totalPrice, this.orderDate,
      {required this.items,required this.address
      });


  Map<String,dynamic> toMap(){
    return{
      'address':address,
      'items':items,
      'totalprice':totalPrice,
      'orderDate':orderDate.toIso8601String(),
    };
  }
}