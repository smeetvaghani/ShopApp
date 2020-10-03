import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

class CartIteam extends StatelessWidget {
  final String id;
  final String productid;
  final String title;
  final int quantity;
  final double price;

  CartIteam(
    this.id,
    this.productid,
    this.title,
    this.quantity,
    this.price, 
  );
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.all(10),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Are you sure? "),
            content: Text("Do you want to remove iteam from the cart?"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("No"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("Yes"),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeiteam(productid);
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Text("₹$price"),
              ),
            ),
            title: Text(title),
            subtitle: Text("Total: ₹${(price * quantity)}"),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
