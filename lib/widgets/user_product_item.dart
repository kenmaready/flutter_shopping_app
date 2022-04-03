import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../screens/edit_product.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class UserProductItemWidget extends StatelessWidget {
  final Product product;

  UserProductItemWidget(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        title: Text(product.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () => Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: product),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                Provider.of<Products>(context, listen: false)
                    .deleteProduct(product.id);
              },
            ),
          ],
        ));
  }
}
