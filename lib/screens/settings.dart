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

  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final prov = Provider.of<SettingsProvider>(context, listen: false);
    _notifierDarkMode.value = prov.isDark;
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
                        prov.toggleDarkMode(value);
                        value == false
                            ? AdaptiveTheme.of(context).setLight()
                            : AdaptiveTheme.of(context).setDark();
                      },
                    );
                  },
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
