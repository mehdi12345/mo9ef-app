import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:moqefapp/models/category.dart' as c;
import 'package:moqefapp/models/client.dart';
import 'package:moqefapp/models/machine_category.dart';

class Ad {
  String uid;
  String title;
  String description;
  String thambnail;
  double? weight;
  double? length;
  List<String> images = [];
  MachineCategory? machineCategory;
  double price;
  String city;
  c.Category? category;
  String? make;
  String? departure;
  String? arrival;
  int status = 1;
  double? litre;
  Client? client;
  String? clientUid;
  DateTime createdAt;
  String? type;
  Ad({
    required this.uid,
    required this.title,
    required this.description,
    required this.thambnail,
    this.weight,
    required this.images,
    required this.price,
    required this.city,
    this.type = 'Sell',
    this.category,
    this.make,
    this.departure,
    this.arrival,
    this.status = 1,
    this.length,
    this.litre,
    this.client,
    this.machineCategory,
    this.clientUid,
    required this.createdAt,
  });

  Ad copyWith({
    String? uid,
    String? title,
    String? description,
    String? thambnail,
    double? weight,
    List<String>? images,
    double? price,
    String? city,
    c.Category? category,
    String? make,
    String? departure,
    String? arrival,
    int? status,
    Client? client,
    double? litre,
    String? clientUid,
  }) {
    return Ad(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      thambnail: thambnail ?? this.thambnail,
      weight: weight ?? this.weight,
      images: images ?? this.images,
      price: price ?? this.price,
      city: city ?? this.city,
      category: category ?? this.category,
      make: make ?? this.make,
      departure: departure ?? this.departure,
      arrival: arrival ?? this.arrival,
      status: status ?? this.status,
      client: client ?? this.client,
      litre: litre ?? this.litre,
      createdAt: createdAt,
      machineCategory: machineCategory,
      clientUid: clientUid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'thambnail': thambnail,
      'weight': weight,
      'images': images,
      'price': price,
      'city': city,
      'category': category!.uid,
      'make': make,
      'departure': departure,
      'arrival': arrival,
      'status': status,
      'litre': litre,
      'client': client!.uid,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'machineCategory': machineCategory?.uid,
      'type': type
    };
  }

  factory Ad.fromMap(Map<String, dynamic> map) {
    ;
    return Ad(
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      thambnail: map['thambnail'] ?? '',
      weight: map['weight']?.toDouble(),
      images: List<String>.from(map['images'] ?? []),
      price: map['price']?.toDouble() ?? 0.0,
      city: map['city'] ?? '',
      make: map['make'],
      departure: map['departure'],
      arrival: map['arrival'],
      litre: map['litre']?.toDouble(),
      status: map['status']?.toInt() ?? 0,
      type: map['type'] ?? 'A vendre',
      clientUid: map['client'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }
  List<Ad> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return Ad.fromMap(dataMap);
    }).toList();
  }

  String toJson() => json.encode(toMap());

  factory Ad.fromJson(String source) => Ad.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Ad(uid: $uid, title: $title, description: $description, thambnail: $thambnail, weight: $weight, images: $images, price: $price, city: $city, category: $category, make: $make, departure: $departure, arrival: $arrival,  status: $status, client: $client, createdAt: $createdAt, machineCategory: $machineCategory)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ad &&
        other.uid == uid &&
        other.title == title &&
        other.description == description &&
        other.thambnail == thambnail &&
        other.weight == weight &&
        listEquals(other.images, images) &&
        other.price == price &&
        other.city == city &&
        other.category == category &&
        other.make == make &&
        other.departure == departure &&
        other.arrival == arrival &&
        other.status == status &&
        other.client == client;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        title.hashCode ^
        description.hashCode ^
        thambnail.hashCode ^
        weight.hashCode ^
        images.hashCode ^
        price.hashCode ^
        city.hashCode ^
        category.hashCode ^
        make.hashCode ^
        departure.hashCode ^
        arrival.hashCode ^
        status.hashCode ^
        client.hashCode;
  }
}
//   Client(uid: '', fullname: '', phone: '', email: '', imageUrl: '')
//= c.Category(uid: '', name: '')