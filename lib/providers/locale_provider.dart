import 'package:flutter/material.dart';
import 'package:moqefapp/l10n/l10n.dart';
import 'package:moqefapp/preferences/prefs.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    Prefs.instance.setLanguageCode(locale.languageCode);
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }

  void init() async {
    String? languageCode = await Prefs.instance.getLanguageCode();
    Locale locale = Locale(languageCode ?? "fr");
    setLocale(locale);
  }
}
