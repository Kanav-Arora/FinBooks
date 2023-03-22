import 'package:accouting_software/classes/item.dart';
import 'package:accouting_software/providers/items_provider.dart';
import 'package:accouting_software/screens/items/items_main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../icons/custom_icons_icons.dart';
import '../../widgets/app_bar_popupmenubutton.dart';
import '../app_drawer.dart';

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
  late var gstValue = "hehe";

  @override
  void initState() {
    _isLoading = false;
    _gstSlabsList = <String>["5%", "12%", "18%", "28%"];
    gstValue = "hehe";
    super.initState();
  }

  Item a = Item(
    id: "",
    name: "",
    gstSlab: "",
    quantity: "",
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
      drawer: AppDrawer(),
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (BuildContext ctx) {
            return IconButton(
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              icon: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Icon(
                    CustomIcons.th_thumb,
                    size: 28,
                    color: Theme.of(context).colorScheme.secondary,
                  )),
            );
          },
        ),
        title: Text(
          'A D D\nI T E M',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [const AppBarPopupmenuButton()],
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
                    height: 100,
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
                          decoration: InputDecoration(
                            hintText: "Id",
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 130, 130, 130)),
                            fillColor: const Color.fromARGB(255, 23, 23, 23),
                            filled: true,
                            hoverColor: Theme.of(context).colorScheme.secondary,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 181, 21, 221),
                              ),
                            ),
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
                          decoration: InputDecoration(
                            hintText: "Name",
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 130, 130, 130)),
                            fillColor: const Color.fromARGB(255, 23, 23, 23),
                            filled: true,
                            hoverColor: Theme.of(context).colorScheme.secondary,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 181, 21, 221),
                              ),
                            ),
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
                              quantity: newValue.toString(),
                              price: a.price,
                            );
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "Quantity",
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 130, 130, 130)),
                            fillColor: const Color.fromARGB(255, 23, 23, 23),
                            filled: true,
                            hoverColor: Theme.of(context).colorScheme.secondary,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 181, 21, 221),
                              ),
                            ),
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
                        width: size.width / 2,
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
                          decoration: InputDecoration(
                            hintText: "Price",
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 130, 130, 130)),
                            fillColor: const Color.fromARGB(255, 23, 23, 23),
                            filled: true,
                            hoverColor: Theme.of(context).colorScheme.secondary,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 181, 21, 221),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "in Rupees",
                        style: th.textTheme.bodyMedium,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      _saveForm();
                      setState(() {
                        _isLoading = true;
                      });
                      await Provider.of<ItemProvider>(context, listen: false)
                          .AddItems(a)
                          .then((_) => Navigator.of(context)
                              .pushReplacementNamed(ItemsMain.routeName));
                    },
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 181, 21, 221),
                            Color.fromARGB(255, 211, 40, 168),
                          ],
                          stops: [0.0, 1.0],
                        ),
                      ),
                      child: Center(
                        child: _isLoading == true
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Add',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
