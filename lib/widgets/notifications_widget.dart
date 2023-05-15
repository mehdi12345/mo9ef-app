// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/models/ad.dart';
import 'package:moqefapp/models/notification.dart';
import 'package:moqefapp/pages/annonce/view_page.dart';
import 'package:moqefapp/providers/ad_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({Key? key, required this.notif}) : super(key: key);
  final Notif notif;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: screenSize(context).width * .8,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 5,
                  offset: const Offset(0, 5))
            ]),
        child: Stack(
          children: [
            Column(
              children: [
                Text(
                  notif.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Config.primaryColor),
                )
                    .align(alignment: Alignment.centerLeft)
                    .paddingSymmetric(horizontal: 10),
                const SizedBox(height: 10),
                Text(
                  notif.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Config.black),
                )
                    .align(alignment: Alignment.centerLeft)
                    .paddingSymmetric(horizontal: 10),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ));
  }
}
