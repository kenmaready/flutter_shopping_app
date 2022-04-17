import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//
import '../exceptions/http_exception.dart';

String base_url = dotenv.env['FIREBASE_BASE_URL'] as String;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String ownerId;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.ownerId,
    this.isFavorite = false,
  });

  Product.empty(
      {this.id = '',
      this.title = '',
      this.price = 0.0,
      this.description = '',
      this.imageUrl = '',
      this.isFavorite = false,
      this.ownerId = ''});

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final prevStatus = isFavorite;

    // update locally
    isFavorite = !isFavorite;
    notifyListeners();

    // update on server
    var url = Uri.https(
        base_url, '/users/$userId/favorites/$id.json', {"auth": token});

    try {
      final response = isFavorite
          ? await http.post(url, body: json.encode(isFavorite))
          : await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException(
            'There was an error updating the favorite status on the server. Error Code: ${response.statusCode}');
      }
    } catch (error) {
      // roll back change locally if db update didn't work
      isFavorite = prevStatus;
      notifyListeners();
      rethrow;
    }
  }

  Product copyWith(
          {String? id,
          String? title,
          String? description,
          double? price,
          String? imageUrl,
          bool? isFavorite,
          String? ownerId}) =>
      Product(
          id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          price: price ?? this.price,
          imageUrl: imageUrl ?? this.imageUrl,
          isFavorite: isFavorite ?? this.isFavorite,
          ownerId: ownerId ?? this.ownerId);

  void printIt() {
    print(
        "Product(id: $id, title: $title, description: $description, price: ${price.toString()}, imageUrl: $imageUrl, isFavorite: ${isFavorite.toString()})");
  }

  String toJson() => json.encode({
        "id": id,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'price': price.toStringAsFixed(2),
        'ownerId': ownerId,
      });

  Product.fromJson(MapEntry e)
      : id = e.key ?? '',
        title = e.value['title'] ?? '',
        description = e.value['description'] ?? '',
        price = double.parse(e.value['price'] ?? '0.0'),
        imageUrl = e.value['imageUrl'] ?? '',
        ownerId = e.value['ownerId'] ?? '',
        isFavorite = false;

  Product.fromMap(Map<String, dynamic> args)
      : id = args['id'],
        title = args['title'],
        description = args['description'],
        price = double.parse(args['price']),
        ownerId = args['ownerId'],
        imageUrl = args['imageUrl'],
        isFavorite = false {
    print("creating product for $title");
  }
}
