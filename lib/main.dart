import 'dart:async';
import 'package:accouting_software/providers/accounts_provider.dart';
import 'package:accouting_software/providers/bill_provider.dart';
import 'package:accouting_software/providers/cart_provider.dart';
import 'package:accouting_software/providers/expense_provider.dart';
import 'package:accouting_software/providers/items_provider.dart';
import 'package:accouting_software/providers/settings_provider.dart';
import 'package:accouting_software/providers/transaction_provider.dart';
import 'package:accouting_software/screens/accounts/accounts_main.dart';
import 'package:accouting_software/screens/accounts/add_account.dart';
import 'package:accouting_software/screens/app%20login/email_update_verification.dart';
import 'package:accouting_software/screens/app%20login/password_reset.dart';
import 'package:accouting_software/screens/app%20login/re_auth_screen.dart';
import 'package:accouting_software/screens/cart_screen.dart';
import 'package:accouting_software/screens/home/home_screen.dart';
import 'package:accouting_software/screens/items/add_items.dart';
import 'package:accouting_software/screens/items/items_detail.dart';
import 'package:accouting_software/screens/items/items_main.dart';
import 'package:accouting_software/screens/ledger%20accounts/ledger_main.dart';
import 'package:accouting_software/screens/app%20login/login_screen.dart';
import 'package:accouting_software/screens/operating%20expense/all_expense.dart';
import 'package:accouting_software/screens/operating%20expense/list_expense.dart';
import 'package:accouting_software/screens/operating%20expense/operating_expense.dart';
import 'package:accouting_software/screens/purchase/add_purchase.dart';
import 'package:accouting_software/screens/reports/pl.dart';
import 'package:accouting_software/screens/sale/add_sale.dart';
import 'package:accouting_software/screens/app%20login/signup_screen.dart';
import 'package:accouting_software/screens/home/user_account.dart';
import 'package:accouting_software/screens/app%20login/verification_page.dart';
import 'package:accouting_software/screens/settings.dart';
import 'package:accouting_software/screens/voucher/voucher.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
  await Firebase.initializeApp(
    name: "FinBooks",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAuth.instance.signOut();
  runApp(
    MyApp(
      savedThemeMode: savedThemeMode,
    ),
    // DevicePreview(
    //   enabled: true,
    //   builder: (context) => MyApp(
    //     savedThemeMode: savedThemeMode,
    //   ),
    // ),
  );
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({this.savedThemeMode});
  @override
  State<MyApp> createState() => _MyAppState(savedThemeMode);
}

class _MyAppState extends State<MyApp> {
  final AdaptiveThemeMode? savedThemeMode;
  _MyAppState(this.savedThemeMode);
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
        ChangeNotifierProvider(
            create: (ctx) => SettingsProvider(savedThemeMode!.isDark)),
        ChangeNotifierProvider(create: (ctx) => ExpenseProvider()),
      ],
      child: AdaptiveTheme(
        light: Themes.light,
        dark: Themes.dark,
        initial: savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (light, dark) {
          return MaterialApp(
            title: 'Accounting App',
            debugShowCheckedModeBanner: false,
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            darkTheme: dark,
            theme: light,
            routes: {
              LoginScreen.routeName: (ctx) =>
                  LoginScreen(savedThemeMode ?? AdaptiveThemeMode.light),
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
              Settings.routeName: (ctx) => Settings(),
              Voucher.routeName: (ctx) => Voucher(),
              OperatingExpense.routeName: (ctx) => OperatingExpense(),
              AllExpense.routeName: (ctx) => AllExpense(),
              PLStatement.routeName: (ctx) => PLStatement(),
              ListExpense.routeName: (ctx) => const ListExpense(),
              EmailUpdateVerification.routeName: (ctx) =>
                  const EmailUpdateVerification(),
              ReAuthScreen.routeName: (ctx) =>
                  ReAuthScreen(savedThemeMode ?? AdaptiveThemeMode.light),
              PasswordReset.routeName: (ctx) => PasswordReset(),
            },
            initialRoute: FirebaseAuth.instance.currentUser == null
                ? LoginScreen.routeName
                : HomeScreen.routeName,
            home: LoginScreen(savedThemeMode ?? AdaptiveThemeMode.light),
          );
        },
      ),
    );
  }
}
