import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'app_bar_popupmenu.dart';

class AppBarPopupmenuButton extends StatelessWidget {
  const AppBarPopupmenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
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
        });
  }
}
