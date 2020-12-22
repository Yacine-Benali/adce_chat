import 'dart:io';

import 'package:adce_chat/app/models/chat_user.dart';
import 'package:adce_chat/services/api_path.dart';
import 'package:adce_chat/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ProfileBloc {
  ProfileBloc({
    @required this.user,
    @required this.database,
    @required this.uid,
  });
  final Database database;
  final ChatUser user;
  final String uid;

  Future<void> saveProfile(ChatUser user) async {
    await database.setData(
        path: APIPath.userDocument(uid), data: user.toMap(), merge: true);
  }

  Future<String> uploadProfileImage(PickedFile file) async {
    String downloadUrl = await database.uploadFile(
      file: File(file.path),
      path: APIPath.userImagesCollection(uid),
    );

    return downloadUrl;
  }
}
