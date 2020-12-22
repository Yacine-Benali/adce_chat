import 'dart:io';

import 'package:adce_chat/app/models/chat_user.dart';
import 'package:adce_chat/app/models/message.dart';
import 'package:adce_chat/services/api_path.dart';
import 'package:adce_chat/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ChatBloc {
  ChatBloc({
    @required this.database,
    @required this.otherUser,
    @required this.currentUser,
  });
  final Database database;
  final ChatUser currentUser;
  final ChatUser otherUser;

  String getGroupeChatId() {
    String groupChatId;

    if (currentUser.id.hashCode <= otherUser.id.hashCode) {
      groupChatId = '${currentUser.id}-${otherUser.id}';
    } else {
      groupChatId = '${otherUser.id}-${currentUser.id}';
    }
    return groupChatId;
  }

  Stream<List<Message>> getMessages() {
    return database.collectionStream(
      path: APIPath.messagesCollection(getGroupeChatId()),
      builder: (data, documentId) => Message.fromMap(data, documentId),
      queryBuilder: (query) => query.orderBy('timestamp', descending: true),
    );
  }

  bool checkMessageSender(Message message) {
    if (message.senderId == currentUser.id) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> sendMessage(String content, int type) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    Message message = Message(
      content: content,
      type: type,
      receiverId: this.otherUser.id,
      seen: false,
      senderId: this.currentUser.id,
      timestamp: timestamp,
      id: null,
    );
    database.addDocument(
      path: APIPath.messagesCollection(getGroupeChatId()),
      data: message.toMap(),
    );
  }

  Future<bool> sendImageMessage(PickedFile file, int type) async {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    var result = await await database.uploadFile(
      file: File(file.path),
      path: APIPath.messagesCollection(getGroupeChatId()) + '/$timestamp',
    );

    if (result != null) {
      String downloadUrl = result.toString();
      sendMessage(downloadUrl, 1);
      return true;
    } else {
      return false;
    }
  }

  // void setLatesttMessageToSeen(Message message) {
  //   message.seen = true;
  //   provider.updateLatestMessage(
  //     student.schoolName,
  //     conversation.groupChatId,
  //     message,
  //   );
  // }

  // void dispose() {
  //   // print('bloc stream diposed called');
  //   messagesListController.close();
  // }
}
