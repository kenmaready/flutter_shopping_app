import 'package:flutter_shopping_app/screens/edit_product.dart';
import 'package:flutter_shopping_app/screens/user_products.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import './providers/products.dart';
import './providers/orders.dart';
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
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        )
      ],
      child: MaterialApp(
        title: config.title,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          textTheme: Theme.of(context)
              .textTheme
              .copyWith(headline1: TextStyle(fontFamily: 'PermamentMarker')),
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
