import 'package:flutter/material.dart';

class ProductDetailsText extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  const ProductDetailsText(
      {super.key,
        required this.text,
        required this.sectionName,
         this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[500], borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0,13,0,0),
                child: Text(
                  sectionName,
                  style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                ),
              ),

            ],
          ),
          SizedBox(height: 10,),
          Text(text,style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold
          ),),
        ],
      ),
    );
  }
}
