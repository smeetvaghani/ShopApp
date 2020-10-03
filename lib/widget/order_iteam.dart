import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../providers/orders.dart' as ss;

class OrderIteam extends StatefulWidget {
  final ss.OrderIteam order;
  OrderIteam(this.order);

  @override
  _OrderIteamState createState() => _OrderIteamState();
}

class _OrderIteamState extends State<OrderIteam> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 110, 190) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text("₹${widget.order.amount}"),
              subtitle:
                  Text(DateFormat("dd/mm/yyyy").format(widget.order.dateTime)),
              trailing: IconButton(
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(10),
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 50, 180)
                  : 0,
              child: ListView(
                children: widget.order.products
                    .map(
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prod.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${prod.quantity}x  ₹${prod.price}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
