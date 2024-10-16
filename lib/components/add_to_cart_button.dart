import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  const AddToCartButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)
        ),
        child:  Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text,
                  style: const TextStyle(
                      color: Colors.deepOrange,fontSize: 14),)
                ],
            ),
          ),
        ),
      ),
    );
  }
}
