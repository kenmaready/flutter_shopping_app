import 'package:flutter/foundation.dart';
import 'package:objectid/objectid.dart';
//
import './product.dart';
import './cart.dart';

// OrderItem consists of a product and quantity
class OrderItem {
  final id = Key(ObjectId().toString());
  final Product product;
  final int quantity;

  OrderItem({@required this.product, @required this.quantity});
}

// Order object consists of a list of one or more OrderItems grouped
// together and ordered at the same time
class Order {
  final id = Key(ObjectId().toString());
  final DateTime dateTime = DateTime.now();
  List<OrderItem> _items = [];

  Order(Cart cart) {
    _convertCartToOrder(cart);
  }

  void _convertCartToOrder(Cart cart) {
    cart.items
        .forEach((cartItemId, cartItem) => _items.add(cartItem.toOrderItem()));
  }

  List<OrderItem> get items {
    return [..._items];
  }

  int get length {
    return _items.length;
  }

  double get total {
    double total = 0.00;
    for (var item in _items) {
      total += (item.quantity * item.product.price);
    }
    return total;
  }
}

// A Collection of Orders (wrapper around list of Orders)
class Orders with ChangeNotifier {
  final id = Key(ObjectId().toString());
  final List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  int get length {
    return _orders.length;
  }

  void placeOrder(Cart cart) {
    _orders.add(Order(cart));
    cart.clear();
    notifyListeners();
  }

  double get total {
    double total = 0.00;
    for (var order in _orders) {
      total += order.total;
    }
    return total;
  }
}
