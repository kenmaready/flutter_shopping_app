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
        title: Text("Just ${product.title}!",
            style: TextStyle(fontFamily: 'PermanentMarker')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 300,
                width: double.infinity,
                child: Image.network(product.imageUrl, fit: BoxFit.cover)),
            SizedBox(height: 10),
            Text(product.title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            SizedBox(height: 10),
            Text('\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              child: Text(product.description,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
