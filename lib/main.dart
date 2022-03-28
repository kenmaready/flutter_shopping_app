import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shopping_app/screens/products_overview.dart';
import './models/product.dart';
import './config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductsOverviewScreen(),
    );
  }
}
