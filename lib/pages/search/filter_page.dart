import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/models/category.dart';
import 'package:moqefapp/models/city.dart';
import 'package:moqefapp/pages/search/search_page.dart';
import 'package:moqefapp/providers/ad_provider.dart';
import 'package:moqefapp/providers/category_provider.dart';
import 'package:moqefapp/widgets/city_widget.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);
  static const id = 'filter_Page';
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  Category? _selectedCategory;
  City? _city;
  bool priceCroissant = true;

  search() {
    Provider.of<AdProvider>(context, listen: false)
        .filterSearch(_selectedCategory, _city, priceCroissant);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SearchPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Config.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          context.locale.filter,
          style: GoogleFonts.poppins(
              fontSize: 22, fontWeight: FontWeight.w500, color: Config.black),
        ),
        backgroundColor: Config.background,
        elevation: 0,
      ),
      backgroundColor: Config.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BouncingWidget(
        onPressed: () {
          search();
        },
        child: Container(
            height: 55,
            width: screenSize(context).width,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Config.primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              context.locale.chercher,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            )),
      ),
      body: SizedBox(
        height: screenSize(context).height,
        width: screenSize(context).width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                context.locale.category,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Config.black),
              ).align(alignment: Alignment.centerLeft).paddingOnly(left: 20),
              const SizedBox(
                height: 10,
              ),
              DropdownButton2<Category>(
                items: Provider.of<CategoryProvider>(context)
                    .categories
                    .map((e) => DropdownMenuItem<Category>(
                          value: e,
                          child: Text(e.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                hint: Text(context.locale.choose_category),
                style: GoogleFonts.poppins(color: Config.black, fontSize: 16),
                buttonHeight: 50,
                itemHeight: 50,
                buttonWidth: screenSize(context).width,
                value: _selectedCategory,
                buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
                underline: Container(),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200,
                ),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade300.withOpacity(.7),
                ),
              ).paddingSymmetric(
                horizontal: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              CityDropDownWidget(
                selectedCity: _city,
                label: context.locale.ville,
                hint: context.locale.ville,
                onChanged: (city) {
                  setState(() {
                    _city = city;
                  });
                },
              ).paddingSymmetric(
                horizontal: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                context.locale.prix,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Config.black),
              ).align(alignment: Alignment.centerLeft).paddingOnly(left: 20),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        priceCroissant = false;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: !priceCroissant
                            ? Config.primaryColor
                            : Colors.grey.shade300.withOpacity(.7),
                      ),
                      child: Text(
                        context.locale.prix_decroissant,
                        style: GoogleFonts.poppins(
                            color:
                                !priceCroissant ? Colors.white : Config.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ).makeItFlexible(),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        priceCroissant = true;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: priceCroissant
                            ? Config.primaryColor
                            : Colors.grey.shade300.withOpacity(.7),
                      ),
                      child: Text(
                        context.locale.prix_croissant,
                        style: GoogleFonts.poppins(
                            color: priceCroissant ? Colors.white : Config.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ).makeItFlexible(),
                ],
              ).paddingSymmetric(horizontal: 20)
            ],
          ),
        ),
      ),
    );
  }
}
