import 'package:flutter/material.dart';

class PaymentMethod extends StatefulWidget {
  final Function (String) onPaymentMethodChanged;
  const PaymentMethod({super.key, required this.onPaymentMethodChanged});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String _selectedPaymentMethod = 'Cash';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Cash'),
          leading: Radio<String>(
            value: 'Cash',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
                widget.onPaymentMethodChanged(_selectedPaymentMethod);
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Card'),
          leading: Radio<String>(
            value: 'Card',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
                widget.onPaymentMethodChanged(_selectedPaymentMethod);
              });
            },
          ),
        ),
      ],
    );
  }
}
