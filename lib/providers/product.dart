import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Product.empty(
      {this.id = null,
      this.title = '',
      this.price = 0.0,
      this.description = '',
      this.imageUrl = '',
      this.isFavorite = false});

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Product copyWith(
          {String id,
          String title,
          String description,
          double price,
          String imageUrl,
          bool isFavorite}) =>
      Product(
          id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          price: price ?? this.price,
          imageUrl: imageUrl ?? this.imageUrl,
          isFavorite: isFavorite ?? this.isFavorite);

  void printIt() {
    print(
        "Product(id: ${id}, title: ${title}, description: ${description}, price: ${price.toString()}, imageUrl: ${imageUrl}, isFavorite: ${isFavorite.toString()})");
  }
}
