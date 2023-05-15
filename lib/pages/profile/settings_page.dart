// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/pages/controlle_page.dart';
import 'package:moqefapp/preferences/prefs.dart';
import 'package:moqefapp/providers/auth_provider.dart';
import 'package:moqefapp/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  static const id = "setting_screen";
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Map<String, String>? selectedLanguage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Config.background,
        appBar: AppBar(
            backgroundColor: Config.background,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
                icon: Icon(
                    context.locale.localeName == 'ar'
                        ? Ionicons.chevron_forward
                        : Ionicons.chevron_back,
                    color: Config.black),
                onPressed: () => Navigator.pop(context)),
            title: Text(
              context.locale.parametres,
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Config.black,
                  fontWeight: FontWeight.w600),
            )),
        body: Container(
            width: screenSize(context).width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                context.locale.language,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Config.black,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              DropdownSearch<Map<String, String>>(
                  items: Config.languages,
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value;
                      Provider.of<LocaleProvider>(context, listen: false)
                          .setLocale(Locale(value?['code'].toString() ?? 'ar'));
                    });
                  },
                  selectedItem: selectedLanguage,
                  itemAsString: (item) => item['name'].toString(),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Config.primaryColor),
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        fillColor: Config.background,
                        hintText: "Select Language",
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Config.black,
                            fontWeight: FontWeight.w400)),
                  )),
              const SizedBox(height: 20),
              SizedBox(
                height: 45,
                width: screenSize(context).width,
                child: Row(
                  children: [
                    Text(
                      context.locale.privacy_policy,
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Config.black,
                          fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Icon(context.locale.localeName == 'ar'
                        ? Ionicons.chevron_back
                        : Ionicons.chevron_forward)
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 45,
                width: screenSize(context).width,
                child: Row(
                  children: [
                    Text(
                      context.locale.terms_of_use,
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Config.black,
                          fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Icon(context.locale.localeName == 'ar'
                        ? Ionicons.chevron_back
                        : Ionicons.chevron_forward)
                  ],
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  Config.loading(context);
                  await Prefs.instance.clearClient();
                  bool res =
                      await Provider.of<AuthProvider>(context, listen: false)
                          .logout();
                  if (res) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, ControllePage.id, (route) => false,
                        arguments: 0);
                  }
                },
                child: SizedBox(
                  height: 45,
                  width: screenSize(context).width,
                  child: Row(
                    children: [
                      Text(
                        context.locale.logout,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      const Icon(
                        Ionicons.log_out_outline,
                        color: Colors.red,
                      )
                    ],
                  ),
                ),
              ),
            ])));
  }
}
