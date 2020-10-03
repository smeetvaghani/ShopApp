import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';

import '../providers/cart.dart';
import '../providers/product.dart';

import 'package:shop/screens/prodect_detail_screen.dart';

class ProductIteam extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageurl;
  // final String description;

  // ProductIteam(
  //   this.id,
  //   this.title,
  //   this.imageurl,
  //   this.description,
  // );

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,
        listen: false); //image and other not change by provider
    final cart = Provider.of<Cart>(context, listen: false);
    final authdata = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProdectDetailScreen.routename,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: Image.network(
              product.imageurl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              //only fav button change
              builder: (ctx, product, child) => IconButton(
                icon: Icon(
                  product.isfavorite ? Icons.favorite : Icons.favorite_border,
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  print("Button press");
                  print(product.isfavorite);
                  product.togglefavorite(
                    authdata.token,
                    authdata.userid,
                  );
                },
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.additeam(product.id, product.title, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Added iteam to Cart!",
                      // textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 3),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.removesingleiteam(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
