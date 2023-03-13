import 'package:accouting_software/icons/custom_icons_icons.dart';
import 'package:accouting_software/screens/home_screen.dart';
import 'package:accouting_software/screens/signup_screen.dart';
import 'package:accouting_software/services/auth.dart';
import 'package:accouting_software/utils/utitlities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  static final String routeName = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      await Auth().login(email, password).whenComplete(() =>
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName));
    } catch (e) {
      Utilities().toastMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
                        style: Theme.of(context).textTheme.labelMedium,
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
                        style: Theme.of(context).textTheme.labelMedium,
                        decoration: InputDecoration(
                          hintText: 'abc@example.com',
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
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Password',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          return value!.isEmpty == true ? 'Empty' : null;
                        },
                        onSaved: (newValue) {
                          password = newValue as String;
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                        decoration: InputDecoration(
                          hintText: 'Pick a strong password',
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
                  Container(
                    child: Center(
                      child: MaterialButton(
                        onPressed: () {},
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          width: 120,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 23, 23, 23),
                            border: Border.all(
                              color: const Color.fromARGB(255, 130, 130, 130),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              CustomIcons.google,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
