import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product";

  ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final product =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
        backgroundColor: Colors.purple.shade100,
        // appBar: AppBar(
        //   title: Text("Just ${product.title}!",
        //       style: const TextStyle(fontFamily: 'PermanentMarker')),
        // ),
        body: CustomScrollView(slivers: [
          SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  title: Container(
                      color: Colors.black38,
                      child: Text("Just ${product.title}!")),
                  background: Hero(
                      tag: product.id,
                      child:
                          Image.network(product.imageUrl, fit: BoxFit.cover)))),
          SliverList(
              delegate: SliverChildListDelegate(
            [
              const SizedBox(height: 10),
              Text(
                product.title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Text(product.description,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 800),
            ],
          ))
        ]));
  }
}
