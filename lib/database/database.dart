import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moqefapp/models/client.dart';

class Database {
  Database._privateConstructor();
  static Database instance = Database._privateConstructor();
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference adsCollection =
      FirebaseFirestore.instance.collection('ads');
  CollectionReference reviewsCollection =
      FirebaseFirestore.instance.collection('reviews');
  CollectionReference category =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference machineCategory =
      FirebaseFirestore.instance.collection('machine_categories');
  CollectionReference notificationCollection =
      FirebaseFirestore.instance.collection('notifications');

  Future<void> addUser(Client client) async {
    try {
      await userCollection.doc(client.uid).set(client.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Client?> getUser(String uid) async {
    try {
      DocumentSnapshot snapshot = await userCollection.doc(uid).get();
      return Client.fromMap(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool> checkUser(String uid) async {
    try {
      DocumentSnapshot snapshot = await userCollection.doc(uid).get();
      return snapshot.exists;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
