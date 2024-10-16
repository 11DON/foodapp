import 'package:dio/dio.dart';
import 'Constants.dart';

class PaymobManager {
  Future<String> getPaymentKey(int amount, String currency) async {
    try {
      String authToken = await _getAuthToken();
      int orderId = await _getOrderId(
        authToken: authToken,
        amount: (100 * amount).toString(), // Convert to cents
        currency: currency,
      );
      String paymentKey = await _getPaymentKey(
        authToken: authToken,
        orderId: orderId.toString(),
        amount: (100 * amount).toString(),
        currency: currency,
      );
      return paymentKey;
    } catch (e) {
      print("Exception caught in getPaymentKey: $e");
      rethrow; // Re-throw to maintain the original error behavior
    }
  }

  Future<String> _getAuthToken() async {
    final Response response = await Dio().post(
      "https://accept.paymob.com/api/auth/tokens",
      data: {
        "api_key": kConstants.apikey,
      },
    );
    return response.data['token'] ?? ''; // Ensure a valid return
  }

  Future<int> _getOrderId({
    required String authToken,
    required String amount,
    required String currency,
  }) async {
    final Response response = await Dio().post(
      "https://accept.paymob.com/api/ecommerce/orders", // Corrected URL
      data: {
        "auth_token": authToken,
        "amount_cents": amount,
        "currency": currency,
        "delivery_needed": "false",
        "items": [],
      },
    );
    return response.data['id'] ?? 0; // Ensure a valid return
  }

  Future<String> _getPaymentKey({
    required String authToken,
    required String orderId,
    required String amount,
    required String currency,
  }) async {
    final Response response = await Dio().post(
      "https://accept.paymob.com/api/acceptance/payment_keys",
      data: {
        "expiration": 3600,
        "auth_token": authToken,
        "order_id": orderId,
        "integration_id": kConstants.cardIntg,
        "amount_cents": amount,
        "currency": currency,
        "billing_data": {
          "first_name": "Ammar",
          "last_name": "Sadek",
          "email": "AmmarSadek@gmail.com",
          "phone_number": "+96824480228",
          "apartment": "NA",
          "floor": "NA",
          "street": "NA",
          "building": "NA",
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "NA",
          "country": "NA",
          "state": "NA",
        },
      },
    );
    return response.data['token'] ?? ''; // Ensure a valid return
  }
}
