import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageurl;
  bool isfavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.description,
    @required this.imageurl,
    this.isfavorite = false,
  });

  Future<void> togglefavorite(String token,String userid) async {
    final oldfav = isfavorite;
    isfavorite = !isfavorite;
    final url = "https://myapplication4-f5e61.firebaseio.com/userFavorite/$userid/$id.json?auth=$token";
    print("Done");
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isfavorite,  
        ),
      );
      if (response.statusCode >= 400) {
        isfavorite = oldfav;
        notifyListeners();
      }
    } catch (error) {
      print(error);

      isfavorite = oldfav;
      notifyListeners();
    }
    notifyListeners();
  }
}
