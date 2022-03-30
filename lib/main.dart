import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import './providers/products.dart';
import './providers/cart.dart';
import './screens/all.dart';
import './config.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        )
      ],
      child: MaterialApp(
        title: config.title,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
