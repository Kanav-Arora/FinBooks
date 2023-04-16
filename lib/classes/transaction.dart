class Transaction {
  String name;
  String acc_name;
  String type; // sale, purchase, voucher
  String chequeNo = "";
  String amount;
  String date;

  Transaction({
    required this.name,
    required this.acc_name,
    required this.type,
    required this.amount,
    required this.date,
    this.chequeNo = "",
  });
}
