import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../widgets/app_drawer.dart';
import '../widgets/order_summary.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = './orders';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('Your Orders',
              style: TextStyle(fontFamily: 'PermanentMarker'))),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, index) => OrderSummary(orders.orders[index]),
      ),
      drawer: AppDrawer(),
    );
  }
}
