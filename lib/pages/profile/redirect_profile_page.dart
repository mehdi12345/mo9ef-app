import 'package:flutter/material.dart';
import 'package:moqefapp/pages/profile/profile_page.dart';
import 'package:moqefapp/pages/should_auth_page.dart';
import 'package:moqefapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RedirectProfilePage extends StatefulWidget {
  const RedirectProfilePage({Key? key}) : super(key: key);

  @override
  State<RedirectProfilePage> createState() => _RedirectProfilePageState();
}

class _RedirectProfilePageState extends State<RedirectProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      if (auth.authClient != null) {
        return const ProfilePage();
      } else {
        return const ShouldAuthPage();
      }
    });
  }
}
