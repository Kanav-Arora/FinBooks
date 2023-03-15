import 'package:accouting_software/icons/custom_icons_icons.dart';
import 'package:accouting_software/screens/app_drawer.dart';
import 'package:accouting_software/widgets/app_bar_popupmenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatelessWidget {
  static final String routeName = "HomeScreen";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (BuildContext ctx) {
            return IconButton(
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              icon: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Icon(
                    CustomIcons.th_thumb,
                    size: 28,
                    color: Theme.of(context).colorScheme.secondary,
                  )),
            );
          },
        ),
        actions: [
          PopupMenuButton(
              color: Theme.of(context).primaryColor,
              child: Container(
                padding: const EdgeInsets.all(5.0),
                margin: const EdgeInsets.only(top: 5.0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 30,
                  child: const CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                    'https://www.wikihow.com/images/6/61/Draw-a-Cartoon-Man-Step-15.jpg',
                  )),
                ),
              ),
              itemBuilder: (BuildContext ctx) {
                return AppBarPopupmenu(ctx).create().toList();
              }),
        ],
      ),
      drawer: const AppDrawer(),
      body: Container(
        width: size.width,
        height: size.height,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
