// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/providers/client_provider.dart';
import 'package:moqefapp/widgets/Bar_widget.dart';
import 'package:moqefapp/widgets/ads_widget.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ClientProvider>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: SizedBox(
              width: screenSize(context).width,
              child: BarWidget(
                child: Column(
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
                      context.locale.saved_ads,
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Config.black),
                    )
                        .align(
                            alignment: context.locale.localeName == 'ar'
                                ? Alignment.centerRight
                                : Alignment.centerLeft)
                        .paddingAll(20),
                    Consumer<ClientProvider>(builder: (context, client, _) {
                      if (!client.isLoading) {
                        if (client.ads.isEmpty) {
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
                              itemCount: client.ads.length,
                              itemBuilder: (context, index) {
                                return AdsWidget(
                                  ad: client.ads[index],
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
                    }),
                  ],
                ),
              ))),
    );
  }
}
