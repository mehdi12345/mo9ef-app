// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/models/city.dart';

class Config {
  static String logo = "assets/logo.png";
  static Color primaryColor = const Color(0xffFEC30D);
  static Color secondaryColor = const Color(0xFFFF9C00);
  static Color black = const Color(0xFF000000);
  static Color background = const Color(0xFFF5F5F5);
  static List<String> pricePer = [
    'Heur',
    'Jour',
  ];

  static loading(context) {
    showDialog(
        context: context,
        builder: (context) => Center(
                child: CircularProgressIndicator(
              color: Config.secondaryColor,
            )));
  }

  static String no_ads = "assets/empty.png";
  static String url =
      "https://media.istockphoto.com/photos/bulldozer-picture-id536033739?b=1&k=20&m=536033739&s=170667a&w=0&h=zYe5FtT4-LNPr9nnOH6c97--YOZauxA2biJmO8AlM30=";

  static errorBanner(
    context,
    String msg,
  ) {
    return MaterialBanner(
        content: Text(msg, style: GoogleFonts.poppins(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
              },
              child: const Icon(
                Ionicons.close_outline,
                color: Colors.white,
              ))
        ],
        backgroundColor: Colors.red.shade400);
  }

  static successBanner(
    context,
    String msg,
  ) {
    return MaterialBanner(
        content: Text(msg, style: GoogleFonts.poppins(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
              },
              child: const Icon(
                Ionicons.close_outline,
                color: Colors.white,
              ))
        ],
        backgroundColor: Colors.green.shade400);
  }

  static List<Map<String, String>> languages = [
    {
      'name': 'Français',
      'code': 'fr',
    },
    {
      'name': 'العربية',
      'code': 'ar',
    },
  ];

  // import json data
  static late List<City> cities;
  static init(BuildContext context) async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/ma.json");
    List<dynamic> ma = json.decode(data);
    cities = ma.map((e) => City.fromMap(e)).toList();
  }

  static showAler(BuildContext context,
      {required String title,
      required String message,
      required IconData icon,
      required Color color,
      required String buttonText,
      bool showCancel = false,
      Color? softColor,
      Function()? onTap}) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
              height: 350,
              width: MediaQuery.of(context).size.width * .8,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: softColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          color: color,
                          size: 60,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text.rich(
                      TextSpan(
                          text: "$title \n\n",
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Config.black,
                              fontWeight: FontWeight.w600),
                          children: [
                            TextSpan(
                              text: message,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            )
                          ]),
                      textAlign: TextAlign.center,
                      maxLines: 5,
                    ).makeItFlexible(flex: 10),
                    const Spacer(
                      flex: 1,
                    ),
                    InkWell(
                      onTap: onTap,
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 20),
                    Visibility(
                      visible: showCancel,
                      child: const SizedBox(
                        height: 10,
                      ),
                    ),
                    Visibility(
                        visible: showCancel,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                "Fermer",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )).paddingSymmetric(horizontal: 20),
                  ])),
        ),
      ),
    );
  }
}
