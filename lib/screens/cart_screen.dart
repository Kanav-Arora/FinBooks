import 'package:accouting_software/classes/bill.dart';
import 'package:accouting_software/classes/ordered_item.dart';
import 'package:accouting_software/providers/bill_provider.dart';
import 'package:accouting_software/providers/cart_provider.dart';
import 'package:accouting_software/providers/transaction_provider.dart';
import 'package:accouting_software/screens/purchase/add_purchase.dart';
import 'package:accouting_software/screens/sale/add_sale.dart';
import 'package:accouting_software/utils/utitlities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:accouting_software/classes/transaction.dart' as Trans;

class CartScreen extends StatefulWidget {
  static const String routeName = "CartScreen";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double taxable = 0.0;
  double gst = 0.0;
  TextEditingController taxableController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController finalAmountController = TextEditingController();
  var _isloading = false;
  @override
  void initState() {
    super.initState();
    _isloading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      taxableController.text = '₹ ${taxable.toStringAsFixed(2)}';
      gstController.text = '₹ ${gst.toStringAsFixed(2)}';
      finalAmountController.text = '₹ ${(taxable + gst).toStringAsFixed(2)}';
    });
  }

  void changeLabels() {
    setState(() {
      taxableController.text = '₹ ${taxable.toStringAsFixed(2)}';
      gstController.text = '₹ ${gst.toStringAsFixed(2)}';
      finalAmountController.text = '₹ ${(taxable + gst).toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    Bill argObject = ModalRoute.of(context)!.settings.arguments as Bill;
    final size = MediaQuery.of(context).size;
    final th = Theme.of(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: th.colorScheme.secondary,
        elevation: 0,
      ),
      body: Container(
          padding: const EdgeInsets.all(8.0),
          width: size.width,
          height: size.height,
          color: th.primaryColor,
          child: Column(
            children: [
              cartProvider.itemCount == 0
                  ? const Expanded(
                      child: Center(child: Text('No Items Kiddo!')))
                  : Expanded(
                      child: Consumer<CartProvider>(
                        builder: (ctx, value, _) {
                          return ListView.builder(
                            itemBuilder: ((ctx, index) {
                              String itemName =
                                  value.cartItems.keys.elementAt(index);
                              OrderedItem o =
                                  value.cartItems[itemName] as OrderedItem;
                              String discAmount = (double.parse(o.price) *
                                      (double.parse(o.disc) / 100))
                                  .toStringAsFixed(2);
                              String subAmount = ((double.parse(o.price) -
                                          double.parse(discAmount)) *
                                      int.parse(o.qty))
                                  .toStringAsFixed(2);
                              String gstAmount = (double.parse(subAmount) *
                                      (int.parse(o.gst
                                              .substring(0, o.gst.length - 1)) /
                                          100))
                                  .toStringAsFixed(2);
                              taxable += ((double.parse(o.price) -
                                      double.parse(discAmount)) *
                                  int.parse(o.qty));
                              gst += (double.parse(subAmount) *
                                  (int.parse(o.gst
                                          .substring(0, o.gst.length - 1)) /
                                      100));
                              return Dismissible(
                                key: UniqueKey(),
                                onDismissed: (direction) {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .removeItem(itemName);
                                  taxable -= ((double.parse(o.price) -
                                          double.parse(discAmount)) *
                                      int.parse(o.qty));
                                  gst -= (double.parse(subAmount) *
                                      (int.parse(o.gst
                                              .substring(0, o.gst.length - 1)) /
                                          100));
                                  changeLabels();
                                },
                                child: Card(
                                  elevation: 7,
                                  margin: const EdgeInsets.all(10.0),
                                  color: th.primaryColor,
                                  child: ExpansionTile(
                                    trailing: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: th.colorScheme.secondary,
                                    ),
                                    iconColor: th.colorScheme.secondary,
                                    textColor: th.colorScheme.secondary,
                                    collapsedIconColor:
                                        th.colorScheme.secondary,
                                    collapsedTextColor:
                                        th.colorScheme.secondary,
                                    title: Text(
                                      itemName,
                                      style: TextStyle(
                                          color: th.colorScheme.secondary),
                                    ),
                                    childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Quantity',
                                              style: th.textTheme.bodySmall,
                                            ),
                                            Text(
                                              o.qty,
                                              style: th.textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Price',
                                              style: th.textTheme.bodySmall,
                                            ),
                                            Text(
                                              '₹ ${o.price}',
                                              style: th.textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Discount',
                                              style: th.textTheme.bodySmall,
                                            ),
                                            Text(
                                              '₹ $discAmount (${o.disc}%)',
                                              style: th.textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Amount',
                                              style: th.textTheme.bodySmall,
                                            ),
                                            Text(
                                              '₹ $subAmount',
                                              style: th.textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Gst',
                                              style: th.textTheme.bodySmall,
                                            ),
                                            Text(
                                              '₹ $gstAmount (${o.gst})',
                                              style: th.textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            itemCount: value.itemCount,
                          );
                        },
                      ),
                    ),
              Container(
                margin: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: size.width / 2,
                        child: const Text('Taxable Amount')),
                    Expanded(
                      child: TextField(
                        enabled: false,
                        controller: taxableController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Taxable Amount",
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 130, 130, 130)),
                          fillColor: const Color.fromARGB(255, 23, 23, 23),
                          filled: true,
                          hoverColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: size.width / 2,
                        child: const Text('GST Charged')),
                    Expanded(
                      child: TextField(
                        enabled: false,
                        controller: gstController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "GST",
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 130, 130, 130)),
                          fillColor: const Color.fromARGB(255, 23, 23, 23),
                          filled: true,
                          hoverColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                child: Column(children: [
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: size.width / 2,
                            child: const Text('Amount After Tax')),
                        Expanded(
                          child: TextField(
                            enabled: false,
                            controller: finalAmountController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Total Amount",
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 130, 130, 130)),
                              fillColor: const Color.fromARGB(255, 23, 23, 23),
                              filled: true,
                              hoverColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            width: 1.0, color: th.colorScheme.secondary),
                      ),
                      onPressed: cartProvider.itemCount == 0
                          ? null
                          : () async {
                              argObject.items =
                                  cartProvider.cartItems.values.toList();
                              final navigator = Navigator.of(context);
                              try {
                                setState(() {
                                  _isloading = true;
                                });
                                await Provider.of<BillProvider>(context,
                                        listen: false)
                                    .createBill(context, argObject);
                                String n = argObject.billType == "sale"
                                    ? "Sale"
                                    : "Purchase";
                                Trans.Transaction a = Trans.Transaction(
                                    name: "$n: ${argObject.billNo}",
                                    acc_name: argObject.accName,
                                    type: argObject.billType,
                                    amount: finalAmountController.text,
                                    date: argObject.billDate);
                                await Provider.of<TransactionProvider>(context,
                                        listen: false)
                                    .addTransaction(a);
                                if (argObject.paymentType == "cash") {
                                  Trans.Transaction b = Trans.Transaction(
                                      name: "Cash-$n: ${argObject.billNo}",
                                      acc_name: argObject.accName,
                                      type: n == "Sale"
                                          ? "voucher-sale"
                                          : "voucher-purchase",
                                      amount: finalAmountController.text,
                                      date: argObject.billDate);
                                  await Provider.of<TransactionProvider>(
                                          context,
                                          listen: false)
                                      .addTransaction(b);
                                }
                                cartProvider.clearCart();
                                setState(() {
                                  _isloading = false;
                                });
                                navigator.pushReplacementNamed(n == "Sale"
                                    ? AddSale.routeName
                                    : AddPurchase.routeName);
                              } catch (error) {
                                Utilities()
                                    .toastMessage('Unable to generate bill');
                              }
                            },
                      child: _isloading == true
                          ? const CircularProgressIndicator()
                          : Text(
                              'Generate Bill',
                              style: th.textTheme.bodyMedium,
                            )),
                  const SizedBox(
                    height: 40,
                  ),
                ]),
              )
            ],
          )),
    );
  }
}
