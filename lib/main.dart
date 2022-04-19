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
            update: (context, auth, prevOrders) =>
                Orders(prevOrders == null ? [] : prevOrders.orders, auth),
            create: (ctx) => Orders([], Auth()),
          )
        ],
        child: Consumer<Auth>(builder: (ctx, auth, _) {
          ifAuth(targetScreen) => auth.isLoggedIn ? targetScreen : AuthScreen();
          return MaterialApp(
            title: config.title,
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              textTheme: Theme.of(context).textTheme.copyWith(
                  headline1: TextStyle(fontFamily: 'PermamentMarker')),
            ),
            home: auth.isLoggedIn
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? const Center(child: CircularProgressIndicator())
                            : const AuthScreen()),
            routes: {
              ProductsOverviewScreen.routeName: (ctx) =>
                  ifAuth(ProductsOverviewScreen()),
              ProductDetailScreen.routeName: (ctx) =>
                  ifAuth(ProductDetailScreen()),
              UserProductsScreen.routeName: (ctx) =>
                  ifAuth(UserProductsScreen()),
              EditProductScreen.routeName: (ctx) => ifAuth(EditProductScreen()),
              OrdersScreen.routeName: (ctx) => ifAuth(OrdersScreen()),
              AuthScreen.routeName: (ctx) => AuthScreen(),
              CartScreen.routeName: (ctx) => ifAuth(CartScreen()),
            },
            debugShowCheckedModeBanner: false,
          );
        }));
  }
}
