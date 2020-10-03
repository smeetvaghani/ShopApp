import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widget/cart_iteam.dart';

class CartScreen extends StatelessWidget {
  static const routename = "/cart";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your cart itam"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TOTAL :",
                    style: TextStyle(fontSize: 20),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "${cart.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) => CartIteam(
              cart.iteams.values.toList()[index].id,
              cart.iteams.keys.toList()[index],
              cart.iteams.values.toList()[index].title,
              cart.iteams.values.toList()[index].quantity,
              cart.iteams.values.toList()[index].price,
            ), //from cart_iteam
            itemCount: cart.iteams.length,
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoding = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoding ? CircularProgressIndicator() 
                        : Text("Order Now"),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoding) ? null :
        () async {
          setState(() {
            _isLoding = true;
          });
        await Provider.of<Orders>(context, listen: false).addOrders(
          widget.cart.iteams.values.toList(),
          widget.cart.totalAmount,
        );
        setState(() {
            _isLoding = false;
          });
        widget.cart.clear();
      },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
