import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/pages/profile/password_page.dart';
import 'package:moqefapp/preferences/prefs.dart';
import 'package:moqefapp/providers/client_provider.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);
  static const id = "edit_profile_screen";
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Map<String, String>? selectedLanguage;
  late TextEditingController _nameController,
      _emailController,
      _phoneController;
  String? platform;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      platform = await Prefs.instance.getPlatform();
      if (mounted) {
        _nameController.text =
            Provider.of<ClientProvider>(context, listen: false).client.fullname;
        _emailController.text =
            Provider.of<ClientProvider>(context, listen: false).client.email;
        _phoneController.text =
            Provider.of<ClientProvider>(context, listen: false).client.phone;
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

  updateUserData() {
    Provider.of<ClientProvider>(context, listen: false).updateClient(
      _nameController.text,
      _emailController.text,
      _phoneController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        updateUserData();
        return true;
      },
      child: Scaffold(
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
                  onPressed: () {
                    updateUserData();
                    Navigator.pop(context);
                  }),
              title: Text(
                context.locale.modifier_profile,
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Config.black,
                    fontWeight: FontWeight.w600),
              )),
          body: Container(
              width: screenSize(context).width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.locale.nom_complet,
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Config.black,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            hintText: context.locale.nom_complet,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            fillColor: Config.background,
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Config.black,
                                fontWeight: FontWeight.w400)),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        context.locale.email_address,
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Config.black,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            hintText: context.locale.phone,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            fillColor: Config.background,
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Config.black,
                                fontWeight: FontWeight.w400)),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        context.locale.phone,
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Config.black,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            fillColor: Config.background,
                            hintText: context.locale.phone,
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Config.black,
                                fontWeight: FontWeight.w400)),
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: checkAuthProvider(),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, PasswordPage.id);
                          },
                          child: SizedBox(
                            height: 45,
                            width: screenSize(context).width,
                            child: Row(
                              children: [
                                Text(
                                  context.locale.change_password,
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Config.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                Icon(
                                  context.locale.localeName == 'ar'
                                      ? Ionicons.chevron_back
                                      : Ionicons.chevron_forward,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 50),
                          child: OutlinedButton.icon(
                            onPressed: () {
                              updateUserData();
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.done, size: 18),
                            label: const Text("VALIDEE"),
                          ),
                        ),
                      )
                    ]),
              ))),
    );
  }
}
