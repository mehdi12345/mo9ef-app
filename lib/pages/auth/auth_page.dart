// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/pages/controlle_page.dart';
import 'package:moqefapp/providers/auth_provider.dart';
import 'package:moqefapp/providers/client_provider.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);
  static const String id = 'authpage';
  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final TextEditingController _signinEmailController = TextEditingController();
  final TextEditingController _signinPasswordController =
      TextEditingController();
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPasswordController =
      TextEditingController();
  final TextEditingController _signupphoneController = TextEditingController();
  final TextEditingController _signupNameController = TextEditingController();
  final TextEditingController _forgetEmailController = TextEditingController();
  bool _obscureText = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider _authProvider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _authProvider = Provider.of<AuthProvider>(context, listen: false);
    });
  }

  var signInFormKey = GlobalKey<FormState>();
  var signUpFormKey = GlobalKey<FormState>();
  var forgetFormKey = GlobalKey<FormState>();

  @override
  dispose() {
    super.dispose();
    _signinEmailController.dispose();
    _signinPasswordController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupphoneController.dispose();
    _signupNameController.dispose();
    _forgetEmailController.dispose();
  }

  signIn() async {
    var validate = signInFormKey.currentState?.validate();
    if (validate != null && validate) {
      Navigator.of(context).pop();
      Config.loading(context);
      log("loading");
      var result = await _authProvider.login(
        _signinEmailController.text.trim(),
        _signinPasswordController.text.trim(),
      );
      log("result$result");
      if (result) {
        Provider.of<ClientProvider>(context, listen: false)
            .setClient(_authProvider.authClient!);
        Navigator.of(context).pushNamed(ControllePage.id, arguments: 0);
      } else {
        Navigator.of(context).pop();
        log("error${_authProvider.message}");
        ScaffoldMessenger.of(context).showMaterialBanner(
            Config.errorBanner(context, _authProvider.message));
        Timer(const Duration(seconds: 2), () {
          ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
        });
      }
    }
  }

  apple() async {
    Config.loading(context);
    log("loading");
    var result = await _authProvider.signInWithApple();
    log("result$result");
    if (result != null && result) {
      Provider.of<ClientProvider>(context, listen: false)
          .setClient(_authProvider.authClient!);
      Navigator.of(context).pushNamed(ControllePage.id, arguments: 0);
    } else {
      Navigator.of(context).pop();
      log("error${_authProvider.message}");
      ScaffoldMessenger.of(context).showMaterialBanner(
          Config.errorBanner(context, _authProvider.message));
      Timer(const Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
      });
    }
  }

  google() async {
    Config.loading(context);
    log("loading");
    var result = await _authProvider.googleAuth();
    log("result$result");
    if (result != null && result) {
      Provider.of<ClientProvider>(context, listen: false)
          .setClient(_authProvider.authClient!);
      Navigator.of(context).pushNamed(ControllePage.id, arguments: 0);
    } else {
      Navigator.of(context).pop();
      log("error${_authProvider.message}");
      ScaffoldMessenger.of(context).showMaterialBanner(
          Config.errorBanner(context, _authProvider.message));
      Timer(const Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
      });
    }
  }

  facebook() async {
    Config.loading(context);
    log("loading");
    var result = await _authProvider.facebookAuth();
    log("result$result");
    if (result != null && result) {
      Provider.of<ClientProvider>(context, listen: false)
          .setClient(_authProvider.authClient!);
      Navigator.of(context).pushNamed(ControllePage.id, arguments: 0);
    } else {
      Navigator.of(context).pop();
      log("error${_authProvider.message}");
      ScaffoldMessenger.of(context).showMaterialBanner(
          Config.errorBanner(context, _authProvider.message));
      Timer(const Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
      });
    }
  }

  signUp() async {
    var validate = signUpFormKey.currentState?.validate();
    if (validate != null && validate) {
      Navigator.of(context).pop();
      Config.loading(context);
      log("loading");
      var result = await _authProvider.register(
        _signupNameController.text.trim(),
        _signupEmailController.text.trim(),
        _signupPasswordController.text.trim(),
        _signupphoneController.text.trim(),
      );
      log("result$result");
      if (result) {
        Provider.of<ClientProvider>(context, listen: false)
            .setClient(_authProvider.authClient!);
        Navigator.of(context).pushNamed(ControllePage.id, arguments: 0);
      } else {
        Navigator.of(context).pop();
        log("error${_authProvider.message}");
        ScaffoldMessenger.of(context).showMaterialBanner(
            Config.errorBanner(context, _authProvider.message));
        Timer(const Duration(seconds: 2), () {
          ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
        });
      }
    }
  }

  recover() {
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: _forgetEmailController.text.trim())
        .then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showMaterialBanner(Config.successBanner(
          context, "تم ارسال رسالة تغير كلمة المرور الى الايميل الخاص بك"));
    }).catchError((error) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showMaterialBanner(Config.errorBanner(context, error.toString()));
    });
  }

  login() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Form(
                    key: signInFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          context.locale.signIn,
                          style: GoogleFonts.cairo(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _signinEmailController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return context.locale.emailRequired;
                            } else {
                              if (!val.contains('@')) {
                                return context.locale.emailRequired;
                              }
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: context.locale.email,
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              prefixIcon: Icon(
                                Ionicons.mail_outline,
                                color: Config.primaryColor,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Config.primaryColor))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _signinPasswordController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return context.locale.passwordRequired;
                            } else if (val.length < 6) {
                              return context.locale.passwordRequired;
                            }
                            return null;
                          },
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              hintText: context.locale.password,
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              prefixIcon: Icon(
                                Ionicons.lock_closed_outline,
                                color: Config.primaryColor,
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  state(() {
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
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            forgetPassword();
                          },
                          child: Text(
                            context.locale.forgetPassword,
                            style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Config.primaryColor),
                          ),
                        ).align(
                          alignment: Alignment.centerRight,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BouncingWidget(
                          onPressed: () {
                            signIn();
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Config.primaryColor),
                            child: Center(
                              child: Text(
                                context.locale.signIn,
                                style: GoogleFonts.poppins(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(context.locale.don_have_acc,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Config.black))
                                .align(alignment: Alignment.center),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                register();
                              },
                              child: Text(context.locale.signup,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          color: Config.primaryColor))
                                  .align(alignment: Alignment.center),
                            ),
                          ],
                        ).paddingSymmetric(vertical: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ));
  }

  register() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Form(
                    key: signUpFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          context.locale.signup,
                          style: GoogleFonts.cairo(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _signupNameController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return context.locale.nameRequired;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: context.locale.nom_complet,
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              prefixIcon: Icon(
                                Ionicons.person_outline,
                                color: Config.primaryColor,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Config.primaryColor))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _signupEmailController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return context.locale.emailRequired;
                            } else {
                              if (!val.contains('@')) {
                                return context.locale.emailInvalid;
                              }
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: context.locale.email,
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              prefixIcon: Icon(
                                Ionicons.mail_outline,
                                color: Config.primaryColor,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Config.primaryColor))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _signupphoneController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return context.locale.phoneRequired;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: context.locale.phone,
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              prefixIcon: Icon(
                                Ionicons.call_outline,
                                color: Config.primaryColor,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Config.primaryColor))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _signupPasswordController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return context.locale.passwordRequired;
                            } else if (val.length < 6) {
                              return context.locale.passwordInvalid;
                            }
                            return null;
                          },
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              hintText: context.locale.password,
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              prefixIcon: Icon(
                                Ionicons.lock_closed_outline,
                                color: Config.primaryColor,
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  state(() {
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
                        const SizedBox(
                          height: 10,
                        ),
                        BouncingWidget(
                          onPressed: () {
                            signUp();
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Config.primaryColor),
                            child: Center(
                              child: Text(
                                context.locale.signup,
                                style: GoogleFonts.poppins(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(context.locale.have_acc,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Config.black))
                                .align(alignment: Alignment.center),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                login();
                              },
                              child: Text(context.locale.login,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          color: Config.primaryColor))
                                  .align(alignment: Alignment.center),
                            ),
                          ],
                        ).paddingSymmetric(vertical: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  forgetPassword() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: screenSize(context).height * .4,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Form(
                  key: forgetFormKey,
                  child: Column(
                    children: <Widget>[
                      Text(
                        context.locale.forget_password,
                        style: GoogleFonts.cairo(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: _forgetEmailController,
                        decoration: InputDecoration(
                            hintText: context.locale.email,
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            prefixIcon: Icon(
                              Ionicons.mail_outline,
                              color: Config.primaryColor,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: Config.primaryColor))),
                      ),
                      const Spacer(),
                      BouncingWidget(
                        onPressed: () {
                          recover();
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Config.primaryColor),
                          child: Center(
                            child: Text(
                              context.locale.recover,
                              style: GoogleFonts.poppins(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
              context.locale.localeName == 'ar'
                  ? Ionicons.chevron_forward
                  : Ionicons.chevron_back,
              color: Config.black),
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: screenSize(context).height,
          width: screenSize(context).width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: RichText(
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
                ),
                SizedBox(
                  height: screenSize(context).height * 0.02,
                ),
                Image.asset(
                  Config.logo,
                  fit: BoxFit.contain,
                  height: 200,
                ),
                SizedBox(
                  height: screenSize(context).height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${context.locale.have_acc} ",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    GestureDetector(
                      onTap: () {
                        login();
                      },
                      child: Text(
                        context.locale.login,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Config.primaryColor),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: screenSize(context).height * 0.05,
                ),
                BouncingWidget(
                  onPressed: () {
                    apple();
                  },
                  child: Container(
                    height: 50,
                    width: screenSize(context).width * .8,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Ionicons.logo_apple,
                            color: Colors.white, size: 30),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          context.locale.apple,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BouncingWidget(
                  onPressed: () {
                    facebook();
                  },
                  child: Container(
                    height: 50,
                    width: screenSize(context).width * .8,
                    decoration: BoxDecoration(
                      color: Config.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/facebook.png', height: 30),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          context.locale.facebook,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BouncingWidget(
                  onPressed: () {
                    google();
                  },
                  child: Container(
                    height: 50,
                    width: screenSize(context).width * .8,
                    decoration: BoxDecoration(
                      color: Config.secondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/google.png', height: 30),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          context.locale.google,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BouncingWidget(
                  onPressed: () {
                    register();
                  },
                  child: Container(
                      height: 50,
                      width: screenSize(context).width * .8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Config.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          context.locale.signup,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(context.locale.accepting_terms,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
