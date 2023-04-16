import 'dart:async';
import 'package:accouting_software/providers/accounts_provider.dart';
import 'package:accouting_software/providers/bill_provider.dart';
import 'package:accouting_software/providers/cart_provider.dart';
import 'package:accouting_software/providers/items_provider.dart';
import 'package:accouting_software/providers/transaction_provider.dart';
import 'package:accouting_software/screens/accounts/accounts_main.dart';
import 'package:accouting_software/screens/accounts/add_account.dart';
import 'package:accouting_software/screens/cart_screen.dart';
import 'package:accouting_software/screens/home_screen.dart';
import 'package:accouting_software/screens/items/add_items.dart';
import 'package:accouting_software/screens/items/items_detail.dart';
import 'package:accouting_software/screens/items/items_main.dart';
import 'package:accouting_software/screens/ledger%20accounts/ledger_main.dart';
import 'package:accouting_software/screens/login_screen.dart';
import 'package:accouting_software/screens/purchase/add_purchase.dart';
import 'package:accouting_software/screens/sale/add_sale.dart';
import 'package:accouting_software/screens/signup_screen.dart';
import 'package:accouting_software/screens/user_account.dart';
import 'package:accouting_software/screens/verification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAuth.instance.signOut();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> user;
  @override
  void initState() {
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
      } else {
        debugPrint('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
      } else {
        debugPrint('User is signed in!');
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AccountsProvider()),
        ChangeNotifierProvider(create: (ctx) => ItemProvider()),
        ChangeNotifierProvider(create: (ctx) => BillProvider()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => TransactionProvider()),
      ],
      child: MaterialApp(
        title: 'Accounting App',
        theme: ThemeData(
          primaryColor: Colors.white,
          textTheme: const TextTheme(
            titleLarge: TextStyle(color: Colors.black, fontSize: 22),
            labelMedium: TextStyle(color: Colors.black, fontSize: 18),
            bodyMedium: TextStyle(color: Colors.black, fontSize: 15),
            bodySmall: TextStyle(color: Colors.black, fontSize: 12),
            titleMedium: TextStyle(color: Colors.black),
          ),
          colorScheme:
              Theme.of(context).colorScheme.copyWith(secondary: Colors.black),
          iconTheme: const IconThemeData(color: Colors.black, opacity: 1.0),
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 35,
            ),
          ),
        ),
        darkTheme: ThemeData(
            primaryColor: const Color.fromARGB(255, 16, 16, 16),
            textTheme: const TextTheme(
              titleLarge: TextStyle(color: Colors.white, fontSize: 22),
              labelMedium: TextStyle(color: Colors.white, fontSize: 18),
              bodyMedium: TextStyle(color: Colors.white, fontSize: 15),
              bodySmall: TextStyle(color: Colors.white, fontSize: 12),
              titleMedium: TextStyle(color: Colors.white),
            ),
            colorScheme:
                Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
            iconTheme: const IconThemeData(color: Colors.white, opacity: 1.0),
            appBarTheme: const AppBarTheme(
                color: Color.fromARGB(255, 16, 16, 16),
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 35))),
        themeMode: ThemeMode.dark,
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          SignupScreen.routeName: (ctx) => SignupScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          VerificationPage.routeName: (ctx) => const VerificationPage(),
          LedgerMain.routeName: (ctx) => LedgerMain(),
          AccountsMain.routeName: (ctx) => AccountsMain(),
          AddAccount.routeName: (ctx) => AddAccount(),
          ItemsMain.routeName: (ctx) => ItemsMain(),
          AddItems.routeName: (ctx) => const AddItems(),
          UserAccount.routeName: (ctx) => const UserAccount(),
          AddSale.routeName: (ctx) => AddSale(),
          CartScreen.routeName: (ctx) => CartScreen(),
          AddPurchase.routeName: (ctx) => AddPurchase(),
          ItemsDetail.routeName: (ctx) => ItemsDetail(),
        },
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.routeName
            : HomeScreen.routeName,
        home: LoginScreen(),
      ),
    );
  }
}
