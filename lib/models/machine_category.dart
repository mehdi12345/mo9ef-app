import 'dart:convert';

class MachineCategory {
  String uid;
  String name;
  String image;
  MachineCategory({
    required this.uid,
    required this.name,
    required this.image,
  });

  MachineCategory copyWith({
    String? uid,
    String? name,
    String? image,
  }) {
    return MachineCategory(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'image': image,
    };
  }

  factory MachineCategory.fromMap(Map<String, dynamic> map) {
    return MachineCategory(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MachineCategory.fromJson(String source) =>
      MachineCategory.fromMap(json.decode(source));

  @override
  String toString() => 'MachineCategory(uid: $uid, name: $name, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MachineCategory &&
        other.uid == uid &&
        other.name == name &&
        other.image == image;
  }

  @override
  int get hashCode => uid.hashCode ^ name.hashCode ^ image.hashCode;
}
