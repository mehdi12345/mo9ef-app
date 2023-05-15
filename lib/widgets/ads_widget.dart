// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/models/ad.dart';
import 'package:moqefapp/pages/annonce/view_page.dart';
import 'package:moqefapp/providers/ad_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AdsWidget extends StatelessWidget {
  const AdsWidget({Key? key, required this.ad}) : super(key: key);
  final Ad ad;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<AdProvider>(context, listen: false).seCurrentAd(ad);
        Navigator.pushNamed(context, ViewPage.id, arguments: ad);
      },
      child: Container(
          height: 350,
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
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: CachedNetworkImage(
                      imageUrl: ad.thambnail,
                      height: 200,
                      width: screenSize(context).width * 9,
                      memCacheHeight: 220,
                      memCacheWidth: screenSize(context).width.toInt(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ad.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Config.primaryColor),
                  )
                      .align(alignment: Alignment.centerLeft)
                      .paddingSymmetric(horizontal: 10),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blueAccent.shade400.withOpacity(0.2),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          ad.city.isEmpty ? "Unknown" : ad.city,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueAccent.shade400),
                        ),
                      ).align(alignment: Alignment.centerLeft),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(ad.description,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade500))
                      .align(alignment: Alignment.bottomLeft)
                      .paddingOnly(left: 15, right: 10),
                ],
              ),
              Positioned(
                top: 10,
                left: 15,
                child: InkWell(
                  onTap: () {
                    canLaunch("tel:${ad.client?.phone}").then((value) {
                      if (value) {
                        launch("tel:${ad.client?.phone}");
                      }
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.shade400.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(
                      "Appeler",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    )),
                  ),
                ),
              ),
              Positioned(
                  top: 100,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black26.withOpacity(.4),
                          Colors.black54.withOpacity(.5),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    alignment: Alignment.center,
                    child: Text(
                      "${ad.price.toStringAsFixed(0).moneyFormat()} MAD",
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Config.primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
            ],
          )),
    );
  }
}
