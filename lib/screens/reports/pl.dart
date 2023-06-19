import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../home/home_screen.dart';

class PLStatement extends StatefulWidget {
  static const String routeName = "PLStatement";

  @override
  State<PLStatement> createState() => _PLStatementState();
}

class _PLStatementState extends State<PLStatement> {
  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final settingsProv = Provider.of<SettingsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: th.colorScheme.secondary,
          ),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (c) => HomeScreen()),
              (route) => false),
        ),
        title: Text(
          'P L\nS T A T E M E N T',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          MaterialButton(
            onPressed: null,
            child: Icon(
              Icons.download,
              color: th.colorScheme.secondary,
            ),
          )
        ],
      ),
      body: Container(
        color: th.primaryColor,
        child: Column(children: [
          Row(),
        ]),
      ),
    );
  }
}
