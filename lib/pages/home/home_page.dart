// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/pages/search/filter_page.dart';
import 'package:moqefapp/pages/search/result_page.dart';
import 'package:moqefapp/pages/search/search_page.dart';
import 'package:moqefapp/providers/ad_provider.dart';
import 'package:moqefapp/providers/category_provider.dart';
import 'package:moqefapp/widgets/Bar_widget.dart';
import 'package:moqefapp/widgets/ads_widget.dart';
import 'package:moqefapp/widgets/search_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const id = "homepage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
            width: screenSize(context).width,
            child: BarWidget(
              child: Consumer2<AdProvider, CategoryProvider>(
                  builder: (context, ad, category, _) {
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
                    SeachInput(
                      controller: searchController,
                      search: () {
                        Navigator.pushNamed(context, SearchPage.id,
                            arguments: searchController.text);
                      },
                      onFilter: () {
                        Navigator.pushNamed(context, FilterPage.id);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.locale.machine_category,
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Config.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 20),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                              itemCount: category.machineCategories.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    ad.setResults(ad.ads
                                        .where((element) =>
                                            element.machineCategory != null &&
                                            element.machineCategory!.uid
                                                .contains(category
                                                    .machineCategories[index]
                                                    .uid))
                                        .toList());
                                    Navigator.pushNamed(context, ResultPage.id);
                                  },
                                  child: Container(
                                    height: 180,
                                    width: 150,
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade200,
                                              blurRadius: 5,
                                              offset: const Offset(0, 5))
                                        ]),
                                    child: Column(
                                      children: [
                                        CachedNetworkImage(
                                            imageUrl: category
                                                .machineCategories[index].image,
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.fitHeight),
                                        Text(
                                          category
                                              .machineCategories[index].name,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Config.black),
                                        )
                                            .paddingSymmetric(horizontal: 5)
                                            .expandIt(),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: ad.soldMachines.isNotEmpty,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.locale.machine_vendre,
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Config.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                onTap: () {
                                  ad.setResults(ad.soldMachines);
                                  Navigator.pushNamed(context, ResultPage.id);
                                },
                                child: Text(
                                  context.locale.voir_plus,
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Config.secondaryColor,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          ).paddingSymmetric(horizontal: 20),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 350,
                            child: ListView.builder(
                                itemCount: ad.soldMachines.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return AdsWidget(ad: ad.soldMachines[index]);
                                }),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: ad.rentedMachines.isNotEmpty,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.locale.machine_louer,
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Config.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                onTap: () {
                                  ad.setResults(ad.rentedMachines);
                                  Navigator.pushNamed(context, ResultPage.id);
                                },
                                child: Text(
                                  context.locale.voir_plus,
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Config.secondaryColor,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          ).paddingSymmetric(horizontal: 20),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 350,
                            child: ListView.builder(
                                itemCount: ad.rentedMachines.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return AdsWidget(
                                      ad: ad.rentedMachines[index]);
                                }),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: ad.equipments.isNotEmpty,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.locale.pieces,
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Config.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                onTap: () {
                                  ad.setResults(ad.equipments);
                                  Navigator.pushNamed(context, ResultPage.id);
                                },
                                child: Text(
                                  context.locale.voir_plus,
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Config.secondaryColor,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          ).paddingSymmetric(horizontal: 20),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 350,
                            child: ListView.builder(
                                itemCount: ad.equipments.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return AdsWidget(ad: ad.equipments[index]);
                                }),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: ad.transport.isNotEmpty,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.locale.transport,
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Config.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                onTap: () {
                                  ad.setResults(ad.transport);
                                  Navigator.pushNamed(context, ResultPage.id);
                                },
                                child: Text(
                                  context.locale.voir_plus,
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Config.secondaryColor,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          ).paddingSymmetric(horizontal: 20),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 350,
                            child: ListView.builder(
                                itemCount: ad.transport.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return AdsWidget(ad: ad.transport[index]);
                                }),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: ad.huilles.isNotEmpty,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.locale.huile_equipement,
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Config.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                onTap: () {
                                  ad.setResults(ad.huilles);
                                  Navigator.pushNamed(context, ResultPage.id);
                                },
                                child: Text(
                                  context.locale.voir_plus,
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Config.secondaryColor,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          ).paddingSymmetric(horizontal: 20),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 350,
                            child: ListView.builder(
                                itemCount: ad.huilles.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return AdsWidget(ad: ad.huilles[index]);
                                }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                );
              }),
            )),
      ),
    );
  }
}
