import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../widgets/order_summary.dart';
import '../widgets/error_alert.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = './orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context, listen: false)
          .fetchOrders()
          .then((response) {
        setState(() {
          _isInit = false;
          _isLoading = false;
        });
      }).catchError((error) {
        showDialog(
            context: context,
            builder: (ctx) => const ErrorAlert(actionName: 'fetching Orders'));
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
          title: Text('Your Orders!',
              style: TextStyle(fontFamily: 'PermanentMarker'))),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.length > 0
              ? (ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (ctx, index) =>
                      OrderSummary(orders.orders[index]),
                ))
              : const Center(
                  child: Text("You do not have any Orders in your account.")),
      drawer: AppDrawer(),
    );
  }
}
