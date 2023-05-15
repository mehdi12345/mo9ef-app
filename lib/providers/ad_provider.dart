import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:moqefapp/database/database.dart';
import 'package:moqefapp/models/ad.dart';
import 'package:moqefapp/models/category.dart';
import 'package:moqefapp/models/city.dart';
import 'package:moqefapp/models/client.dart';
import 'package:moqefapp/models/machine_category.dart';
import 'package:moqefapp/providers/base_provider.dart';

class AdProvider extends BaseProvider {
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instanceFor(bucket: 'mo9ef');
  late Ad _ad;
  Ad get ad => _ad;
  final List<Ad> _ads = [];
  List<Ad> get ads => _ads;
  final List<Ad> _clientAds = [];
  List<Ad> get clientAds => _clientAds;
  List<Ad> get equipments =>
      _ads.where((ad) => ad.category!.uid == 'a3S74jwragQi3pUMwcte').toList();
  List<Ad> get transport =>
      _ads.where((ad) => ad.category!.uid == 'rwAAHojffDZP9U4URtvN').toList();
  List<Ad> get soldMachines => _ads
      .where((ad) =>
          ad.category!.uid == 'CBgR4EvCtyodV2EqLeKg' && ad.type == 'À vendre')
      .toList();
  List<Ad> get rentedMachines => _ads
      .where((ad) =>
          ad.category!.uid == 'CBgR4EvCtyodV2EqLeKg' && ad.type == 'À louer')
      .toList();
  List<Ad> get huilles =>
      _ads.where((ad) => ad.category!.uid == 'WHoFjiJf8T126Cy0F99n').toList();
  final List<Ad> _searchedAds = [];
  List<Ad> get searchedAds => _searchedAds;

  List<Ad> _results = [];
  List<Ad> get results => _results;

  setResults(List<Ad> results) {
    _results = results;
    notifyListeners();
  }

  seCurrentAd(Ad ad) {
    _ad = ad;
    notifyListeners();
  }

  newAd(Ad ad) {
    Database.instance.adsCollection.add(ad.toMap());
  }

  Future<List<Ad>> searchData(query) async {
    // setBusy(true);
    _searchedAds.clear();
    await Database.instance.adsCollection.get().then((doc) async {
      for (var doc in doc.docs) {
        final ad = Ad.fromMap(doc.data() as Map<String, dynamic>);
        if (ad.status == 0) return;
        if (ad.title.toLowerCase().contains(query.toLowerCase()) ||
            ad.description.toLowerCase().contains(query.toLowerCase())) {
          Map<String, dynamic> clientData = (await Database
                  .instance.userCollection
                  .where('uid', isEqualTo: doc.get('client'))
                  .get())
              .docs
              .first
              .data() as Map<String, dynamic>;
          ad.client = Client.fromMap(clientData);
          Map<String, dynamic> categorydata = (await Database.instance.category
                  .where('uid', isEqualTo: doc.get('category'))
                  .get())
              .docs
              .first
              .data() as Map<String, dynamic>;
          ad.category = Category.fromMap(categorydata);
          Map<String, dynamic>? machine = (await Database
                  .instance.machineCategory
                  .where('uid', isEqualTo: doc.get('machineCategory'))
                  .get())
              .docs
              .first
              .data() as Map<String, dynamic>?;
          if (machine != null) {
            ad.machineCategory = MachineCategory.fromMap(machine);
          }
          _searchedAds.add(ad);
        }
      }
      // setBusy(false);
    });
    // setBusy(false);
    notifyListeners();
    return _searchedAds;
  }

  Future<List<Ad>> searchDataprofile(query) async {
    _searchedAds.clear();
    await Database.instance.adsCollection.get().then((doc) async {
      for (var doc in doc.docs) {
        final ad = Ad.fromMap(doc.data() as Map<String, dynamic>);
        if (ad.status == 0) return;
        if (ad.clientUid == query) {
          Map<String, dynamic> clientData = (await Database
                  .instance.userCollection
                  .where('uid', isEqualTo: doc.get('client'))
                  .get())
              .docs
              .first
              .data() as Map<String, dynamic>;
          ad.client = Client.fromMap(clientData);
          Map<String, dynamic> categorydata = (await Database.instance.category
                  .where('uid', isEqualTo: doc.get('category'))
                  .get())
              .docs
              .first
              .data() as Map<String, dynamic>;
          ad.category = Category.fromMap(categorydata);
          Map<String, dynamic>? machine = (await Database
                  .instance.machineCategory
                  .where('uid', isEqualTo: doc.get('machineCategory'))
                  .get())
              .docs
              .first
              .data() as Map<String, dynamic>?;
          if (machine != null) {
            ad.machineCategory = MachineCategory.fromMap(machine);
          }
          _searchedAds.add(ad);
        }
      }
    });
    notifyListeners();
    return _searchedAds;
  }

