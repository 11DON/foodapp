import 'package:flutter/material.dart';


class CartModel extends ChangeNotifier{
  final List<Map<String,dynamic>> _cartItems=[];
  List<Map<String,dynamic>> get cartItems => _cartItems;

  void addItem(Map<String,dynamic>product){
    _cartItems.add(product);
    notifyListeners();
  }

  void removeItem(int index){
    _cartItems.removeAt(index);
    notifyListeners();
  }
  double getTotalPrice(){
    double total=0;
    for(var item in _cartItems){
      total += item['price'];
    }
    return total;
  }
}