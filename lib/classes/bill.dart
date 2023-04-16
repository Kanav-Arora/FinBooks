import 'ordered_item.dart';

class Bill {
  String billNo;
  String paymentType;
  String accName;
  String billDate;
  String dueDate;
  String billType; // Sale or purchase
  List<OrderedItem> items = [];

  Bill({
    required this.billNo,
    required this.paymentType,
    required this.accName,
    required this.billDate,
    required this.dueDate,
    required this.billType,
  });
}

class BillItemDetail {
  String billNo;
  String accName;
  String billDate;
  String qty;
  String price;

  BillItemDetail({
    required this.billNo,
    required this.accName,
    required this.billDate,
    required this.qty,
    required this.price,
  });
}
