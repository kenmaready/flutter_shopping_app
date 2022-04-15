import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../screens/user_products.dart';
import '../screens/auth_screen.dart';
import '../screens/orders.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);
    return Drawer(
        child: Column(
      children: [
        AppBar(
          title: Text('Blamazon!',
              style: TextStyle(fontFamily: 'PermanentMarker')),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          leading: Icon(auth.isLoggedIn ? Icons.logout : Icons.login),
          title: Text(auth.isLoggedIn ? "Log Out" : "Log In"),
          onTap: () {
            if (auth.isLoggedIn) {
              auth.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            } else {
              Navigator.of(context).pushReplacementNamed('/');
            }
          },
        ),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Orders'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Manage Products'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName);
          },
        )
      ],
    ));
  }
}
