import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final IconData? icon;
  final Color color;
  final Color TextColor;
  final Color IconColor;
  const Mybutton({
    super.key ,
    required this.color,
     this.icon,
    required this.onTap,
    required this.text,
    required this.IconColor,
    required this.TextColor
  });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
              borderRadius: BorderRadius.circular(12)
        ),
        child:  Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if( icon != null) ...[
                  Icon(
                    icon,color: IconColor,
                  ),
                ],
                Text(text,style: const TextStyle(color: Colors.white,fontSize: 14),)

              ],
            ),
          ),
        ),
      ),
    );
  }
}
