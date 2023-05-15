// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/models/ad.dart';
import 'package:moqefapp/models/client.dart';
import 'package:moqefapp/pages/annonce/edit_ad_page.dart';
import 'package:moqefapp/pages/profile/edit_profile_page.dart';
import 'package:moqefapp/pages/profile/settings_page.dart';
import 'package:moqefapp/providers/ad_provider.dart';
import 'package:moqefapp/providers/client_provider.dart';
import 'package:moqefapp/widgets/ads_widget.dart';
import 'package:provider/provider.dart';

import '../../preferences/prefs.dart';

class ProfileAnnonce extends StatefulWidget {
  final String uid;
  const ProfileAnnonce({Key? key, required this.uid}) : super(key: key);
  static const id = 'profileAnnonce';

  @override
  State<ProfileAnnonce> createState() => _ProfileAnnonceState();
}

class _ProfileAnnonceState extends State<ProfileAnnonce> {
  String? imageUrl;
  bool isLoading = true;
  late List<Ad> profileAds = [];
  late Client clientPage;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SearchAds();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      imageUrl = Prefs.instance.getPlatform().toString();
      if (mounted) {
        imageUrl =
            Provider.of<ClientProvider>(context, listen: false).client.imageUrl;
      }
    });
    super.initState();
  }

  Future<void> SearchAds() async {
    Client client = await AdProvider().profileClient(widget.uid);
    setState(() {
      clientPage = client;
    });
    print("yesssssssssssss");
    print(clientPage);
    List<Ad> ads = await AdProvider().searchDataprofile(widget.uid);
    setState(() {
      profileAds = ads;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: screenSize(context).width,
          child: Consumer<ClientProvider>(builder: (context, client, child) {
            return Column(children: [
              SizedBox(height: screenSize(context).height * 0.08),
              SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                        radius: screenSize(context).height * 0.1,
                        backgroundColor: Config.primaryColor,
                        // ignore: unnecessary_null_comparison
                        backgroundImage:
                            CachedNetworkImageProvider(clientPage.imageUrl)),
                  ],
                ),
              ),
              SizedBox(height: screenSize(context).height * 0.04),
              Text(
                clientPage.fullname,
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Config.black,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                clientPage.email,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: screenSize(context).height * 0.04),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              const SizedBox(
                height: 20,
              ),
              Text(
                context.locale.mes_annonces,
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Config.primaryColor,
                    fontWeight: FontWeight.w600),
              )
                  .align(
                      alignment: context.locale.localeName == 'ar'
                          ? Alignment.centerRight
                          : Alignment.centerLeft)
                  .paddingOnly(left: 20, right: 20),
              Material(
                child: Builder(
                  builder: (BuildContext context) {
                    if (!isLoading) {
                      if (profileAds.isEmpty) {
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
                            itemCount: profileAds.length,
                            itemBuilder: (context, index) {
                              return AdsWidget(
                                ad: profileAds[index],
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
              )
              // Consumer<AdProvider>(builder: (context, adProvider, child) {

              // })
            ]);
          }),
        ),
      ),
    );
  }
}
