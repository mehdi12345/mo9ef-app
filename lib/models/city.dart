import 'dart:convert';

class City {
  String name;
  String region;
  City({
    required this.name,
    required this.region,
  });

  City copyWith({
    String? name,
    String? region,
  }) {
    return City(
      name: name ?? this.name,
      region: region ?? this.region,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'region': region,
    };
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      name: map['city'] ?? '',
      region: map['region'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory City.fromJson(String source) => City.fromMap(json.decode(source));

  @override
  String toString() => 'City(name: $name, region: $region)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is City && other.name == name && other.region == region;
  }

  @override
  int get hashCode => name.hashCode ^ region.hashCode;
}
