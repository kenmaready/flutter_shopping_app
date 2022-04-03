import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../widgets/user_product_item.dart';
import '../screens/edit_product.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user/products';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Manage Your Products!',
              style: TextStyle(fontFamily: 'PermanentMarker')),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
            )
          ]),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (ctx, index) => Column(children: [
            UserProductItemWidget(products.products[index]),
            Divider(),
          ]),
          itemCount: products.length,
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
