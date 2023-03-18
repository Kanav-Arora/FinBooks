import 'package:flutter/material.dart';
import '../classes/item.dart';

class ItemProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Item> _items = [
    Item(
        id: "I1", name: "Cotton", gstSlab: "15", quantity: "90", price: "59.70")
  ];

  List<Item> get items {
    return _items;
  }
}
