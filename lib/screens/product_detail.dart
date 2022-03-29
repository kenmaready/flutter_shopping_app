import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments;
    final product =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text("${product.title}!"),
      ),
      body: Container(child: Image.network(product.imageUrl)),
    );
  }
}
