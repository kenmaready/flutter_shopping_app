import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import './providers/products.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './providers/cart.dart';
import './screens/all.dart';
import './config.dart';

Future main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, prevProducts) => Products(
                prevProducts == null ? [] : prevProducts.products, auth),
            create: (ctx) {
              print(
                  "create: has been called in ChangeNotifierProxyProvider...");
              return Products([], Auth());
            }, // dummy value to pass CNPP reqs
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (context, auth, prevOrders) => Orders(
                prevOrders == null ? [] : prevOrders.orders,
                auth.token == null ? '' : auth.token as String),
            create: (ctx) => Orders([], ''),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: config.title,
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              textTheme: Theme.of(context).textTheme.copyWith(
                  headline1: TextStyle(fontFamily: 'PermamentMarker')),
            ),
            home: auth.isLoggedIn ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              ProductsOverviewScreen.routeName: (ctx) =>
                  ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
            },
            debugShowCheckedModeBanner: false,
          ),
        ));
  }
}
