import 'package:accouting_software/icons/custom_icons_icons.dart';
import 'package:accouting_software/screens/app_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static final String routeName = "HomeScreen";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext ctx) {
            return IconButton(
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              icon: const Icon(CustomIcons.th_thumb),
            );
          },
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
