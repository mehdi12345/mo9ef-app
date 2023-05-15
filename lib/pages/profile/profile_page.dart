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
import 'package:moqefapp/pages/annonce/edit_ad_page.dart';
import 'package:moqefapp/pages/profile/edit_profile_page.dart';
import 'package:moqefapp/pages/profile/settings_page.dart';
import 'package:moqefapp/providers/ad_provider.dart';
import 'package:moqefapp/providers/client_provider.dart';
import 'package:moqefapp/widgets/ads_widget.dart';
import 'package:provider/provider.dart';

import '../../preferences/prefs.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const id = 'profile_page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var Url;
  String url2 = '';
  String? imageUrl;
  File? _image;

  Future uploadImage(String client) async {
    final storage = FirebaseStorage.instanceFor(bucket: "gs://mo9ef");
    await pickImage2();

    Reference ref = storage.ref("image1.jpg").child(client);
    UploadTask uploadTask = ref.putFile(_image!);
    uploadTask.whenComplete(() async {
      String Url = await ref.getDownloadURL();
      Provider.of<ClientProvider>(context, listen: false)
          .updateClientImage(imageUrl = Url);
      print("imagrUrl = $imageUrl");
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AdProvider>(context, listen: false).getAuthClientAds(
          Provider.of<ClientProvider>(context, listen: false).client.uid);
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      imageUrl = Prefs.instance.getPlatform().toString();
      if (mounted) {
        imageUrl =
            Provider.of<ClientProvider>(context, listen: false).client.imageUrl;
      }
    });
  }

  checkAuthProvider() {
    switch (FirebaseAuth.instance.currentUser?.providerData[0].providerId) {
      case "password":
        return true;
      case "google.com":
        return false;
      case "facebook.com":
        return false;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: screenSize(context).width,
        child: Consumer<ClientProvider>(builder: (context, client, child) {
          return Column(children: [
            SizedBox(height: screenSize(context).height * 0.07),
            Text(
              context.locale.profile,
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Config.primaryColor,
                  fontWeight: FontWeight.w600),
            ),
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
                          CachedNetworkImageProvider(client.client.imageUrl)),
                  Positioned(
                      bottom: 0,
                      right: -25,
                      child: RawMaterialButton(
                        onPressed: () async {
                          uploadImage(client.client.uid);
                        },
                        elevation: 2.0,
                        fillColor: const Color(0xFFF5F6F9),
                        padding: const EdgeInsets.all(15.0),
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.blue,
                          size: 17,
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: screenSize(context).height * 0.04),
            Text(
              client.client.fullname,
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Config.black,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              client.client.email,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: screenSize(context).height * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, EditProfilePage.id);
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Config.primaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        context.locale.modifier_profile,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, SettingPage.id);
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Config.primaryColor),
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        context.locale.parametres,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Config.primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                )
              ],
            ),
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
            Consumer<AdProvider>(builder: (context, adProvider, child) {
              if (!adProvider.isLoading) {
                if (adProvider.clientAds.isEmpty) {
                  return Center(
                    child: Image.asset(
                      Config.no_ads,
                      height: 200,
                    ),
                  ).paddingOnly(top: 50);
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: adProvider.clientAds.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (context) => Material(
                                      color: Colors.transparent,
                                      child: Center(
                                        child: Container(
                                          height: 200,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          width: screenSize(context).width * .7,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Config.showAler(context,
                                                      title: "Error",
                                                      message:
                                                          "Une erreur est survenue",
                                                      icon:
                                                          Ionicons.close_circle,
                                                      color:
                                                          Colors.red.shade600,
                                                      softColor: Colors
                                                          .red.shade100
                                                          .withOpacity(.5),
                                                      buttonText: "Supprimer",
                                                      showCancel: true,
                                                      onTap: () {
                                                    adProvider.deleteAd(
                                                        adProvider
                                                            .clientAds[index]
                                                            .uid);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Container(
                                                    height: 45,
                                                    width: screenSize(context)
                                                            .width *
                                                        .7,
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.red.shade400,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Center(
                                                      child: Text(
                                                        "Supprimer l'annonce",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    )),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, EditAdPage.id,
                                                      arguments: adProvider
                                                          .clientAds[index]);
                                                },
                                                child: Container(
                                                    height: 45,
                                                    width: screenSize(context)
                                                            .width *
                                                        .7,
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .green.shade300,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Center(
                                                      child: Text(
                                                        "Modifier l'annonce",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    )),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                    height: 45,
                                                    width: screenSize(context)
                                                            .width *
                                                        .7,
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Config.primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Center(
                                                      child: Text(
                                                        "Annuler",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                          },
                          child: AdsWidget(
                            ad: adProvider.clientAds[index],
                          ),
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
            })
          ]);
        }),
      ),
    );
  }

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      _image = imageTemporary;
    });
  }

  Future pickImage2() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      _image = imageTemporary;
    });
  }

  uploadPage() async {
    return CircleAvatar(
      radius: screenSize(context).height * 0.1,
      backgroundColor: Config.primaryColor,
      child: ClipOval(
          child: Image.file(
        _image!,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      )),
    );
  }
}
