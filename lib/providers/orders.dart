import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:objectid/objectid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//
import './product.dart';
import './cart.dart';

String base_url = dotenv.env['FIREBASE_BASE_URL'] as String;

// OrderItem consists of a product and quantity
class OrderItem {
  final id = Key(ObjectId().toString());
  final Product product;
  final int quantity;

  OrderItem({required this.product, required this.quantity});

  String toJson() => json.encode({
        "id": id.toString(),
        "product": product.toJson(),
        "quantity": quantity.toString()
      });
}

// Order object consists of a list of one or more OrderItems grouped
// together and ordered at the same time
class Order {
  String? id;
  DateTime dateTime;
  List<OrderItem> _items = [];

  Order(
      {required this.id,
      required this.dateTime,
      required List<OrderItem> items})
      : _items = items;

  Order.fromCart(Cart cart) : dateTime = DateTime.now() {
    _convertCartToOrder(cart);
  }

  void _convertCartToOrder(Cart cart) {
    cart.items
        .forEach((cartItemId, cartItem) => _items?.add(cartItem.toOrderItem()));
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

  Order copyWith({String? id, DateTime? dateTime, List<OrderItem>? items}) =>
      Order(
          id: id ?? this.id,
          dateTime: dateTime ?? this.dateTime,
          items: _items ?? this._items);

  String toJson() {
    var listItems = _items.map((orderItem) => orderItem.toJson()).toList();

    return json.encode({
      "id": id,
      "dateTime": dateTime.toIso8601String(),
      "_items": listItems,
    });
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

  Future<void> placeOrder(Cart cart) async {
    var url = Uri.https(base_url, '/orders.json');
    Order newOrder = Order.fromCart(cart);

    try {
      final response = await http.post(url, body: newOrder.toJson());
      _orders.add(newOrder.copyWith(id: json.decode(response.body)['name']));
      cart.clear();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  double get total {
    double total = 0.00;
    for (var order in _orders) {
      total += order.total;
    }
    return total;
  }
}
