// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_viewer/image_viewer.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/models/ad.dart';
import 'package:moqefapp/pages/profile/profile_annonce.dart';
import 'package:moqefapp/providers/ad_provider.dart';
import 'package:moqefapp/providers/client_provider.dart';
import 'package:moqefapp/widgets/view_annonce_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({Key? key}) : super(key: key);
  static const id = 'ViewPage';
  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  bool save = false;

  saveAd(Ad ad) {
    setState(() {
      Provider.of<ClientProvider>(context, listen: false).saveAd(ad);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: Consumer2<AdProvider, ClientProvider>(
            builder: (context, adProvider, clientP, _) {
          return false
              ? const CircularProgressIndicator().center()
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                      SliverAppBar(
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.32,
                        collapsedHeight:
                            MediaQuery.of(context).size.height * 0.32,
                        elevation: 0,
                        floating: false,
                        pinned: true,
                        excludeHeaderSemantics: false,
                        leading: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            context.locale.localeName == 'ar'
                                ? Ionicons.chevron_forward
                                : Ionicons.chevron_back,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        actions: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                saveAd(adProvider.ad);
                              });
                            },
                            child: Center(
                              child: Icon(
                                clientP.ads.every((element) =>
                                        element.uid != adProvider.ad.uid)
                                    ? Ionicons.bookmark_outline
                                    : Ionicons.bookmark,
                                color: clientP.ads.every((element) =>
                                        element.uid != adProvider.ad.uid)
                                    ? Colors.white
                                    : Config.primaryColor,
                                size: 28,
                              ),
                            ).paddingAll(10),
                          ),
                        ],
                        backgroundColor: Colors.white,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          background: CarouselSlider.builder(
                              itemCount: adProvider.ad.images.isEmpty
                                  ? 1
                                  : adProvider.ad.images.length,
                              itemBuilder: (context, index, pageIndex) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    adProvider.ad.images.isEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: adProvider.ad.thambnail,
                                            fit: BoxFit.cover,
                                            width: screenSize(context).width,
                                            height: screenSize(context).height *
                                                0.32,
                                            memCacheHeight:
                                                (screenSize(context).height *
                                                        0.32)
                                                    .toInt(),
                                            memCacheWidth: screenSize(context)
                                                .width
                                                .toInt(),
                                            maxWidthDiskCache:
                                                screenSize(context)
                                                    .width
                                                    .toInt(),
                                            maxHeightDiskCache:
                                                (screenSize(context).height *
                                                        0.32)
                                                    .toInt(),
                                            useOldImageOnUrlChange: true,
                                            filterQuality: FilterQuality.medium,
                                          )
                                        : InkWell(
                                            onTap: () {
                                              ImageViewer.showImageSlider(
                                                images: adProvider.ad.images,
                                              );
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  adProvider.ad.images[index],
                                              fit: BoxFit.cover,
                                              width: screenSize(context).width,
                                              height:
                                                  screenSize(context).height *
                                                      0.32,
                                              memCacheHeight:
                                                  (screenSize(context).height *
                                                          0.32)
                                                      .toInt(),
                                              memCacheWidth: screenSize(context)
                                                  .width
                                                  .toInt(),
                                              maxWidthDiskCache:
                                                  screenSize(context)
                                                      .width
                                                      .toInt(),
                                              maxHeightDiskCache:
                                                  (screenSize(context).height *
                                                          0.32)
                                                      .toInt(),
                                              useOldImageOnUrlChange: true,
                                              filterQuality:
                                                  FilterQuality.medium,
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                Icons.error,
                                                color: Config.primaryColor,
                                              ),
                                              fadeInCurve: Curves.easeIn,
                                              placeholder: (context, url) {
                                                return const CircularProgressIndicator(
                                                  color: Colors.amber,
                                                ).center();
                                              },
                                            ),
                                          ),
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Ionicons.images_outline,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Center(
                                            child: Text(
                                              adProvider.ad.images.isEmpty
                                                  ? "${(index + 1)}/${1}"
                                                  : "${(index + 1)}/${adProvider.ad.images.length}",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 10,
                                        right: 20,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black26.withOpacity(.4),
                                                Colors.black54.withOpacity(.5),
                                              ],
                                              begin:
                                                  AlignmentDirectional.topStart,
                                              end: AlignmentDirectional
                                                  .bottomEnd,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 15),
                                          alignment: Alignment.center,
                                          child: Text(
                                            context.locale.localeName != 'ar'
                                                ? adProvider.ad.price
                                                        .toStringAsFixed(0)
                                                        .moneyFormat() +
                                                    " MAD"
                                                : "${adProvider.ad.price.toStringAsFixed(0)} درهم",
                                            style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                color: Config.primaryColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )),
                                  ],
                                );
                              },
                              options: CarouselOptions(
                                  aspectRatio: 1.45,
                                  autoPlay: false,
                                  enlargeCenterPage: false,
                                  viewportFraction: 1,
                                  enableInfiniteScroll: false,
                                  autoPlayCurve: Curves.ease,
                                  pauseAutoPlayOnTouch: true,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index, reason) {})),
                        ),
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                                crossAxisAlignment:
                                    context.locale.localeName == 'ar'
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    adProvider.ad.title,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    textAlign: context.locale.localeName == 'ar'
                                        ? TextAlign.end
                                        : TextAlign.start,
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        color: Config.primaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  if (adProvider.ad.category!.uid ==
                                      "rwAAHojffDZP9U4URtvN")
                                    Row(
                                      crossAxisAlignment:
                                          context.locale.localeName == 'ar'
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Ionicons.location_outline,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          adProvider.ad.departure ??
                                              adProvider.ad.city,
                                          style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Ionicons.arrow_forward,
                                          color: Config.primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${adProvider.ad.arrival}",
                                          style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ).paddingOnly(
                                      top: 10,
                                    ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileAnnonce(
                                                    uid: adProvider
                                                        .ad.client!.uid,
                                                  ),
                                              fullscreenDialog: false));
                                    },
                                    child: Row(
                                        textDirection: TextDirection.ltr,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            radius: 20,
                                            foregroundImage: NetworkImage(
                                                adProvider.ad.client!.imageUrl),
                                            child: const Icon(
                                              Ionicons.person_outline,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            adProvider.ad.client!.fullname,
                                            style: GoogleFonts.poppins(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ]),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          canLaunch(
                                                  "tel:+212${Provider.of<AdProvider>(context, listen: false).ad.client!.phone}")
                                              .then((value) {
                                            if (value) {
                                              launch(
                                                  "tel:+212${Provider.of<AdProvider>(context, listen: false).ad.client!.phone}");
                                            } else {
                                              log("tel:+212${Provider.of<AdProvider>(context, listen: false).ad.client!.phone}");
                                            }
                                          });
                                        },
                                        child: Container(
                                            height: 40,
                                            width:
                                                screenSize(context).width * .4,
                                            decoration: BoxDecoration(
                                              color: Colors.blueAccent.shade200,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Ionicons.call_outline,
                                                  color: Colors.white,
                                                  size: 22,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text("Appeler",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ],
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          canLaunch(
                                                  "https://wa.me/+212${adProvider.ad.client!.phone}")
                                              .then((value) {
                                            if (value) {
                                              launch(
                                                  "https://wa.me/+212${adProvider.ad.client!.phone}");
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: screenSize(context).width * .4,
                                          decoration: BoxDecoration(
                                            color: Colors.greenAccent.shade700,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Ionicons.logo_whatsapp,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text("Whatsapp",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Détails de l'annonce",
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                      textDirection: TextDirection.ltr,
                                      children: [
                                        if (adProvider.ad.make != null)
                                          ListItem(
                                              title: "Marque   :",
                                              value: adProvider.ad.make != null
                                                  ? adProvider.ad.make!.isEmpty
                                                      ? '----'
                                                      : adProvider.ad.make!
                                                  : '----'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ListItem(
                                            title: "City            :",
                                            value: adProvider.ad.city.isEmpty
                                                ? '----'
                                                : adProvider.ad.city),
                                      ]),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                      textDirection: TextDirection.ltr,
                                      children: [
                                        if (adProvider.ad.weight != null)
                                          ListItem(
                                              title: "Masse      :",
                                              value: adProvider.ad.weight
                                                      ?.toStringAsFixed(0) ??
                                                  '----'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        if (adProvider.ad.weight != null)
                                          ListItem(
                                              title: "Metrage :",
                                              value: adProvider.ad.length
                                                      ?.toStringAsFixed(0) ??
                                                  '----')
                                      ]),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Description",
                                    textDirection: TextDirection.ltr,
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    adProvider.ad.description,
                                    textDirection: TextDirection.ltr,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ])),
                      ]))
                    ]);
        })));
  }
}
