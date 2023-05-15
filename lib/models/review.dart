import 'dart:convert';

class Review {
  String uid;
  double rate;
  String comment;
  String date;
  String clientUid;
  Review({
    required this.uid,
    required this.rate,
    required this.comment,
    required this.date,
    required this.clientUid,
  });

  Review copyWith({
    String? uid,
    double? rate,
    String? comment,
    String? date,
    String? clientUid,
  }) {
    return Review(
      uid: uid ?? this.uid,
      rate: rate ?? this.rate,
      comment: comment ?? this.comment,
      date: date ?? this.date,
      clientUid: clientUid ?? this.clientUid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'rate': rate,
      'comment': comment,
      'date': date,
      'clientUid': clientUid,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      uid: map['uid'] ?? '',
      rate: map['rate']?.toDouble() ?? 0.0,
      comment: map['comment'] ?? '',
      date: map['date'] ?? '',
      clientUid: map['clientUid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Review(uid: $uid, rate: $rate, comment: $comment, date: $date, clientUid: $clientUid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Review &&
        other.uid == uid &&
        other.rate == rate &&
        other.comment == comment &&
        other.date == date &&
        other.clientUid == clientUid;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        rate.hashCode ^
        comment.hashCode ^
        date.hashCode ^
        clientUid.hashCode;
  }
}
