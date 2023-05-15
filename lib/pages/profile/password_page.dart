import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/pages/controlle_page.dart';
import 'package:moqefapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({Key? key}) : super(key: key);
  static const id = "password_screen";
  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  late TextEditingController _oldPasswordController,
      _newPasswordController,
      _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true, _obscureText2 = true, _obscureText3 = true;
  _changePassword() async {
    Config.loading(context);
    bool res =
        await Provider.of<AuthProvider>(context, listen: false).changePassword(
      _newPasswordController.text,
    );

    if (mounted) {
      if (res) {
        Navigator.pop(context);
        Config.showAler(context,
            title: "Succès",
            message: "Mot de passe modifié avec succès",
            icon: Icons.check,
            color: Colors.greenAccent.shade400,
            softColor: Colors.greenAccent.shade100.withOpacity(.2),
            buttonText: "Ok", onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, ControllePage.id, (route) => false,
              arguments: 0);
        });
      } else {
        Config.showAler(context,
            title: "Erreur",
            message: "Mot de passe incorrect",
            icon: Icons.check,
            color: Colors.redAccent.shade400,
            softColor: Colors.redAccent.shade100.withOpacity(.2),
            buttonText: "Ok", onTap: () {
          Navigator.pop(context);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Config.background,
        appBar: AppBar(
            backgroundColor: Config.background,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Ionicons.chevron_back, color: Config.black),
                onPressed: () => Navigator.pop(context)),
            title: Text(
              "Change Password",
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Config.black,
                  fontWeight: FontWeight.w600),
            )),
        body: Container(
            width: screenSize(context).width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        "Ancien mot de passe",
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Config.black,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _oldPasswordController,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Entrer votre mot de passe';
                          } else if (val.length < 6) {
                            return 'Mot de passe trop court';
                          }
                          return null;
                        },
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            hintText: 'Ancien mot de passe',
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            prefixIcon: Icon(
                              Ionicons.lock_closed_outline,
                              color: Config.primaryColor,
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Ionicons.eye_off_outline
                                    : Ionicons.eye_outline,
                                color: Config.primaryColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: Config.primaryColor))),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Nouveau mot de passe",
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Config.black,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _newPasswordController,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Entrer votre mot de passe';
                          } else if (val.length < 6) {
                            return 'Mot de passe trop court';
                          }
                          return null;
                        },
                        obscureText: _obscureText2,
                        decoration: InputDecoration(
                            hintText: 'Nouveau mot de passe',
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            prefixIcon: Icon(
                              Ionicons.lock_closed_outline,
                              color: Config.primaryColor,
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _obscureText2 = !_obscureText2;
                                });
                              },
                              child: Icon(
                                _obscureText2
                                    ? Ionicons.eye_off_outline
                                    : Ionicons.eye_outline,
                                color: Config.primaryColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: Config.primaryColor))),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Confirmer le nouveau mot de passe",
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Config.black,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _confirmPasswordController,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Entrer votre mot de passe';
                          } else if (val.length < 6) {
                            return 'Mot de passe trop court';
                          }
                          if (val != _newPasswordController.text) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                        obscureText: _obscureText3,
                        decoration: InputDecoration(
                            hintText: "Confirmer le nouveau mot de passe",
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            prefixIcon: Icon(
                              Ionicons.lock_closed_outline,
                              color: Config.primaryColor,
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _obscureText3 = !_obscureText3;
                                });
                              },
                              child: Icon(
                                _obscureText3
                                    ? Ionicons.eye_off_outline
                                    : Ionicons.eye_outline,
                                color: Config.primaryColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: Config.primaryColor))),
                      ),
                      const SizedBox(height: 200),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _changePassword();
                          }
                        },
                        child: Container(
                            width: screenSize(context).width,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Config.primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "Changer le mot de passe",
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Config.background,
                                  fontWeight: FontWeight.w600),
                            )).paddingOnly(bottom: 50),
                      )
                    ]),
              ),
            )));
  }
}
