import 'dart:convert';

class Client {
  String uid;
  String fullname;
  String email;
  String phone;
  String imageUrl;
  Client({
    required this.uid,
    required this.fullname,
    required this.email,
    required this.phone,
    this.imageUrl =
        "https://firebasestorage.googleapis.com/v0/b/mo9ef/o/avatar.png?alt=media&token=4fe982e6-37b4-4fe7-b036-d5dfa11f56a3",
  });

  Client copyWith({
    String? uid,
    String? fullname,
    String? email,
    String? phone,
    String? imageUrl,
  }) {
    return Client(
      uid: uid ?? this.uid,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullname': fullname,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      uid: map['uid'] ?? '',
      fullname: map['fullname'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Client.fromJson(String source) => Client.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Client(uid: $uid, fullname: $fullname, email: $email, phone: $phone, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Client &&
        other.uid == uid &&
        other.fullname == fullname &&
        other.email == email &&
        other.phone == phone &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        fullname.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        imageUrl.hashCode;
  }
}
