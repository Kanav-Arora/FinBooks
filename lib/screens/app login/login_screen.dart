import 'package:accouting_software/providers/settings_provider.dart';
import 'package:accouting_software/screens/app%20login/password_reset.dart';
import 'package:accouting_software/screens/app%20login/verification_page.dart';
import 'package:accouting_software/screens/home/home_screen.dart';
import 'package:accouting_software/screens/app%20login/signup_screen.dart';
import 'package:accouting_software/services/auth.dart';
import 'package:accouting_software/utils/utitlities.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "LoginScreen";
  AdaptiveThemeMode mode;
  LoginScreen(this.mode, {super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState(mode);
}

class _LoginScreenState extends State<LoginScreen> {
  AdaptiveThemeMode mode;
  _LoginScreenState(this.mode);
  final _formkey = GlobalKey<FormState>();
  var _isLoading = false;
  String email = "", password = "";

  @override
  void initState() {
    // TODO: implement initState
    _isLoading = false;
    super.initState();
  }

  void _saveForm() async {
    final isValid = _formkey.currentState?.validate();
    if (isValid == false) return;
    _formkey.currentState!.save();
    try {
      await Auth().login(email, password).whenComplete(() {
        if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        } else {
          Navigator.of(context)
              .pushReplacementNamed(VerificationPage.routeName);
        }
      });
    } catch (e) {
      Utilities().toastMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final settingsProv = Provider.of<SettingsProvider>(context, listen: false);
    final th = Theme.of(context);
    ValueNotifier viz = ValueNotifier(false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        titleSpacing: 20,
        elevation: 0,
        title: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Log in',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
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
                          hintText: 'abc@example.com',
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
                      ValueListenableBuilder(
                          valueListenable: viz,
                          builder: (context, value, child) {
                            return TextFormField(
                              obscureText: viz.value == false ? true : false,
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
                                suffixIcon: IconButton(
                                  icon: viz.value == false
                                      ? const Icon(
                                          Icons.visibility_off_outlined,
                                          color: Color.fromARGB(
                                              255, 130, 130, 130),
                                        )
                                      : const Icon(
                                          Icons.visibility_outlined,
                                          color: Color.fromARGB(
                                              255, 130, 130, 130),
                                        ),
                                  onPressed: () {
                                    viz.value = !viz.value;
                                  },
                                ),
                                hintText: 'Pick a strong password',
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
                            );
                          }),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(PasswordReset.routeName);
                  },
                  child: Text('Forgot Password ?',
                      style: th.textTheme.bodyMedium!.copyWith(
                          color: const Color.fromARGB(255, 97, 151, 246))),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  MaterialButton(
                    onPressed: () => _saveForm(),
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
                                'Log In',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignupScreen.routeName);
                        },
                        child: Text(
                          'Sign Up',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
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
