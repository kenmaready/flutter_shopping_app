import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../widgets/user_product_item.dart';
import '../screens/edit_product.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../providers/auth.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user/products';

  Future<void> _handleRefresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context, listen: false).userId;
    // final products = Provider.of<Products>(context);

    return Scaffold(
      backgroundColor: Colors.purple.shade100,
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
      body: FutureBuilder(
          future: _handleRefresh(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => _handleRefresh(context),
                      child: Consumer<Products>(
                        builder: (context, products, child) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                            itemBuilder: (ctx, index) => Column(children: [
                              UserProductItemWidget(products.products[index]),
                              const Divider(),
                            ]),
                            itemCount: products.length,
                          ),
                        ),
                      ),
                    )),
      drawer: AppDrawer(),
    );
  }
}
