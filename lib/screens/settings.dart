import 'package:accouting_software/providers/settings_provider.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  static const String routeName = "Settings";

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final ValueNotifier _notifierDarkMode = ValueNotifier(false);
  final ValueNotifier _notifierCurrency = ValueNotifier("");
  final ValueNotifier _notifierUnits = ValueNotifier("");

  late List<String> _currencyList;
  late List<String> _unitsList;

  @override
  void initState() {
    // TODO: implement initState
    _currencyList = ["₹ INR", "\$ USD", "£ GBP", "¥ JPY"];
    _unitsList = ["Units", "Kg", "Ltr"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final prov = Provider.of<SettingsProvider>(context, listen: false);
    _notifierDarkMode.value = prov.isDark;
    _notifierCurrency.value = prov.currency;
    _notifierUnits.value = prov.units;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: th.colorScheme.secondary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'S E T T I N G S',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: th.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dark mode',
                  style: th.textTheme.bodyMedium,
                ),
                ValueListenableBuilder(
                  valueListenable: _notifierDarkMode,
                  builder: (ctx, value, child) {
                    return Switch(
                      activeColor: const Color.fromARGB(185, 23, 23, 23),
                      inactiveThumbColor: const Color.fromARGB(185, 23, 23, 23),
                      inactiveTrackColor: Colors.black,
                      activeTrackColor: Colors.white,
                      value: _notifierDarkMode.value,
                      onChanged: (bool value) {
                        _notifierDarkMode.value = value;
                        prov.toggleDarkMode(_notifierDarkMode.value);
                        _notifierDarkMode.value == false
                            ? AdaptiveTheme.of(context).setLight()
                            : AdaptiveTheme.of(context).setDark();
                      },
                    );
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Currency',
                  style: th.textTheme.bodyMedium,
                ),
                SizedBox(
                  width: (size.width - 40) / 4,
                  child: ValueListenableBuilder(
                    valueListenable: _notifierCurrency,
                    builder: ((ctx, value, child) {
                      return DropdownButton<String>(
                          iconSize: 0.0,
                          alignment: AlignmentDirectional.center,
                          hint: Text(
                            'Currency',
                            style: th.textTheme.bodyMedium!.copyWith(
                                color:
                                    const Color.fromARGB(255, 130, 130, 130)),
                            textAlign: TextAlign.center,
                          ),
                          value: _notifierCurrency.value == ""
                              ? null
                              : _notifierCurrency.value,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.grey,
                          ),
                          dropdownColor: prov.isDark == true
                              ? const Color.fromARGB(255, 23, 23, 23)
                              : Colors.white,
                          onChanged: (String? value) {
                            _notifierCurrency.value = value.toString();
                            prov.currency = _notifierCurrency.value;
                          },
                          items: _currencyList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Center(
                                child: Text(
                                  value,
                                  style: th.textTheme.bodyMedium,
                                ),
                              ),
                            );
                          }).toList());
                    }),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Unit',
                  style: th.textTheme.bodyMedium,
                ),
                SizedBox(
                  width: (size.width - 40) / 4,
                  child: ValueListenableBuilder(
                    valueListenable: _notifierCurrency,
                    builder: ((ctx, value, child) {
                      return DropdownButton<String>(
                          iconSize: 0.0,
                          alignment: AlignmentDirectional.center,
                          hint: Text(
                            'Unit',
                            style: th.textTheme.bodyMedium!.copyWith(
                                color:
                                    const Color.fromARGB(255, 130, 130, 130)),
                            textAlign: TextAlign.center,
                          ),
                          value: _notifierUnits.value == ""
                              ? null
                              : _notifierUnits.value,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: Colors.grey,
                          ),
                          dropdownColor: prov.isDark == true
                              ? const Color.fromARGB(255, 23, 23, 23)
                              : Colors.white,
                          onChanged: (String? value) {
                            _notifierUnits.value = value.toString();
                            prov.units = _notifierUnits.value;
                          },
                          items: _unitsList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Center(
                                child: Text(
                                  value,
                                  style: th.textTheme.bodyMedium,
                                ),
                              ),
                            );
                          }).toList());
                    }),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
