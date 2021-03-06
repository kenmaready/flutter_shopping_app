import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  CartItemWidget(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: cartItem.id,
      background: Container(
        color: Color.fromRGBO(255, 0, 0, 0.8),
        child: Icon(Icons.delete, color: Colors.white54, size: 40),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).remove(cartItem.id);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                    title: Text('Are you SURE??'),
                    content:
                        Text('Do you want to remove this item from the cart.'),
                    actions: [
                      TextButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                      ),
                      TextButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                      ),
                    ]));
      },
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Padding(
              padding: EdgeInsets.all(4),
              child: ListTile(
                  leading: CircleAvatar(
                      child: Text(
                          '\$${cartItem.product.price.toStringAsFixed(2)}')),
                  title: Text(cartItem.product.title),
                  subtitle: Text('Quantity: ${cartItem.quantity}'),
                  trailing: Text(
                      '\$${(cartItem.quantity * cartItem.product.price).toStringAsFixed(2)}')))),
    );
  }
}
