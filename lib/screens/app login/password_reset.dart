import 'package:accouting_software/screens/app%20login/login_screen.dart';
import 'package:accouting_software/utils/utitlities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';

class PasswordReset extends StatelessWidget {
  static const String routeName = "PasswordReset";
  final TextEditingController _emailController = TextEditingController();
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
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
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
            height: 30,
          ),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            decoration: InputDecoration(
              hintText: 'Enter your email address',
              hintStyle:
                  const TextStyle(color: Color.fromARGB(255, 130, 130, 130)),
              fillColor: const Color.fromARGB(255, 23, 23, 23),
              filled: true,
              hoverColor: Theme.of(context).colorScheme.secondary,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blueAccent)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () async {
                try {
                  List<String> list = await FirebaseAuth.instance
                      .fetchSignInMethodsForEmail(_emailController.text);
                  bool emailExists = list.isNotEmpty ? true : false;
                  if (emailExists) {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: _emailController.text);
                  } else {
                    Utilities().toastMessage("Email does not exists");
                  }
                } catch (error) {
                  Utilities().toastMessage(error.toString());
                }
              },
              child: Text(
                'Send Email',
                style: th.textTheme.titleMedium,
              ))
        ]),
      ),
    );
  }
}
