import 'dart:convert';

class Category {
  String uid;
  String name;
  Category({
    required this.uid,
    required this.name,
  });

  Category copyWith({
    String? uid,
    String? name,
  }) {
    return Category(
      uid: uid ?? this.uid,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  @override
  String toString() => 'Category(uid: $uid, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category && other.uid == uid && other.name == name;
  }

  @override
  int get hashCode => uid.hashCode ^ name.hashCode;
}
