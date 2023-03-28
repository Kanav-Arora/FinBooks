import 'package:accouting_software/classes/bill.dart';
import 'package:accouting_software/providers/items_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../classes/item.dart';

class BillProvider with ChangeNotifier {
  final List<Bill> _bills = [];
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
      }
    } catch (error) {
      rethrow;
    }
  }
}
