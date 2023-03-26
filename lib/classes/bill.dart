import 'ordered_item.dart';

class Bill {
  String billNo;
  String paymentType;
  String accName;
  String billDate;
  String dueDate;
  List<OrderedItem> items = [];

  Bill({
    required this.billNo,
    required this.paymentType,
    required this.accName,
    required this.billDate,
    required this.dueDate,
  });
}
