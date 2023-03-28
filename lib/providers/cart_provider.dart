import 'package:accouting_software/classes/ordered_item.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final Map<String, OrderedItem> _cartItems = {};

  Map<String, OrderedItem> get cartItems {
    return _cartItems;
  }

  int get itemCount {
    return _cartItems.length;
  }

  void add(String itemName, String price, String quantity, String discount,
      String gst) {
    debugPrint('Item added $itemName');
    if (_cartItems.containsKey(itemName)) {
      _cartItems.update(
        itemName,
        (value) => OrderedItem(
            itemName: value.itemName,
            price: value.price,
            qty: (int.parse(value.qty) + int.parse(quantity)).toString(),
            disc: value.disc,
            gst: value.gst),
      );
    } else {
      _cartItems.putIfAbsent(
        itemName,
        () => OrderedItem(
            itemName: itemName,
            price: price,
            qty: quantity,
            disc: discount,
            gst: gst),
      );
    }
    notifyListeners();
  }

  void removeItem(String name) {
    debugPrint('item removed');
    _cartItems.removeWhere((key, value) => key == name);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
