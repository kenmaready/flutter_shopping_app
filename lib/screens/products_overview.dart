import 'package:flutter/material.dart';
import '../config.dart';
import '../providers/product.dart';
import '../widgets/product_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(config.title)),
      body: ProductGrid(),
      backgroundColor: Colors.purple.shade100,
    );
  }
}
