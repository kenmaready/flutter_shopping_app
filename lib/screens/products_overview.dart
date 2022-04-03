import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../widgets/product_grid.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../screens/cart.dart';
import '../config.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName = '/shop';

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _favoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    final productCatalog = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text("Shop Blamazon!",
              style: TextStyle(fontFamily: 'PermanentMarker')),
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  _favoritesOnly = (selectedValue == FilterOptions.Favorites);
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  child: Text('Favorites Only'),
                  value: FilterOptions.Favorites,
                ),
                const PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                )
              ],
            ),
            Consumer<Cart>(
              builder: (_, cart, child) => Badge(
                child: child,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ]),
      body: ProductGrid(favoritesOnly: _favoritesOnly),
      drawer: AppDrawer(),
      backgroundColor: Colors.purple.shade100,
    );
  }
}
