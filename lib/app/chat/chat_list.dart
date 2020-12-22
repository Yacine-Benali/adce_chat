import 'package:adce_chat/app/chat/chat_bloc.dart';
import 'package:adce_chat/app/chat/message_tile.dart';
import 'package:adce_chat/app/models/message.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key key, @required this.bloc}) : super(key: key);
  final ChatBloc bloc;

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Stream<List<Message>> messagesStream;
  List<Message> messages;
  ChatBloc bloc;
  bool isSelf = false;

  @override
  void initState() {
    bloc = widget.bloc;
    messagesStream = bloc.getMessages();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            messages = snapshot.data;
            if (messages.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  isSelf = bloc.checkMessageSender(messages[index]);

                  return MessageTile(
                    message: messages[index],
                    isSelf: isSelf,
                  );
                },
                itemCount: messages.length,
                reverse: true,
              );
            } else {
              return Container();
            }
          } else if (snapshot.hasError) {
            return Container();
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
