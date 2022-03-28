import 'package:flutter/material.dart';
import '../config.dart';
import '../models/product.dart';
import '../widgets/product_item.dart';
import '../data/products.dart';

class ProductsOverviewScreen extends StatelessWidget {
  final List<Product> _products = products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(config.title)),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        itemBuilder: (context, index) => ProductItem(
            id: products[index].id,
            title: products[index].title,
            imageUrl: products[index].imageUrl),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.0 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
      ),
    );
  }
}
