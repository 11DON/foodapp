import 'package:flutter/material.dart';

class MyLocation extends StatelessWidget {
  const MyLocation({super.key});

  void openLocationSearchBox(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Your Location'),
              content: const TextField(
                decoration: InputDecoration(hintText: ('Search address..')),
              ),
              actions: [
                // cancel button
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('cancel'),
                ),
                //save button
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('save'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'deliver now',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => openLocationSearchBox(context),
                child: const Text(
                  '660 hollywood blv',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded),
            ],
          )
        ],
      ),
    );
  }
}
