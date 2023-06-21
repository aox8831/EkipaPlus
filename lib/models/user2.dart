import 'package:ekipa_plus/utils/utils2.dart';
import 'package:meta/meta.dart';

class UserField2 {
  static final String lastMessageTime = 'lastMessageTime';
}

class User2 {
  final String uid;
  final String username;
  final String photoUrl;
  final DateTime lastMessageTime;

  const User2({
    required this.uid,
    required this.username,
    required this.photoUrl,
    required this.lastMessageTime,
  });

  User2 copyWith({
    String? uid,
    String? username,
    String? photoUrl,
    DateTime? lastMessageTime,
  }) =>
      User2(
        uid: uid ?? this.uid,
        username: username ?? this.username,
        photoUrl: photoUrl ?? this.photoUrl,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      );

  static User2 fromJson(Map<String, dynamic> json) => User2(
        uid: json['uid'],
        username: json['username'],
        photoUrl: json['photoUrl'],
        lastMessageTime: Utils2.toDateTime(json['lastMessageTime'])!,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'photoUrl': photoUrl,
        'lastMessageTime': Utils2.fromDateTimeToJson(lastMessageTime),
      };
}