import 'package:flutter/foundation.dart';

class ChatUser {
  ChatUser({
    @required this.username,
    @required this.id,
    @required this.aboutMe,
    @required this.photoUrl,
  });

  final String username;
  final String id;
  final String aboutMe;
  final String photoUrl;

  factory ChatUser.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String id = documentId;
    final String username = data['username'];
    final String aboutMe = data['aboutMe'];
    final String photoUrl = data['photoUrl'];
    return ChatUser(
      username: username,
      id: id,
      aboutMe: aboutMe,
      photoUrl: photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'aboutMe': aboutMe,
      'photoUrl': photoUrl,
    };
  }
}
