import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/models/ad.dart';
import 'package:moqefapp/pages/search/filter_page.dart';
import 'package:moqefapp/providers/ad_provider.dart';
import 'package:moqefapp/widgets/ads_widget.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, this.query = ''}) : super(key: key);
  static const id = 'search_Page';
  final String query;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = true;
  List<Ad> searchedAds = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.query.isNotEmpty) {
        SearchAds();
      }
    });
    super.initState();
  }

  Future<void> SearchAds() async {
    List<Ad> ads = await AdProvider().searchData(widget.query);
    setState(() {
      searchedAds = ads;
      isLoading = false;
    });
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Config.background,
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                  context.locale.localeName == 'ar'
                      ? Ionicons.chevron_forward
                      : Ionicons.chevron_back,
                  color: Config.black)),
          title: Text(
            context.locale.chercher,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Config.black,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Ionicons.filter_outline, color: Config.black),
              onPressed: () {
                Navigator.pushNamed(context, FilterPage.id);
              },
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SizedBox(
            height: screenSize(context).height,
            width: screenSize(context).width,
            child: Builder(
              builder: (BuildContext context) {
                print("yesssssssssssssssssssssssss");
                print(searchedAds.length);
                if (isLoading) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Config.primaryColor,
                  )).paddingOnly(top: 100);
                } else {
                  if (searchedAds.length == 0) {
                    return Image.asset(
                      Config.no_ads,
                      height: 200,
                    ).paddingOnly(top: 100);
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: searchedAds.length,
                      itemBuilder: (context, index) {
                        return AdsWidget(
                          ad: searchedAds[index],
                        );
                      },
                    );
                  }
                }
              },
            )));
  }
}
