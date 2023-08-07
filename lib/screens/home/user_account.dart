import 'package:accouting_software/screens/app%20login/re_auth_screen.dart';
import 'package:accouting_software/utils/utitlities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});
  static const String routeName = "UserAccount";

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ValueNotifier<bool> _notifierDone = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _notifierVerified = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final settingsProv = Provider.of<SettingsProvider>(context, listen: false);
    final data = FirebaseAuth.instance.currentUser;
    _notifierVerified.value = data!.emailVerified;
    _nameController.text =
        data.displayName == null ? "" : data.displayName.toString();
    _phoneController.text =
        data.phoneNumber == null ? "" : data.phoneNumber.toString();
    _emailController.text = data.email == null ? "" : data.email.toString();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'A C C O U N T',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          ValueListenableBuilder(
              valueListenable: _notifierDone,
              builder: (context, value, child) {
                return TextButton(
                    onPressed: _notifierDone.value == false
                        ? null
                        : () async {
                            if (_nameController.text != "" &&
                                _nameController.text != data.displayName) {
                              try {
                                await data
                                    .updateDisplayName(_nameController.text)
                                    .whenComplete(() {
                                  _notifierDone.value = false;
                                });
                                Utilities().successMessage(
                                    "Name updated successfully");
                              } catch (error) {
                                Utilities().toastMessage(error.toString());
                              }
                            }

                            if ((_phoneController.text != "" &&
                                    _phoneController.text !=
                                        data.phoneNumber) &&
                                _emailController.text != data.email &&
                                _emailController.text != "") {
                              Utilities().toastMessage(
                                  "Unable to update phone number and email at same time.");
                              // _phoneController.text = data.phoneNumber == null
                              //     ? ""
                              //     : data.phoneNumber as String;
                              // _emailController.text = data.email == null
                              //     ? ""
                              //     : data.email as String;
                              Navigator.of(context)
                                  .pushReplacementNamed(UserAccount.routeName);
                            }
                            // if (_phoneController.text != "" &&
                            //     _phoneController.text != data.phoneNumber) {
                            //   await data.updatePhoneNumber(PhoneAuthCredential);
                            // }
                            else if (_emailController.text != data.email &&
                                _emailController.text != "") {
                              Navigator.of(context).pushNamed(
                                  ReAuthScreen.routeName,
                                  arguments: _emailController.text);
                            }
                          },
                    child: Text(
                      'Done',
                      style: th.textTheme.bodyMedium!.copyWith(
                          fontSize: 17,
                          color: _notifierDone.value == false
                              ? Colors.grey
                              : Colors.white),
                    ));
              }),
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: th.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: (size.width - 50) / 2.3,
                  height: 50,
                  child: TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      if ((_nameController.text == data.displayName ||
                              _nameController.text == "") &&
                          (_phoneController.text == data.phoneNumber ||
                              _phoneController.text == "") &&
                          (_emailController.text == data.email ||
                              _emailController.text == "")) {
                        _notifierDone.value = false;
                      } else {
                        _notifierDone.value = true;
                      }
                    },
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
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: SizedBox(
                    width: (size.width - 50) / 2.3,
                    height: 50,
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        if ((_nameController.text == data.displayName ||
                                _nameController.text == "") &&
                            (_phoneController.text == data.phoneNumber ||
                                _phoneController.text == "") &&
                            (_emailController.text == data.email ||
                                _emailController.text == "")) {
                          _notifierDone.value = false;
                        } else {
                          _notifierDone.value = true;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Phone Number",
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
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              child: ValueListenableBuilder(
                builder: (context, value, child) {
                  return TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      if ((_nameController.text == data.displayName ||
                              _nameController.text == "") &&
                          (_phoneController.text == data.phoneNumber ||
                              _phoneController.text == "") &&
                          (_emailController.text == data.email ||
                              _emailController.text == "")) {
                        _notifierDone.value = false;
                      } else {
                        _notifierDone.value = true;
                      }

                      if (_emailController.text != data.email) {
                        _notifierVerified.value = false;
                      } else {
                        _notifierVerified.value = true;
                      }
                    },
                    decoration: InputDecoration(
                      labelText:
                          _notifierVerified.value == true ? "Verified" : "",
                      labelStyle:
                          const TextStyle(color: Colors.lightGreenAccent),
                      hintText: "Email ID",
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
                  );
                },
                valueListenable: _notifierVerified,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: size.width,
                child: Text(
                  'Note:',
                  style: th.textTheme.bodyMedium!.copyWith(fontSize: 16),
                )),
            const SizedBox(
              height: 5,
            ),
            const Text(
                'Phone Number and Email are sensitive information and updating them involves various verification process. Hence they can be changed one at a time')
          ]),
        ),
      ),
    );
  }
}
