import '../Provider/cart_model.dart';

class Total{
  final CartModel cartModel;

  Total({required this.cartModel});

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in cartModel.cartItems ?? []) {
      totalPrice += item['price'] ?? 0;
    }
    return totalPrice;
  }
}