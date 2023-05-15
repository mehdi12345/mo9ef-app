import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/pages/auth/auth_page.dart';

class ShouldAuthPage extends StatefulWidget {
  const ShouldAuthPage({Key? key}) : super(key: key);

  @override
  State<ShouldAuthPage> createState() => _ShouldAuthPageState();
}

class _ShouldAuthPageState extends State<ShouldAuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          height: screenSize(context).height,
          width: screenSize(context).width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: context.locale.bienvenu,
                      style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  TextSpan(
                      text: " Mo9ef.ma",
                      style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Config.primaryColor)),
                ])),
                SizedBox(
                  height: screenSize(context).height * 0.05,
                ),
                Image.asset(
                  Config.logo,
                  fit: BoxFit.contain,
                  height: 200,
                ),
                SizedBox(
                  height: screenSize(context).height * 0.05,
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pushNamed(AuthPage.id),
                  child: Container(
                    height: 50,
                    width: screenSize(context).width,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Config.primaryColor),
                    child: Text(
                      context.locale.login,
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ).paddingSymmetric(horizontal: 30),
                )
              ],
            ),
          )),
    );
  }
}
