// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/pages/controlle_page.dart';
import 'package:moqefapp/providers/client_provider.dart';
import 'package:provider/provider.dart';

class BarWidget extends StatelessWidget {
  const BarWidget({Key? key, required this.child, this.showBackButton = false})
      : super(key: key);
  final Widget child;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          left: 10,
          top: 50,
          child: Visibility(
            visible: showBackButton,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Ionicons.chevron_back,
              ),
            ),
          ),
        ),
        Positioned(
          right: 5,
          top: 40,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, ControllePage.id, arguments: 3);
            },
            child: Consumer<ClientProvider>(builder: (context, client, _) {
              return CircleAvatar(
                radius: 22,
                backgroundColor: Config.primaryColor,
                foregroundImage: NetworkImage(client.client.imageUrl),
                child: Icon(
                  Icons.person,
                  color: Config.background,
                ),
              ).align(alignment: Alignment.centerRight).paddingOnly(right: 10);
            }),
          ),
        ),
      ],
    );
  }
}
