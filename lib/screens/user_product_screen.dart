import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shop/providers/products.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/widget/app_drawer.dart';
import 'package:shop/widget/user_product_iteam.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user-product";

  Future<void> _refreshproducts(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsdata = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Product"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshproducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshproducts(context),
                    child: Consumer<Products>(
                      builder: (context, productsdata, _) => Padding(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                          itemBuilder: (ctx, ind) => Column(
                            children: [
                              UserProductIteam(
                                productsdata.iteams[ind].id,
                                productsdata.iteams[ind].title,
                                productsdata.iteams[ind].imageurl,
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: productsdata.iteams.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
