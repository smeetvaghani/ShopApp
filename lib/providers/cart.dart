import 'package:flutter/foundation.dart';

class Cartiteam {
  final String id;
  final String title;
  final int quantity;
  final double price;

  Cartiteam({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, Cartiteam> _iteams = {};

  Map<String, Cartiteam> get iteams {
    return {..._iteams};
  }

  int get iteamcount {
    return _iteams.length;
  }

  double get totalAmount {
    var total = 0.0;
    _iteams.forEach((key, cartiteam) {
      total += cartiteam.price * cartiteam.quantity;
    });
    return total;
  }

  //add iteam
  void additeam(
    String productid,
    String title,
    double price,
  ) {
    if (_iteams.containsKey(productid)) {
      _iteams.update(
        productid,
        (allreadyiteam) => Cartiteam(
          id: allreadyiteam.id,
          title: allreadyiteam.title,
          quantity: allreadyiteam.quantity + 1,
          price: allreadyiteam.price,
        ),
      );
    } else {
      _iteams.putIfAbsent(
          productid,
          () => Cartiteam(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  //remove iteam

  void removeiteam(String productid) {
    _iteams.remove(productid);
    notifyListeners();
  }

  //clear all itaem
  void clear() {
    _iteams = {};
    notifyListeners();
  }

  //undo cart
  void removesingleiteam(String productid) {
    if (!_iteams.containsKey(productid)) {
      return;
    }
    if (_iteams[productid].quantity > 1) {
      _iteams.update(
        productid,
        (allreadyiteam) => Cartiteam(
          id: allreadyiteam.id,
          title: allreadyiteam.title,
          quantity: allreadyiteam.quantity - 1,
          price: allreadyiteam.price,
        ),
      );
    } else {
      _iteams.remove(productid);
      notifyListeners();
    }
  }
}
