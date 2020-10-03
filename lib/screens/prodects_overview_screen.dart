import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

import 'package:shop/providers/products.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/widget/app_drawer.dart';
import 'package:shop/widget/badge.dart';

import 'package:shop/widget/product_grid.dart';

enum Filteroption {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorite = false;
  var _isinit = true;
  var _isloding = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _isloding = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((value) {
         setState(() {
        _isloding = false;
      });
      });
     
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productdata = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("MyShop"),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("favorite"),
                value: Filteroption.Favorite,
              ),
              PopupMenuItem(
                child: Text("all"),
                value: Filteroption.All,
              )
            ],
            onSelected: (Filteroption selectedvalue) {
              setState(() {
                if (selectedvalue == Filteroption.Favorite) {
                  _showOnlyFavorite = true;
                  // productdata.showOnlyfavorite();
                } else {
                  _showOnlyFavorite = false;
                  // productdata.showAll();
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
          ),
          Consumer<Cart>(
            builder: (context, cartdata, child) => Badge(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routename);
                },
              ),
              value: cartdata.iteamcount.toString(),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isloding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavorite),
    );
  }
}
