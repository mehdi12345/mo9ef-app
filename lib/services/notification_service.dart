// import 'dart:io';
// import 'dart:math';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:moqefapp/models/notification.dart' as notif;
// import 'package:moqefapp/providers/notification_provider.dart';
// import 'package:moqefapp/utilities/notification_manager.dart';
// import 'package:provider/provider.dart';

// class PushNotificationService {
//   final FirebaseMessaging _fcm;

//   PushNotificationService(this._fcm);

//   Future initialize(BuildContext context) async {
//     var notificationProvider =
//         Provider.of<NotificationProvider>(context, listen: false);
//     if (Platform.isIOS) {
//       _fcm.requestPermission(
//           alert: true,
//           announcement: true,
//           badge: true,
//           criticalAlert: true,
//           sound: true);
//     }

//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message != null) {
//         notificationProvider
//             .addNotification(notif.Notification.fromMap(message.data));
//         notifyManager.showNotification(
//             0, message.data['title'], message.data['body']);
//       }
//     });
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//             alert: true, badge: true, sound: true);

//     FirebaseMessaging.onMessageOpenedApp.listen((message) {}).onData((data) {
//       notifyManager.showNotification(
//         1,
//         data.notification!.title!,
//         data.notification!.body!,
//       );
//       notificationProvider.addNotification(notif.Notification(
//           id: Random.secure().nextInt(100000).toString(),
//           title: data.notification!.title!,
//           body: data.notification!.body!));
//     });

//     FirebaseMessaging.onMessage.listen((message) {
//       notifyManager.showNotification(Random.secure().nextInt(100000),
//           message.notification!.title!, message.notification!.body!);
//     }).onData((data) {
//       notifyManager.showNotification(
//         1,
//         data.notification!.title!,
//         data.notification!.body!,
//       );
//       notificationProvider.addNotification(notif.Notification(
//           id: Random.secure().nextInt(100000).toString(),
//           title: data.notification!.title!,
//           body: data.notification!.body!));
//     });
//   }
// }
