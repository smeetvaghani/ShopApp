import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widget/product_iteam.dart';

class ProductGrid extends StatelessWidget {
  final bool showfaviteam;

  ProductGrid(this.showfaviteam);

  @override
  Widget build(BuildContext context) {
    final productdata = Provider.of<Products>(context);
    final products =
        showfaviteam ? productdata.favoriteiteams
                     : productdata.iteams;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, ind) => ChangeNotifierProvider.value(
        value: products[ind],
        // create: (context) => products[ind],
        child: ProductIteam(
            //   products[ind].id,
            //   products[ind].title,
            //   products[ind].imageurl,
            //   products[ind].description,
            ),
      ),
      itemCount: products.length,
    );
  }
}
