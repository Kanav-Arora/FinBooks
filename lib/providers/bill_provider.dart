import 'package:accouting_software/classes/bill.dart';
import 'package:accouting_software/classes/ordered_item.dart';
import 'package:accouting_software/providers/items_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../classes/item.dart';

class BillProvider with ChangeNotifier {
  List<Bill> _bills = [];
  List<Bill> get bills {
    return _bills;
  }

  Future<void> createBill(BuildContext ctx, Bill newBill) async {
    try {
      var user = FirebaseAuth.instance.currentUser!.uid;
      DatabaseReference userRef = FirebaseDatabase.instance.ref('user/$user');
      DatabaseReference refBills = userRef.child('bills').child(newBill.billNo);
      await refBills.set({
        "paymentType": newBill.paymentType,
        "accName": newBill.accName,
        "billDate": newBill.billDate,
        "dueDate": newBill.dueDate,
        "billType": newBill.billType,
      });
      for (var element in newBill.items) {
        DatabaseReference refBillItems =
            refBills.child('items').child(element.itemName);
        await refBillItems.set({
          "price": element.price,
          "qty": element.qty,
          "disc": element.disc,
          "gst": element.gst
        });
        final itemProvider = Provider.of<ItemProvider>(ctx, listen: false);
        Item obj = itemProvider.getItemByName(element.itemName);
        int newQuantity = 0;
        if (newBill.billType == "sale") {
          newQuantity = int.parse(obj.quantity) - int.parse(element.qty);
        } else {
          newQuantity = int.parse(obj.quantity) + int.parse(element.qty);
        }
        Item newObj = Item(
            id: obj.id,
            name: obj.name,
            gstSlab: obj.gstSlab,
            quantity: newQuantity.toString(),
            price: obj.price);
        itemProvider.updateQuantityBySale(obj.id, newObj);
        DatabaseReference refItems = userRef.child('items').child(obj.id);
        await refItems.update({"qty": newQuantity.toString()});
        _bills.add(newBill);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future snapshotValue(dataSnapshot) async {
    List<Bill> temp = [];
    dataSnapshot.value!.forEach((key, value) {
      List<OrderedItem> ls = [];
      value['items']!.forEach((inkey, inval) {
        OrderedItem n = OrderedItem(
            itemName: inkey,
            price: inval['price'],
            qty: inval['qty'],
            disc: inval['disc'],
            gst: inval['gst']);
        ls.add(n);
      });
      Bill a = Bill(
          billNo: key,
          paymentType: value['paymentType'],
          accName: value['accName'],
          billDate: value['billDate'],
          dueDate: value['dueDate'],
          billType: value['billType']);
      a.items = ls;
      temp.add(a);
    });
    temp.sort((a, b) => a.billDate.compareTo(b.billDate));
    _bills = temp;
  }

  Future<void> fetch() async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('user/$user').child('bills');
    try {
      final response = await ref.get();
      if (response.value != null) {
        snapshotValue(response);
      } else {
        _bills = [];
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<String>> priceValues(String name) async {
    await fetch();
    String lastP = "0", minP = "", maxP = "0";
    for (var element in bills) {
      for (var m in element.items) {
        if (m.itemName == name) {
          lastP = lastP == "0" ? m.price : lastP;
          minP = minP == "" ? m.price : minP;

          if (double.parse(m.price) > double.parse(maxP)) {
            maxP = m.price;
          } else if (double.parse(m.price) < double.parse(minP)) {
            minP = m.price;
          }
        }
      }
    }

    if (minP == "") minP = "0";
    List<String> ls = [lastP, minP, maxP];
    return ls;
  }

  Future<List<BillItemDetail>> billByItemName(String name) async {
    List<BillItemDetail> ls = [];
    await fetch();
    for (var element in bills) {
      String quantity = "0", price = "0";
      for (var m in element.items) {
        if (m.itemName == name) {
          quantity = m.qty;
          price = m.price;
        }
      }
      if (quantity != "0") {
        ls.add(BillItemDetail(
            billNo: element.billNo,
            accName: element.accName,
            billDate: element.billDate,
            qty: quantity,
            price: price));
      }
    }
    return ls;
  }
}
