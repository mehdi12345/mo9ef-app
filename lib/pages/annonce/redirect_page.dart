import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/pages/annonce/add_ad_page.dart';
import 'package:moqefapp/pages/should_auth_page.dart';
import 'package:moqefapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RedirectAnnoncePage extends StatefulWidget {
  const RedirectAnnoncePage({Key? key}) : super(key: key);

  @override
  State<RedirectAnnoncePage> createState() => _RedirectAnnoncePageState();
}

class _RedirectAnnoncePageState extends State<RedirectAnnoncePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      if (auth.authClient != null) {
        return const AddAdPage();
      } else {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                context.locale.localeName == 'ar'
                    ? Ionicons.chevron_forward
                    : Ionicons.chevron_back,
              ),
              color: Colors.black,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: const ShouldAuthPage(),
        );
      }
    });
  }
}
