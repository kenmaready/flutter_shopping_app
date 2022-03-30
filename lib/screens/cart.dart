import 'package:flutter/material.dart';
//
import '../providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Your Blamazon Cart!")),
        body: Column(
          children: [
            Card(
                margin: EdgeInsets.all(12),
                child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(children: [
                      const Text('Total', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 6),
                      const Chip(label: Text("34")),
                    ])))
          ],
        ));
  }
}
