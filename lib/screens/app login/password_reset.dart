import 'package:accouting_software/screens/app%20login/login_screen.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';

class PasswordReset extends StatelessWidget {
  static const String routeName = "PasswordReset";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final settingsProv = Provider.of<SettingsProvider>(context, listen: false);
    final th = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pushNamed(LoginScreen.routeName);
          },
        ),
        foregroundColor: th.colorScheme.secondary,
        elevation: 0,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(20),
        color: Theme.of(context).primaryColor,
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
              'Password reset mail will be sent on the registered email address.'),
          const SizedBox(
            height: 10,
          ),
          const TextField(),
          const SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: null,
              child: Text(
                'Send Email',
                style: th.textTheme.titleMedium,
              ))
        ]),
      ),
    );
  }
}
