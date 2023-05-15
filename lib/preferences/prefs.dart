import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  Prefs._privateConstructor();

  static Prefs instance = Prefs._privateConstructor();
  //locale
  setLanguageCode(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language_code', languageCode);
  }

  Future<String?> getLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code');
  }

  ///client
  setClient(
    String id,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('client_id', id);
  }

  clearClient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('client_id');
  }

  Future<String?> getClient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('client_id');
  }

  /// AUTH PLATFORM
  setPlatform(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('platform', value);
  }

  Future<String?> getPlatform() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('platform');
  }
}
