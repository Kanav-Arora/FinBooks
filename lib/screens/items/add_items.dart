import 'package:accouting_software/classes/item.dart';
import 'package:accouting_software/providers/items_provider.dart';
import 'package:accouting_software/screens/items/items_main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddItems extends StatefulWidget {
  static const String routeName = "AddItems";

  const AddItems({super.key});

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _isLoading = false;

  final _formkey = GlobalKey<FormState>();

  late List<String> _gstSlabsList;
  var gstValue;

  @override
  void initState() {
    _isLoading = false;
    _gstSlabsList = <String>["5%", "12%", "18%", "28%"];
    var gstValue;
    super.initState();
  }

  Item a = Item(
    id: "",
    name: "",
    gstSlab: "",
    quantity: "0",
    price: "",
  );

  void _saveForm() {
    _formkey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'A D D\nI T E M',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading == true
                ? null
                : () async {
                    _saveForm();
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<ItemProvider>(context, listen: false)
                        .AddItems(a)
                        .then((_) => Navigator.of(context)
                            .pushReplacementNamed(ItemsMain.routeName));
                  },
            child: Container(
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: th.primaryColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width / 5,
                        child: TextFormField(
                          onSaved: (newValue) {
                            a = Item(
                              id: newValue.toString(),
                              name: a.name,
                              gstSlab: a.gstSlab,
                              quantity: a.quantity,
                              price: a.price,
                            );
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: "Id",
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 130, 130, 130)),
                            fillColor: Color.fromARGB(255, 23, 23, 23),
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextFormField(
                          onSaved: (newValue) {
                            a = Item(
                              id: a.id,
                              name: newValue.toString(),
                              gstSlab: a.gstSlab,
                              quantity: a.quantity,
                              price: a.price,
                            );
                          },
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: "Name",
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 130, 130, 130)),
                            fillColor: Color.fromARGB(255, 23, 23, 23),
                            filled: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width / 2.5,
                        child: DropdownButton<String>(
                            hint: Text(
                              'GST Slab',
                              style: th.textTheme.bodyMedium!.copyWith(
                                  color:
                                      const Color.fromARGB(255, 130, 130, 130)),
                              textAlign: TextAlign.center,
                            ),
                            value: gstValue,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.grey,
                            ),
                            dropdownColor:
                                const Color.fromARGB(255, 23, 23, 23),
                            onChanged: (String? value) {
                              setState(() {
                                gstValue = value ?? "";
                              });
                              a = Item(
                                id: a.id,
                                name: a.name,
                                gstSlab: value.toString(),
                                quantity: a.quantity,
                                price: a.price,
                              );
                            },
                            items: _gstSlabsList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: th.textTheme.bodyMedium,
                                ),
                              );
                            }).toList()),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextFormField(
                          onSaved: (newValue) {
                            a = Item(
                              id: a.id,
                              name: a.name,
                              gstSlab: a.gstSlab,
                              quantity: a.quantity,
                              price: newValue.toString(),
                            );
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: "Price in Rupees",
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 130, 130, 130)),
                            fillColor: Color.fromARGB(255, 23, 23, 23),
                            filled: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                      "Note: Once added, only item GST slab and price can be changed."),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
