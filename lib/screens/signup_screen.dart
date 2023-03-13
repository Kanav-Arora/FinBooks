import 'package:accouting_software/icons/custom_icons_icons.dart';
import 'package:accouting_software/screens/home_screen.dart';
import 'package:accouting_software/screens/login_screen.dart';
import 'package:accouting_software/services/auth.dart';
import 'package:accouting_software/utils/utitlities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupScreen extends StatefulWidget {
  static final String routeName = 'SignupScreen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formkey = GlobalKey<FormState>();
  var emailValid = false;
  var passValid = false;
  var _isLoading = false;

  String email = "", password = "";

  @override
  void initState() {
    // TODO: implement initState
    emailValid = false;
    passValid = false;
    _isLoading = false;
    super.initState();
  }

  void _saveForm() async {
    final isValid = _formkey.currentState?.validate();
    if (isValid == false) return;
    _formkey.currentState!.save();
    try {
      setState(() {
        _isLoading = true;
      });
      await Auth()
          .signup(email.toString(), password.toString())
          .then((_) async {
        await Auth().login(email, password).whenComplete(() {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        });
      });
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
              'Sign up',
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
                        onChanged: (value) {
                          final bool check = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                          setState(() {
                            emailValid = check;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty == true) {
                            return 'Empty';
                          } else if (!emailValid) {
                            return 'Invalid email address';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          email = newValue as String;
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: Theme.of(context).textTheme.labelMedium,
                        decoration: InputDecoration(
                          suffixIcon: emailValid == true
                              ? const Icon(
                                  CustomIcons.ok_circled,
                                  color: Colors.green,
                                  size: 18,
                                )
                              : null,
                          hintText: 'abc@example.com',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 130, 130, 130)),
                          fillColor: const Color.fromARGB(255, 23, 23, 23),
                          filled: true,
                          hoverColor: Theme.of(context).colorScheme.secondary,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: emailValid == true
                                ? const BorderSide(color: Colors.green)
                                : const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: emailValid == true
                                ? const BorderSide(color: Colors.green)
                                : const BorderSide(
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
                        onChanged: (value) {
                          final bool check = RegExp(
                                  r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
                              .hasMatch(value);
                          setState(() {
                            passValid = check;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty == true) {
                            return 'Empty';
                          } else if (value.length < 8) {
                            return 'Too short';
                          } else if (!value.contains(RegExp(r'[a-z]'))) {
                            return 'Atleast one lowercase character';
                          } else if (!value.contains(RegExp(r'[A-Z]'))) {
                            return 'Atleast one uppercase character';
                          } else if (!value
                              .contains(RegExp(r'(?=.*?[@$!%*?&])'))) {
                            return 'Atleast one special character';
                          } else if (value.contains(RegExp(r"[\s]"))) {
                            return 'No whitespaces';
                          } else if (!value.contains(RegExp(r'[0-9]'))) {
                            return "Atleast one numeric character";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          password = newValue as String;
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                        decoration: InputDecoration(
                          suffixIcon: passValid == true
                              ? const Icon(
                                  CustomIcons.ok_circled,
                                  color: Colors.green,
                                  size: 18,
                                )
                              : null,
                          hintText: 'Pick a strong password',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 130, 130, 130)),
                          fillColor: const Color.fromARGB(255, 23, 23, 23),
                          filled: true,
                          hoverColor: Theme.of(context).colorScheme.secondary,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: passValid == true
                                ? const BorderSide(color: Colors.green)
                                : const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: passValid == true
                                ? const BorderSide(color: Colors.green)
                                : const BorderSide(
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
                                'Sign Up',
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
                        'Already have an account?',
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
                              .pushReplacementNamed(LoginScreen.routeName);
                        },
                        child: Text(
                          'Log in',
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
                          width: 130,
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
