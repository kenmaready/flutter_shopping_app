import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shopping_app/exceptions/http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//
import './user.dart';

String api_key = dotenv.env['FIREBASE_API_KEY'] as String;

enum AuthMode { Signup, Login }

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  User? _user;

  Auth() {
    print("creating new Auth object...");
  }

  bool get isLoggedIn {
    print("isLoggedIn() has been called.  Current token: $token");
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        (_expiryDate as DateTime).isAfter(DateTime.now()) &&
        _token != null) {
      print("Returning auth.token and it is $_token...");
      return _token;
    }

    print("Returning auth.token and it is null...");
    return null;
  }

  String? get userId {
    return _user?.userId;
  }

  Future<void> _userAuthentication(
      String email, String password, AuthMode mode) async {
    String api_action =
        mode == AuthMode.Signup ? 'signUp' : 'signInWithPassword';
    var url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:${api_action}?key=$api_key");

    try {
      final rawResponse = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));

      var response = json.decode(rawResponse.body);
      if (response['error'] != null) {
        throw HttpException(
            '${response['error']['code']} error: ${response['error']['message']}');
      }

      _token = response['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(response['expiresIn'])));
      _user = User(response['localId'], _token as String);
      notifyListeners();
    } catch (err) {
      rethrow;
    }

    print(toString());
  }

  Future<void> signup(String email, String password) async {
    return _userAuthentication(email, password, AuthMode.Signup);
  }

  Future<void> login(String email, String password) async {
    return _userAuthentication(email, password, AuthMode.Login);
  }

  void logout() {
    _token = null;
    _expiryDate = null;
    _user = null;
    notifyListeners();
  }

  String toString() {
    return 'Auth { token: $_token, expiryDate: ${_expiryDate.toString()}, userId: $_user.userId }';
  }
}
