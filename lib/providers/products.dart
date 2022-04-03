import 'package:objectid/objectid.dart';
import 'package:flutter/material.dart';
//
import '../data/products.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _products = productCatalog;

  List<Product> get products {
    return [..._products];
  }

  void addProduct(Product product) {
    _products.add(product.copyWith(id: ObjectId().toString()));
    notifyListeners();
  }

  Product findById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }

  int get length {
    return _products.length;
  }

  List<Product> get favorites {
    return _products.where((product) => product.isFavorite).toList();
  }

  void updateProduct(Product updatedProduct) {
    final int prodIndex =
        _products.indexWhere((product) => product.id == updatedProduct.id);

    if (prodIndex < 0) {
      throw Exception(
          "No Product Found with the id provided (\"${updatedProduct.id}\").");
    }

    _products[prodIndex] = updatedProduct;
    notifyListeners();
  }

  void deleteProduct(String productId) {
    _products.removeWhere((product) => product.id == productId);
    notifyListeners();
  }
}
