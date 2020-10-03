import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _iteams = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageurl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageurl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageurl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageurl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get iteams {
    // if (_showonlyfavorite) {
    //   return _iteams.where((piteam) => piteam.isfavorite).toList();
    // }
    return [..._iteams];
  }

  List<Product> get favoriteiteams {
    return _iteams.where((piteam) => piteam.isfavorite).toList();
  }

  Product findbyid(String id) {
    return _iteams.firstWhere((prod) => prod.id == id);
  }

  // var _showonlyfavorite = false;

  // void showOnlyfavorite(){
  //   _showonlyfavorite = true;
  //   notifyListeners();
  // }
  // void showAll(){
  //   _showonlyfavorite = false;
  //   notifyListeners();
  // }
  final String authToken;
  final String userid;

  Products(this.authToken,this.userid,this._iteams);

  Future<void> fetchAndSetProducts([bool filterbyuser = false]) async {
    final filter = filterbyuser ?  'orderBy="creatorid"&equalTo="$userid"' : "";
    var url = 'https://myapplication4-f5e61.firebaseio.com/products.json?auth=$authToken&$filter';
    try {
      final response = await http.get(url); 
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> lodedproducts = [];
      if (extractedData == null) {
        return;
      }
      url = "https://myapplication4-f5e61.firebaseio.com/userFavorite/$userid.json?auth=$authToken";
      final responsefavorite = await http.get(url);
      final favoriteData = json.decode(responsefavorite.body);
      extractedData.forEach((prodid, proddata) {
        lodedproducts.add(
          Product(
            id: prodid,
            title: proddata["title"],
            price: proddata["price"],
            description: proddata["description"],
            imageurl: proddata["imageurl"],
            isfavorite: favoriteData==null ? false : favoriteData[prodid] ?? false,
          ),
        );
      });
      _iteams = lodedproducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  //add proooooooooooooducts
  Future<void> addproducts(Product product) async {
    final url = "https://myapplication4-f5e61.firebaseio.com/products.json?auth=$authToken";
    try {
      final response = await http.post(url,
          body: json.encode(
            {
              "title": product.title,
              "price": product.price,
              "description": product.description,
              "imageurl": product.imageurl,
              "creatorid" : userid,
            },
          ));
      // .then((response) {
      final newproduct = Product(
        // id: DateTime.now().toString(),
        id: json.decode(response.body)["name"],
        title: product.title,
        imageurl: product.imageurl,
        price: product.price,
        description: product.description,
      );
      _iteams.add(newproduct);
      // _iteams.insert(0, newproduct);    //add at start
      notifyListeners();
    } catch (error) {
      // }).catchError((error){
      print(error);
      throw error;
    }
  }

  //update proooooooooooducts
  void updateproduct(String id, Product newproduct) async {
    final prodindex = _iteams.indexWhere((prod) => prod.id == id);
    if (prodindex >= 0) {
      final url =
          "https://myapplication4-f5e61.firebaseio.com/products/$id.json?auth=$authToken";
      await http.patch(url,
          body: json.encode({
            "title": newproduct.title,
            "price": newproduct.price,
            "description": newproduct.description,
            "imageurl": newproduct.imageurl,
          }));
      _iteams[prodindex] = newproduct;
      notifyListeners();
    } else {
      print("..");
    }
  }

  //delete prooooooooooooducs
  Future<void> deleteproducts(String id) async {
    final url = "https://myapplication4-f5e61.firebaseio.com/products/$id.json?auth=$authToken";
    final existingproductindex = _iteams.indexWhere((prod) => prod.id == id);
    var existingproduct = _iteams[existingproductindex];

    _iteams.removeAt(existingproductindex);
    notifyListeners();

    final response = await http.delete(url);
    // .then((response) {
    if (response.statusCode >= 400) {
      _iteams.insert(existingproductindex, existingproduct);
      notifyListeners();
      throw HttpException("could not delete product");
    }
    existingproduct = null;

    // }).catchError((_) {
  }
}
