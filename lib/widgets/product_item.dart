import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../screens/product_detail.dart';
import '../providers/product.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context);
    final Cart cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: GridTile(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, exception, stacktrace) {
                return const Center(child: Text("No Valid Image provided"));
              },
            ),
            footer: GridTileBar(
              leading: IconButton(
                icon: product.isFavorite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  product.toggleFavoriteStatus(
                      authData.token as String, authData.userId as String);
                },
              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  cart.addItem(product, 1);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Snacking on this ${product.title}!",
                        style: TextStyle(fontFamily: 'PermanentMarker'),
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(milliseconds: 1800),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () => cart.removeOne(product.id),
                      )));
                },
              ),
              backgroundColor: Colors.black54,
            )),
      ),
    );
  }
}
