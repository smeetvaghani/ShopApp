import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/screens/user_product_screen.dart';

import './providers/cart.dart';
import './providers/products.dart';
import './providers/orders.dart';

import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/prodect_detail_screen.dart';
import 'package:shop/screens/prodects_overview_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previouproduct) => Products(
            auth.token,
            auth.userid,
            previouproduct == null ? [] : previouproduct.iteams,
          ),
        ),
        ChangeNotifierProvider.value(value: Cart()),
        // ChangeNotifierProvider.value(v alue: Orders()),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previouproduct) => Orders(
            auth.token,
            auth.userid,
            previouproduct == null ? [] : previouproduct.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: "my shop",
          theme: ThemeData(
            primarySwatch: Colors.green,
            accentColor: Colors.deepOrange,
            fontFamily: "lato",
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryautologin(),
                  builder: (context, autoresultsnapshot) =>
                      autoresultsnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProdectDetailScreen.routename: (ctx) => ProdectDetailScreen(),
            CartScreen.routename: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
