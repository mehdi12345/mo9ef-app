import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/pages/annonce/redirect_page.dart';
import 'package:moqefapp/pages/favorite/redirect_favorite_page.dart';
import 'package:moqefapp/pages/home/home_page.dart';
import 'package:moqefapp/pages/notifications/notification_page.dart';
import 'package:moqefapp/pages/profile/redirect_profile_page.dart';
import 'package:moqefapp/providers/client_provider.dart';
import 'package:provider/provider.dart';

class ControllePage extends StatefulWidget {
  const ControllePage({Key? key, this.index = 0}) : super(key: key);
  static const id = 'ControllePage';
  final int index;

  @override
  ControllePageState createState() => ControllePageState();
}

class ControllePageState extends State<ControllePage> {
  int activeIndex = 0;
  List<Widget> pages = [
    const HomePage(),
    const RedirectFavoritePage(),
    const NotificationPage(),
    const RedirectProfilePage(),
  ];
  List<IconData> icons = [
    Ionicons.home_outline,
    Ionicons.bookmark_outline,
    Ionicons.notifications_outline,
    Ionicons.person_outline,
  ];

  @override
  void initState() {
    super.initState();
    activeIndex = widget.index;

    // if (mounted) {
    //   FirebaseAuth.instance.authStateChanges().listen((user) {
    //     if (mounted && user == null) {
    //       Prefs.instance.clearClient();
    //       Navigator.of(context).pushNamedAndRemoveUntil(
    //         AuthPage.id,
    //         (Route<dynamic> route) => false,
    //       );
    //     }
    //   });
    // }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ClientProvider>(context, listen: false)
          .setNotificationToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[activeIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Config.primaryColor,
        splashColor: Config.primaryColor.withOpacity(.4),
        child: const Icon(
          Ionicons.add_outline,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const RedirectAnnoncePage();
          }));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        elevation: 0,
        icons: icons,
        activeIndex: activeIndex,
        gapLocation: GapLocation.center,
        activeColor: Config.secondaryColor,
        inactiveColor: Config.primaryColor,

        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) => setState(() => activeIndex = index),
        //other params
      ),
    );
  }
}
