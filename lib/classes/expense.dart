class Expense {
  String id = "";
  String category;
  String date;
  String message = "";
  String amount;

  Expense(
      {required this.category,
      required this.date,
      required this.amount,
      this.id = "",
      this.message = ""});
}
