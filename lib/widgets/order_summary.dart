import 'package:objectid/objectid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
//
import '../providers/orders.dart';

class OrderSummary extends StatefulWidget {
  final Order order;

  OrderSummary(@required this.order);

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  final Key key = Key(ObjectId().toString());
  bool _expanded = false;
  final TextStyle textStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: Column(
          children: [
            ListTile(
                title: Text(
                    'Order No. ${widget.order.id.hashCode}  |  Total: \$${widget.order.total.toStringAsFixed(2)}'),
                subtitle: Text(
                    'Ordered: ${DateFormat('MMMM d y, hh:mm').format(widget.order.dateTime)}',
                    style: TextStyle(fontSize: 10)),
                trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() => _expanded = !_expanded),
                )),
            if (_expanded)
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  height: min(widget.order.length * 12.0 + 20, 120),
                  child: ListView(
                    children: widget.order.items
                        .map((item) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.product.title, style: textStyle),
                                Text(
                                    '${item.quantity}x \$${item.product.price.toStringAsFixed(2)}',
                                    style: textStyle)
                              ],
                            ))
                        .toList(),
                  ))
          ],
        ));
  }
}
