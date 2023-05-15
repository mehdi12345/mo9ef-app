import 'package:moqefapp/database/database.dart';
import 'package:moqefapp/models/ad.dart';
import 'package:moqefapp/models/category.dart';
import 'package:moqefapp/models/client.dart';
import 'package:moqefapp/models/machine_category.dart';
import 'package:moqefapp/providers/base_provider.dart';

class ClientProvider extends BaseProvider {
  Client _client =
      Client(uid: "", fullname: "", phone: "", email: "", imageUrl: "");
  Client get client => _client;
  final List<Ad> _savedAds = [];
  List<Ad> get ads => _savedAds;
  void setClient(Client client) {
    _client = client;
    notifyListeners();
  }

  updateClientPhone(String phone, String name) {
    _client.phone = phone;
    _client.fullname = name;
    Database.instance.userCollection.doc(_client.uid).update({
      "phone": phone,
      "fullname": name,
    });
    notifyListeners();
  }

  updateClient(String name, String email, String phone) {
    _client.fullname = name;
    _client.phone = phone;
    _client.email = email;
    Database.instance.userCollection.doc(_client.uid).update({
      "fullname": name,
      "phone": phone,
      "email": email,
    });
    notifyListeners();
  }

  updateClientImage(String imageUrl) {
    _client.imageUrl = imageUrl;
    Database.instance.userCollection.doc(_client.uid).update({
      "imageUrl": imageUrl,
    });
    notifyListeners();
  }

  init() async {
    setBusy(true);
    _savedAds.clear();
    Database.instance.userCollection
        .doc(_client.uid)
        .collection("savedAds")
        .get()
        .then((value) {
      /*   query.docs.forEach((element) async {
      Ad ad = Ad.fromMap(element.data() as Map<String, dynamic>);
      Map<String, dynamic> clientData = (await Database.instance.userCollection
              .where('uid', isEqualTo: element.get('client'))
              .get())
          .docs
          .first
          .data() as Map<String, dynamic>;
      ad.client = Client.fromMap(clientData);
      Map<String, dynamic> category = (await Database.instance.category
              .where('uid', isEqualTo: element.get('category'))
              .get())
          .docs
          .first
          .data() as Map<String, dynamic>;
      ad.category = Category.fromMap(category);
      Map<String, dynamic>? machine = (await Database.instance.machineCategory
              .where('uid', isEqualTo: element.get('machineCategory'))
              .get())
          .docs
          .first
          .data() as Map<String, dynamic>?;
      if (machine != null)
        ad.machineCategory = MachineCategory.fromMap(machine);
      _ads.add(ad); */
      for (var item in value.docs) {
        if (item.exists) {
          Database.instance.adsCollection
              .doc(item.get('uid'))
              .get()
              .then((value) async {
            Map<String, dynamic>? data = value.data() != null
                ? value.data() as Map<String, dynamic>
                : null;
            if (data != null) {
              Ad ad = Ad.fromMap(data);
              Map<String, dynamic> clientData = (await Database
                      .instance.userCollection
                      .where('uid', isEqualTo: value.get('client'))
                      .get())
                  .docs
                  .first
                  .data() as Map<String, dynamic>;
              ad.client = Client.fromMap(clientData);
              Map<String, dynamic> category = (await Database.instance.category
                      .where('uid', isEqualTo: value.get('category'))
                      .get())
                  .docs
                  .first
                  .data() as Map<String, dynamic>;
              ad.category = Category.fromMap(category);
              Map<String, dynamic>? machine = (await Database
                      .instance.machineCategory
                      .where('uid', isEqualTo: value.get('machineCategory'))
                      .get())
                  .docs
                  .first
                  .data() as Map<String, dynamic>?;
              if (machine != null) {
                ad.machineCategory = MachineCategory.fromMap(machine);
              }
              _savedAds.add(ad);
              notifyListeners();
            }
          });
        }
      }
      setBusy(false);
    });
    setBusy(false);
  }

  saveAd(Ad ad) {
    if (_savedAds.any((element) => element.uid == ad.uid)) {
      _savedAds.remove(ad);
      Database.instance.userCollection
          .doc(_client.uid)
          .collection("savedAds")
          .where("uid", isEqualTo: ad.uid)
          .get()
          .then((value) {
        for (var item in value.docs) {
          item.reference.delete();
        }
      });
    } else {
      _savedAds.add(ad);
      Database.instance.userCollection
          .doc(_client.uid)
          .collection("savedAds")
          .add({
        "uid": ad.uid,
      });
    }
    notifyListeners();
  }

  void setNotificationToken() {
    // FirebaseMessaging.instance.getToken().then((token) {
    //   if (token != null) {
    //     Database.instance.userCollection.doc(_client.uid).update({
    //       'fcm_token': token,
    //     });
    //   }
    //   notifyListeners();
    // });
  }
}
