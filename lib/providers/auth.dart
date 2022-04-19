import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
//
import '../exceptions/http_exception.dart';
import './user.dart';

String api_key = dotenv.env['FIREBASE_API_KEY'] as String;

enum AuthMode { Signup, Login }

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  User? _user;
  Timer? _authTimer;

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
      _setAutoLogout();
      notifyListeners();
      // set up shared preferences:
      final preferences = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _user?.userId,
        'expiryDate': (_expiryDate as DateTime).toIso8601String()
      });
      preferences.setString('userData', userData);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _userAuthentication(email, password, AuthMode.Signup);
  }

  Future<void> login(String email, String password) async {
    return _userAuthentication(email, password, AuthMode.Login);
  }

  Future<bool> tryAutoLogin() async {
    print("trying tryAutoLogin()...");
    try {
      final preferences = await SharedPreferences.getInstance();
      if (!preferences.containsKey('userData')) return false;

      final userData = json.decode(preferences.getString('userData') as String)
          as Map<String, dynamic>;
      final expiryDate = DateTime.parse(userData['expiryDate'] as String);

      // return false if token in memory has expired
      if (expiryDate.isBefore(DateTime.now())) return false;

      // if valid, unexpired token, autologin and return true:
      _token = userData['token'] as String;
      _user = User(userData['userId'] as String, _token as String);
      _expiryDate = expiryDate;
      _setAutoLogout();
      notifyListeners();
      return true;
    } catch (error) {
      print("Error: ${error.toString()}");
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _user = null;
    if (_authTimer != null) {
      (_authTimer as Timer).cancel();
      _authTimer = null;
    }
    notifyListeners();

    // remove our app's shared preferences from device
    // to prevent accidentally logging them back in:
    final preferences = await SharedPreferences.getInstance();
    preferences.remove('userData');
    // can also use preferences.clear() which will remove
    // ALL of the app's data from the device memory (here
    // we don't have any other data).)
  }

  void _setAutoLogout() {
    if (_authTimer != null) {
      (_authTimer as Timer).cancel();
    }

    final secondsToExpiry =
        (_expiryDate as DateTime).difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: secondsToExpiry), logout);
  }

  String toString() {
    return 'Auth { token: $_token, expiryDate: ${_expiryDate.toString()}, userId: $_user.userId }';
  }
}
