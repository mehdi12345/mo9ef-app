import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/models/notification.dart';
import 'package:moqefapp/providers/notification_provider.dart';
import 'package:moqefapp/widgets/Bar_widget.dart';
import 'package:moqefapp/widgets/ads_widget.dart';
import 'package:moqefapp/widgets/notifications_widget.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);
  static const id = 'notification_page';

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late List<Notif> notifications;
  bool isLoading = true;
  @override
  void initState() {
    GetNotification();
    super.initState();
  }

  GetNotification() async {
    List<Notif> nots = await NotificationProvider().notificationsApp();
    setState(() {
      notifications = nots;
      isLoading = false;
    });
    print('yesssssssssssssssssssssssssss');
    print(nots);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.background,
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
              width: screenSize(context).width,
              child: BarWidget(child: Consumer<NotificationProvider>(
                  builder: (context, provider, child) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Config.logo,
                          height: 80,
                        ),
                      ],
                    ).paddingOnly(top: 30, bottom: 20),
                    Text(
                      context.locale.notification,
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Config.black),
                    ).paddingAll(20).align(
                        alignment: context.locale.localeName == 'ar'
                            ? Alignment.centerRight
                            : Alignment.centerLeft),
                    Material(
                      child: Builder(
                        builder: (BuildContext context) {
                          if (!isLoading) {
                            if (notifications.isEmpty) {
                              return Center(
                                child: Image.asset(
                                  Config.no_ads,
                                  height: 200,
                                ),
                              ).paddingOnly(top: 50);
                            } else {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: notifications.length,
                                  itemBuilder: (context, index) {
                                    return NotificationWidget(
                                      notif: notifications[index],
                                    );
                                  });
                            }
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Config.secondaryColor,
                              ),
                            ).paddingOnly(top: 50);
                          }
                        },
                      ),
                    ),
                  ],
                );
              })))),
    );
  }
}
