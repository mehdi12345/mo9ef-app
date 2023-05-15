// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/models/client.dart';
import 'package:moqefapp/pages/controlle_page.dart';
import 'package:moqefapp/preferences/prefs.dart';
import 'package:moqefapp/providers/ad_provider.dart';
import 'package:moqefapp/providers/auth_provider.dart';
import 'package:moqefapp/providers/category_provider.dart';
import 'package:moqefapp/providers/client_provider.dart';
import 'package:moqefapp/providers/locale_provider.dart';
import 'package:moqefapp/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  static const id = "SplashPage";

  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Timer _timer;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Config.init(context);
      _timer = Timer(const Duration(seconds: 1), () async {
        await checkAuth();
        Provider.of<LocaleProvider>(context, listen: false).init();
      });
    });
  }

  Future<void> checkAuth() async {
    var clientUid = await Prefs.instance.getClient();
    await Provider.of<CategoryProvider>(context, listen: false)
        .fetchCategories();
    await Provider.of<CategoryProvider>(context, listen: false).init();
    Provider.of<AdProvider>(context, listen: false).initt();
    if (clientUid != null) {
      Client? client = await Provider.of<AuthProvider>(context, listen: false)
          .getAuthClient(clientUid);
      if (client != null) {
        Provider.of<NotificationProvider>(context, listen: false)
            .getNotifications();
        Provider.of<ClientProvider>(context, listen: false).setClient(client);
        Provider.of<ClientProvider>(context, listen: false).init();
        Navigator.pushNamedAndRemoveUntil(
            context, ControllePage.id, ((route) => false),
            arguments: 0);
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, ControllePage.id, ((route) => false),
          arguments: 0);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/logo.png",
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            LoadingAnimationWidget.prograssiveDots(
              color: Config.primaryColor,
              size: 60,
            ),
          ],
        ),
      ),
    );
  }
}
