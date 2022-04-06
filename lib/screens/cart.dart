import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../widgets/cart_item.dart';
import '../providers/orders.dart';
import '../providers/cart.dart';
import '../screens/orders.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
        appBar: AppBar(
            title: Text("Your Blamazon Cart!",
                style: TextStyle(fontFamily: 'PermanentMarker'))),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemBuilder: (ctx, index) =>
                  CartItemWidget(cart.items.values.toList()[index]),
              itemCount: cart.length,
            )),
            SizedBox(height: 10),
            Card(
              margin: EdgeInsets.all(12),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total', style: TextStyle(fontSize: 16)),
                            Spacer(),
                            Text('\$${cart.totalPrice.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16)),
                          ]),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        ElevatedButton(
                          child: Text("Buy That Shit!",
                              style: TextStyle(fontFamily: 'PermanentMarker')),
                          onPressed: () {
                            Provider.of<Orders>(context, listen: false)
                                .placeOrder(cart);
                            // first pop Overview screen to avoid
                            // double-overview issue later
                            Navigator.of(context).pop();
                            // THEN navigate to orders screen to show order
                            // was submitted:
                            Navigator.of(context)
                                .pushReplacementNamed(OrdersScreen.routeName);
                          },
                        )
                      ]),
                    ],
                  )),
              elevation: 12,
            ),
          ],
        ));
  }
}
