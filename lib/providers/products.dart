import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//
import '../exceptions/http_exception.dart';
import './product.dart';
import './auth.dart';

String base_url = dotenv.env['FIREBASE_BASE_URL'] as String;

class Products with ChangeNotifier {
  List<Product> _products = [];
  final Auth _auth;

  Products(this._products, this._auth) {
    print("creating new Products instance...");
  }

  List<Product> get products {
    return [..._products];
  }

  Map<String, String> get _authQuery {
    return {"auth": _auth.token as String};
  }

  Future<void> fetchProducts() async {
    final productsUrl = Uri.https(base_url, '/products.json', _authQuery);
    final favoritesUrl = Uri.https(
        base_url, '/users/${_auth.userId}/favorites.json', _authQuery);

    try {
      final response = await http.get(productsUrl);
      List<Product> fetchedProductList = [];
      final Map<String, dynamic> productData = json.decode(response.body);
      //
      // get favorites information for user:

      final favoritesResponse = await http.get(favoritesUrl);
      List<String> favoritesById = [];
      if (json.decode(favoritesResponse.body) != null) {
        final Map<String, dynamic> favoritesData =
            json.decode(favoritesResponse.body);
        print("favoritesData: $favoritesData");
        for (var productId in favoritesData.keys) {
          favoritesById.add(productId);
        }
      }
      print("favoritesById: ${favoritesById.toString()}");
      //
      for (MapEntry e in productData.entries) {
        print('${e.key}: ${e.value['title']}');
        Product nextProduct = Product.fromJson(e);
        if (favoritesById.contains(nextProduct.id)) {
          nextProduct.isFavorite = true;
        }
        fetchedProductList.add(nextProduct);
      }
      _products = fetchedProductList;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.https(base_url, '/products.json', _authQuery);

    try {
      final response = await http.post(url, body: product.toJson());
      _products.add(product.copyWith(id: json.decode(response.body)['name']));
      notifyListeners();
    } catch (err) {
      rethrow;
    }
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

  Future<void> updateProduct(Product updatedProduct) async {
    var url =
        Uri.https(base_url, '/products/${updatedProduct.id}.json', _authQuery);

    final int prodIndex =
        _products.indexWhere((product) => product.id == updatedProduct.id);

    if (prodIndex < 0) {
      throw Exception(
          "No Product Found with the id provided (\"${updatedProduct.id}\").");
    }

    try {
      // update on server
      await http.patch(url, body: updatedProduct.toJson());
      // update locally
      _products[prodIndex] = updatedProduct;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    var url = Uri.https(base_url, '/products/$productId.json', _authQuery);

    // locatl delete operation
    // 1. Get index of product to be deletd from _products list:
    final deletedProductIndex =
        _products.indexWhere((product) => product.id == productId);
    // 2. Get a handle to that product (for use if rollback required below)
    final deletedProduct = _products[deletedProductIndex];
    // 3. Delete the product from _products list locally
    _products.removeAt(deletedProductIndex);

    // try to delete product from Database remotely
    try {
      var response = await http.delete(url);
      // extra check required bc delete does not throw an error
      // automatically if there is a 400/500 error on the back end
      if (response.statusCode >= 400) {
        throw HttpException(
            'There was an issue deleting the product from the Blamazon database.  Error Code: ${response.statusCode}');
      }
    } catch (error) {
      // it removal from database fails, rolback change
      // locally by reinserting product into _products list:
      _products.insert(deletedProductIndex, deletedProduct);
    }
    notifyListeners();
  }
}
