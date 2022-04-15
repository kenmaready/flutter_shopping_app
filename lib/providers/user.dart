import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//
import './product.dart';

String base_url = dotenv.env['FIREBASE_BASE_URL'] as String;

class User with ChangeNotifier {
  late String _userId;
  late List<String> _favorites;

  User(this._userId, String token) {
    fetchFavorites(token);
  }

  String get userId => _userId;

  void fetchFavorites(String token) async {
    var url =
        Uri.https(base_url, '/users/$userId/favorites.json', {"auth": token});

    try {
      final response = await http.get(url);
      if (response.body == null) {
        print("no response.body");
      } else {
        print(json.decode(response.body));
      }
    } catch (error) {
      rethrow;
    }
  }
}
