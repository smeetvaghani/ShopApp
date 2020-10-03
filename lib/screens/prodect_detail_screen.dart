import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shop/providers/products.dart';

class ProdectDetailScreen extends StatelessWidget {
  static const routename = "/product-detail";
  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(context).settings.arguments as String;

    final lodedproduct =
        Provider.of<Products>(context, listen: false).findbyid(productid);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(lodedproduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(lodedproduct.title),
              background: Hero(
                tag: lodedproduct.id,
                child: Image.network(
                  lodedproduct.imageurl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Text(
              "₹${lodedproduct.price}",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                lodedproduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            SizedBox(height: 1000,)
          ])),
        ],
      ),
    );
  }
}
