import 'package:adce_chat/app/models/chat_user.dart';
import 'package:adce_chat/services/api_path.dart';
import 'package:adce_chat/services/database.dart';
import 'package:flutter/foundation.dart';

class ConversationsBloc {
  ConversationsBloc({@required this.database, @required this.user});

  final Database database;
  final ChatUser user;

  Stream<List<ChatUser>> getUsers() {
    return database.collectionStream(
      path: APIPath.usersCollections(),
      builder: (data, documentId) => ChatUser.fromMap(data, documentId),
    );
  }
}
