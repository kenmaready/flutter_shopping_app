import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../providers/products.dart';
import '../providers/product.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {
  bool _favoritesOnly;

  ProductGrid({favoritesOnly = false}) {
    _favoritesOnly = favoritesOnly;
  }

  @override
  Widget build(BuildContext context) {
    final productCatalog = Provider.of<Products>(context);
    final products =
        _favoritesOnly ? productCatalog.favorites : productCatalog.products;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: products[index], child: ProductItem()),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.0 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
