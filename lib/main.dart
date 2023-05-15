import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moqefapp/l10n/l10n.dart';
import 'package:moqefapp/models/ad.dart';
import 'package:moqefapp/pages/annonce/edit_ad_page.dart';
import 'package:moqefapp/pages/annonce/view_page.dart';
import 'package:moqefapp/pages/auth/auth_page.dart';
import 'package:moqefapp/pages/controlle_page.dart';
import 'package:moqefapp/pages/home/home_page.dart';
import 'package:moqefapp/pages/profile/edit_profile_page.dart';
import 'package:moqefapp/pages/profile/password_page.dart';
import 'package:moqefapp/pages/profile/profile_annonce.dart';
import 'package:moqefapp/pages/profile/settings_page.dart';
import 'package:moqefapp/pages/search/filter_page.dart';
import 'package:moqefapp/pages/search/result_page.dart';
import 'package:moqefapp/pages/search/search_page.dart';
import 'package:moqefapp/pages/splash_page.dart';
import 'package:moqefapp/providers/ad_provider.dart';
import 'package:moqefapp/providers/auth_provider.dart';
import 'package:moqefapp/providers/category_provider.dart';
import 'package:moqefapp/providers/client_provider.dart';
import 'package:moqefapp/providers/locale_provider.dart';
import 'package:moqefapp/providers/notification_provider.dart';
import 'package:provider/provider.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   notifyManager.showNotification(
//       5,
//       message.notification?.title ?? message.data['title'],
//       message.notification?.body ?? message.data['body']);
//   notifyManager.setOnNotificationClick(onNotificationClick);
//   notifyManager.setOnNotificationReceive(onNotificationReceive);
// }

onNotificationClick(String? notification) {
  log("Notification Received : $notification");
}

onNotificationReceive(notification) {}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runZonedGuarded<Future<void>>(() async {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // await FirebaseMessaging.instance.setAutoInitEnabled(true);
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => ClientProvider()),
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ChangeNotifierProvider(create: (_) => AdProvider()),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ], child: const MyApp()));
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Provider.of<LocaleProvider>(context).locale,
      title: 'Mo9ef.ma',
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: routes,
      initialRoute: SplashPage.id,
    );
  }

  Route<dynamic> routes(RouteSettings settings) {
    switch (settings.name) {

      /// Splash screen
      case SplashPage.id:
        return CupertinoPageRoute(
            builder: (_) => const SplashPage(), settings: settings);
      case AuthPage.id:
        return CupertinoPageRoute(
            builder: (_) => const AuthPage(), settings: settings);
      case HomePage.id:
        return CupertinoPageRoute(
            builder: (_) => const HomePage(), settings: settings);
      case ControllePage.id:
        return CupertinoPageRoute(
            builder: (_) => ControllePage(
                  index: settings.arguments as int,
                ),
            settings: settings);
      case ViewPage.id:
        return CupertinoPageRoute(
            builder: (_) => const ViewPage(), settings: settings);

      case SettingPage.id:
        return CupertinoPageRoute(
            builder: (_) => const SettingPage(), settings: settings);
      case EditProfilePage.id:
        return CupertinoPageRoute(
            builder: (_) => const EditProfilePage(), settings: settings);
      case SearchPage.id:
        return MaterialPageRoute(
            builder: (_) => SearchPage(
                  query: settings.arguments as String,
                ),
            settings: settings);
      case FilterPage.id:
        return MaterialPageRoute(
            builder: (_) => const FilterPage(), settings: settings);
      case ResultPage.id:
        return MaterialPageRoute(
            builder: (_) => const ResultPage(), settings: settings);
      case EditAdPage.id:
        return MaterialPageRoute(
            builder: (_) => EditAdPage(ad: settings.arguments as Ad),
            settings: settings);
      case PasswordPage.id:
        return MaterialPageRoute(
            builder: (_) => const PasswordPage(), settings: settings);
      default:
        return CupertinoPageRoute(
            builder: (_) => const SplashPage(), settings: settings);
    }
  }
}
