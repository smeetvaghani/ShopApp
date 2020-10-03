import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/screens/edit_product_screen.dart';

class UserProductIteam extends StatelessWidget {
  final String id;
  final String title;
  final String imageurl;

  UserProductIteam(this.id, this.title, this.imageurl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageurl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteproducts(id);
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                    content: Text(
                      "delete falied",
                      textAlign: TextAlign.center,
                    ),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