  Future<Client> profileClient(query) async {
    Map<String, dynamic> clientData = (await Database.instance.userCollection
            .where('uid', isEqualTo: query)
            .get())
        .docs
        .first
        .data() as Map<String, dynamic>;
    Client client = Client.fromMap(clientData);
    notifyListeners();
    return client;
  }

  Future<void> filterSearch(Category? category, City? city, bool asc) async {
    setBusy(true);
    _searchedAds.clear();
    for (var doc in (await Database.instance.adsCollection
            .orderBy("price", descending: !asc)
            .get())
        .docs) {
      Ad ad = Ad.fromMap(doc.data() as Map<String, dynamic>);
      if (ad.status == 0) return;
      Map<String, dynamic> clientData = (await Database.instance.userCollection
              .where('uid', isEqualTo: doc.get('client'))
              .get())
          .docs
          .first
          .data() as Map<String, dynamic>;
      ad.client = Client.fromMap(clientData);
      Map<String, dynamic> categorydata = (await Database.instance.category
              .where('uid', isEqualTo: doc.get('category'))
              .get())
          .docs
          .first
          .data() as Map<String, dynamic>;
      ad.category = Category.fromMap(categorydata);
      Map<String, dynamic>? machine = (await Database.instance.machineCategory
              .where('uid', isEqualTo: doc.get('machineCategory'))
              .get())
          .docs
          .first
          .data() as Map<String, dynamic>?;
      if (machine != null) {
        ad.machineCategory = MachineCategory.fromMap(machine);
      }
      if (category != null && ad.category!.uid == category.uid ||
          city != null && ad.city == city.name) {
        _searchedAds.add(ad);
        notifyListeners();
      } else {
        if (category == null && city == null) {
          _searchedAds.add(ad);
          notifyListeners();
        }
      }
    }

    notifyListeners();
    setBusy(false);
  }

  initt() async {
    setBusy(true);
    QuerySnapshot query = await Database.instance.adsCollection.get();
    for (var element in query.docs) {
      Ad ad = Ad.fromMap(element.data() as Map<String, dynamic>);
      if (ad.status == 0) return;
      Map<String, dynamic> clientData = (await Database.instance.userCollection
              .where('uid', isEqualTo: element.get('client'))
              .get())
          .docs
          .first
          .data() as Map<String, dynamic>;
      ad.client = Client.fromMap(clientData);
      if (element.get('category') != null) {
        Map<String, dynamic> category = (await Database.instance.category
                .where('uid', isEqualTo: element.get('category'))
                .get())
            .docs
            .first
            .data() as Map<String, dynamic>;
        ad.category = Category.fromMap(category);
      }
      if (element.get('machineCategory') != null) {
        Map<String, dynamic>? machine = (await Database.instance.machineCategory
                .where('uid', isEqualTo: element.get('machineCategory'))
                .get())
            .docs
            .first
            .data() as Map<String, dynamic>?;

        if (machine != null) {
          ad.machineCategory = MachineCategory.fromMap(machine);
        }
      }
      _ads.add(ad);
      notifyListeners();
    }
    setBusy(false);
    notifyListeners();
  }

  Future<void> getAuthClientAds(String uid) async {
    if (_clientAds.isNotEmpty) return;
    setBusy(true);
    _clientAds.clear();
    QuerySnapshot query = await Database.instance.adsCollection
        .where('client', isEqualTo: uid)
        .get();

    for (var element in query.docs) {
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
      if (machine != null) {
        ad.machineCategory = MachineCategory.fromMap(machine);
      }
      _clientAds.add(ad);
      notifyListeners();
    }
    setBusy(false);
    notifyListeners();
  }

  addAd(Ad aad) async {
    try {
      DocumentReference<Object?> document =
          await Database.instance.adsCollection.add(aad.toMap());
      aad.uid = document.id;
      await document.set(aad.toMap());
      _ads.add(aad);
      notifyListeners();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  updateAd(Ad aad) async {
    try {
      await Database.instance.adsCollection.doc(aad.uid).update(aad.toMap());
      _clientAds.removeWhere((element) => element.uid == aad.uid);
      _clientAds.add(aad);
      _ads.removeWhere((element) => element.uid == aad.uid);
      _ads.add(aad);
      notifyListeners();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  deleteAd(String uid) async {
    var document = await Database.instance.adsCollection.doc(uid).get();
    if (document.exists) {
      document.reference.delete();
      _clientAds.removeWhere((element) => element.uid == uid);
      notifyListeners();
    }
  }

  Future<String?> uploadImage(XFile image) async {
    try {
      var ref =
          _storage.ref().child('ads/${Timestamp.now().millisecondsSinceEpoch}');
      var uploadTask = ref.putFile(File(image.path));
      var url = await (await uploadTask).ref.getDownloadURL();
      return url;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  removeImage(String url) async {
    try {
      var ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      log(e.toString());
    }
  }
}
