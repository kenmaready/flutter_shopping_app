import 'package:flutter/material.dart';
import '../data/products.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _products = productCatalog;

  List<Product> get products {
    return [..._products];
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  Product findById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }

  List<Product> get favorites {
    return _products.where((product) => product.isFavorite).toList();
  }
}
