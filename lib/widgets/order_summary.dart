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

class _OrderSummaryState extends State<OrderSummary>
    with SingleTickerProviderStateMixin {
  final Key key = Key(ObjectId().toString());
  bool _expanded = false;
  final TextStyle textStyle =
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
  late AnimationController _animationController;
  late Animation<Size> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? min(widget.order.length * 12.0 + 120, 220) : 95,
      curve: Curves.easeIn,
      child: Card(
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
                    icon:
                        Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () => setState(() => _expanded = !_expanded),
                  )),
              AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  height:
                      _expanded ? min(widget.order.length * 12.0 + 20, 120) : 0,
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
          )),
    );
  }
}
