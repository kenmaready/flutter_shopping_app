import 'package:flutter_shopping_app/widgets/error_alert.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../widgets/error_alert.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';
import '../providers/cart.dart';
import '../screens/orders.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = "/cart";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  void setLoading() {
    setState(() => _isLoading = true);
  }

  void setNotLoading() {
    setState(() => _isLoading = false);
  }

  void _handleOrder(BuildContext context) async {
    setLoading();
    try {
      await Provider.of<Orders>(context, listen: false)
          .placeOrder(Provider.of<Cart>(context, listen: false));
      // first pop Overview screen to avoid
      // double-overview issue later
      Navigator.of(context).pop();
      // THEN navigate to orders screen to show order
      // was submitted:
      Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
    } catch (error) {
      showDialog(
          context: context,
          builder: (ctx) => ErrorAlert(actionName: 'ordering'));
    } finally {
      setNotLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
        appBar: AppBar(
            title: Text("Your Blamazon Cart!",
                style: TextStyle(fontFamily: 'PermanentMarker'))),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total',
                                      style: TextStyle(fontSize: 16)),
                                  Spacer(),
                                  Text(
                                      '\$${cart.totalPrice.toStringAsFixed(2)}',
                                      style: TextStyle(fontSize: 16)),
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                      child: const Text("Buy That Shit!",
                                          style: TextStyle(
                                              fontFamily: 'PermanentMarker')),
                                      onPressed:
                                          (cart.totalPrice <= 0.0 || _isLoading)
                                              ? null
                                              : () => _handleOrder(context))
                                ]),
                          ],
                        )),
                    elevation: 12,
                  ),
                ],
              ));
  }
}
