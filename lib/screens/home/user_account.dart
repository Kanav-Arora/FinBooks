import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';

class UserAccount extends StatelessWidget {
  const UserAccount({super.key});
  static const String routeName = "UserAccount";
  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final settingsProv = Provider.of<SettingsProvider>(context, listen: false);
    print(FirebaseAuth.instance.currentUser);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'A C C O U N T',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Save'),
          ),
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: th.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            Row(
              children: [
                SizedBox(
                    width: (size.width - 50) / 3, child: const Text('Name')),
                SizedBox(
                  width: (size.width - 50) / 3,
                  height: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "Name",
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 130, 130, 130)),
                      fillColor: settingsProv.isDark == true
                          ? const Color.fromARGB(255, 23, 23, 23)
                          : Colors.white,
                      filled: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 23, 23, 23),
                          width: 4.0,
                        ),
                      ),
                    ),
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
