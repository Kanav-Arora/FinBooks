class Expense {
  String category;
  String date;
  String message = "";
  String amount;

  Expense(
      {required this.category,
      required this.date,
      required this.amount,
      this.message = ""});
}
