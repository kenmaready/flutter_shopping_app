import 'package:objectid/objectid.dart';
import 'package:flutter/widgets.dart';
//
import './product.dart';

class CartItem {
  final id = ObjectId();
  final Product product;
  int quantity;

  CartItem({@required this.product, this.quantity = 1});

  @override
  String toString() {
    return "CartItem: {id: $id, product: ${product.title}, quantity: $quantity }";
  }
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  // This getter currently returns the total of QUANTITIES,
  // not just the number of items
  int get itemCount {
    int total = 0;

    for (var val in _items.values) {
      total += val.quantity;
    }

    return total;
  }

  void addItem(Product product, int quantity) {
    _items.update(
        product.id,
        (value) => CartItem(
              product: value.product,
              quantity: value.quantity + quantity,
            ),
        ifAbsent: () => CartItem(product: product, quantity: quantity));
    notifyListeners();
  }
}
