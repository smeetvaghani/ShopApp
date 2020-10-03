import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderIteam {
  final String id;
  final double amount;
  final List<Cartiteam> products; //cart.dart cartiteam
  final DateTime dateTime;

  OrderIteam({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderIteam> _orders = [];

  List<OrderIteam> get orders {
    return [..._orders];
  }

  final String authToken;
  final String userid;

  Orders(this.authToken,this.userid,this._orders);


  // //for fatching order
  Future<void> fetchAndSetOrders() async {
    final url = "https://myapplication4-f5e61.firebaseio.com/orders/$userid.json?auth=$authToken";
    final response = await http.get(url);
    final List<OrderIteam> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderIteam(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => Cartiteam(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title'],
                    ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }


//its wrong code.............................................................................
  // //for fatching order
  // Future<void> fetchAndSetOrder() async {
  //   const url = "https://myapplication4-f5e61.firebaseio.com/orders.json";
  //   final response = await http.get(url);
  //   final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //   final List<OrderIteam> lodedproducts = [];
  //   if (extractedData == null) {
  //     return;
  //   }
  //   extractedData.forEach((orderid, orderdata) {
  //     lodedproducts.add(
  //       OrderIteam(
  //         id: orderid,
  //         amount: orderdata["amount"],
  //         dateTime: DateTime.parse(orderdata["dateTime"]),
  //         products: (orderdata["products "] as List<dynamic>)
  //             .map(
  //               (iteam) => Cartiteam(
  //                 id: iteam["id"],
  //                 title: iteam["title"],
  //                 quantity: iteam["quantity"],
  //                 price: iteam["price"],
  //               ),
  //             )
  //             .toList(),
  //       ),
  //     );
  //   });
  //   _orders = lodedproducts.reversed.toList();
  //   notifyListeners();
  // }

  //for order the products
  Future<void> addOrders(List<Cartiteam> cartProducts, double total) async {
    final url = "https://myapplication4-f5e61.firebaseio.com/orders/$userid.json?auth=$authToken";
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        "amount": total,
        "dateTime": timestamp.toIso8601String(),
        "products": cartProducts
            .map((cartp) => {
                  "id": cartp.id,
                  "title": cartp.title,
                  "quantity": cartp.quantity,
                  "price": cartp.price,
                })
            .toList(),
      }),
    );

    _orders.insert(
      0,
      OrderIteam(
        id: json.decode(response.body)["name"],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}
