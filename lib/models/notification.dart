import 'dart:convert';

class Notif {
  String? id;
  String title;
  String body;
  Notif({
    this.id,
    required this.title,
    required this.body,
  });

  Notif copyWith({
    String? id,
    String? title,
    String? body,
  }) {
    return Notif(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
    };
  }

  factory Notif.fromMap(Map<String, dynamic> map) {
    return Notif(
      title: map['title'],
      body: map['body'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Notif.fromJson(String source) => Notif.fromMap(json.decode(source));

  @override
  String toString() => 'Notif(id: $id, title: $title, body: $body)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Notif &&
        other.id == id &&
        other.title == title &&
        other.body == body;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ body.hashCode;
}
