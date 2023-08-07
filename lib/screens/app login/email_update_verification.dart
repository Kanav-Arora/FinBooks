import 'dart:async';

import 'package:accouting_software/screens/home/home_screen.dart';
import 'package:accouting_software/utils/utitlities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailUpdateVerification extends StatefulWidget {
  const EmailUpdateVerification({super.key});
  static const String routeName = "EmailUpdateVerification";

  @override
  State<EmailUpdateVerification> createState() =>
      _EmailUpdateVerificationState();
}

class _EmailUpdateVerificationState extends State<EmailUpdateVerification> {
  String id = "";
  late AuthCredential cred;

  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ThemeData th = Theme.of(context);
    final routeData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    id = routeData["email"];
    cred = routeData["cred"];
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
              onPressed: () async {
                await FirebaseAuth.instance.currentUser!
                    .reauthenticateWithCredential(EmailAuthProvider.credential(
                        email: id, password: routeData["pass"]))
                    .then((value) async {
                  await FirebaseAuth.instance.currentUser?.reload();
                });

                bool emailVerified =
                    FirebaseAuth.instance.currentUser!.emailVerified;

                if (emailVerified) {
                  Utilities().successMessage("Email updated successfully");
                } else {
                  Utilities().toastMessage(
                      "Email update failed. Please try again later");
                }
                Navigator.of(context).pushNamedAndRemoveUntil(
                    HomeScreen.routeName, (Route<dynamic> route) => false);
              },
              child: Text('Next',
                  style: th.textTheme.bodyMedium!.copyWith(fontSize: 17)))
        ],
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        width: size.width,
        height: size.height,
        child: FutureBuilder(
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 35),
                Center(
                  child: Text(
                    'Check your Email',
                    textAlign: TextAlign.center,
                    style: th.textTheme.labelMedium,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Center(
                    child: Text(
                      'We have sent you a Email on  $id',
                      textAlign: TextAlign.center,
                      style: th.textTheme.labelMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Center(
                    child: Text('After verifying the email click next button',
                        textAlign: TextAlign.center,
                        style: th.textTheme.labelMedium),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    child: const Text('Resend'),
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.currentUser!
                            .reauthenticateWithCredential(cred)
                            .then((value) async {
                          await FirebaseAuth.instance.currentUser
                              ?.verifyBeforeUpdateEmail(id);
                        });
                      } catch (e) {
                        Utilities().toastMessage(e.toString());
                      }
                    },
                  ),
                ),
              ],
            );
          },
          future: () async {
            await FirebaseAuth.instance.currentUser!
                .reauthenticateWithCredential(cred)
                .then((value) async {
              await FirebaseAuth.instance.currentUser
                  ?.verifyBeforeUpdateEmail(id);
            });
          }(),
        ),
      ),
    );
  }
}
