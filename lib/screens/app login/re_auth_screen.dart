import 'package:accouting_software/providers/settings_provider.dart';
import 'package:accouting_software/screens/app%20login/email_update_verification.dart';
import 'package:accouting_software/utils/utitlities.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReAuthScreen extends StatefulWidget {
  static const String routeName = "ReAuthScreen";
  AdaptiveThemeMode mode;
  ReAuthScreen(this.mode, {super.key});
  @override
  State<ReAuthScreen> createState() => _ReAuthScreenState(mode);
}

class _ReAuthScreenState extends State<ReAuthScreen> {
  AdaptiveThemeMode mode;
  _ReAuthScreenState(this.mode);
  final _formkey = GlobalKey<FormState>();
  var _isLoading = false;
  String email = "", password = "";
  var _visPass = false;

  @override
  void initState() {
    // TODO: implement initState
    _isLoading = false;
    _visPass = false;
    super.initState();
  }

  void _saveForm(String newEmail) async {
    final isValid = _formkey.currentState?.validate();
    if (isValid == false) return;
    _formkey.currentState!.save();
    try {
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      final result = await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
      Navigator.of(context).pushNamed(EmailUpdateVerification.routeName,
          arguments: {"cred": credential, "email": newEmail, "pass": password});
    } catch (e) {
      Utilities().toastMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final settingsProv = Provider.of<SettingsProvider>(context, listen: false);
    final newEmail = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        titleSpacing: 20,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.all(20),
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                  'Sensitive changes require reauthentication of the user. Kindly enter valid credentials to proceed.'),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formkey,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Email',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        enabled: true,
                        initialValue:
                            FirebaseAuth.instance.currentUser!.email.toString(),
                        validator: (value) {
                          return value!.isEmpty == true ? 'Empty' : null;
                        },
                        onSaved: (newValue) {
                          email = newValue as String;
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(fontSize: 18),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 130, 130, 130)),
                          fillColor: mode == AdaptiveThemeMode.dark
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
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Password',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: _visPass == true ? false : true,
                        validator: (value) {
                          return value!.isEmpty == true ? 'Empty' : null;
                        },
                        onSaved: (newValue) {
                          password = newValue as String;
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(fontSize: 18),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 130, 130, 130)),
                          fillColor: mode == AdaptiveThemeMode.dark
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
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  MaterialButton(
                    onPressed: () => _saveForm(newEmail),
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      height: 60,
                      // color: Colors.blue,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blueAccent
                          // gradient: const LinearGradient(
                          //   colors: [
                          //     Color.fromARGB(255, 181, 21, 221),
                          //     Color.fromARGB(255, 211, 40, 168),
                          //   ],
                          //   stops: [0.0, 1.0],
                          // ),
                          ),
                      child: Center(
                        child: _isLoading == true
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Proceed',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // Container(
                  //   child: Center(
                  //     child: MaterialButton(
                  //       onPressed: () {},
                  //       padding: const EdgeInsets.all(0),
                  //       child: Container(
                  //         width: 120,
                  //         height: 60,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(15),
                  //           color: const Color.fromARGB(255, 23, 23, 23),
                  //           border: Border.all(
                  //             color: const Color.fromARGB(255, 130, 130, 130),
                  //           ),
                  //         ),
                  //         child: const Center(
                  //           child: Icon(
                  //             CustomIcons.google,
                  //             size: 30,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
