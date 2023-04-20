import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/item.dart';

class ItemProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Item> _items = [];

  Future<List<Item>> get items async {
    await fetch();
    return _items;
  }

  Future<void> AddItems(Item a) async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    var id = a.id.toString();
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('user/$user').child('items').child(id);
    try {
      await ref.set({
        "name": a.name,
        "gst": a.gstSlab,
        "qty": a.quantity,
        "price": a.price
      });
      _items.add(a);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future snapshotValue(dataSnapshot) async {
    List<Item> temp = [];
    dataSnapshot.value!.forEach((key, value) {
      Item a = Item(
        id: key,
        name: value['name'],
        gstSlab: value['gst'],
        quantity: value['qty'],
        price: value['price'],
      );
      temp.add(a);
    });
    temp.sort(((a, b) => a.name.compareTo(b.name)));
    _items = temp;
  }

  Future<void> fetch() async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('user/$user').child('items');
    try {
      final response = await ref.get();
      if (response.value != null) {
        snapshotValue(response);
      } else {
        _items = [];
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Item getItemByName(String name) {
    return _items.firstWhere((element) => element.name == name);
  }

  void updateQuantityBySale(String id, Item obj) {
    _items.removeWhere((element) => element.id == id);
    _items.insert(0, obj);
  }

  Future<void> updateItem(Item obj, String gst, String price) async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    var id = obj.id;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('user/$user').child('items').child(id);
    try {
      await ref.set({
        "name": obj.name,
        "qty": obj.quantity,
        "gst": gst,
        "price": price,
      });
      var ls = items;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
